import React, { useState, useEffect, useMemo } from 'react';
import { View, Text, ScrollView, TextInput, StyleSheet } from 'react-native';
import api from '../../api/client';
import ServiceCard from '../../components/ServiceCard';
import { colors } from '../../constants/colors';

export default function ServicesListScreen({ route, navigation }) {
  const initialCategory = route.params?.category || '';
  const [services, setServices] = useState([]);
  const [search, setSearch] = useState('');

  useEffect(() => {
    api.get('/services').then(({ data }) => setServices(Array.isArray(data) ? data : [])).catch(() => {});
  }, []);

  const filtered = useMemo(() => {
    let list = services;
    if (initialCategory) list = list.filter(s => s.category === initialCategory);
    if (search) {
      const q = search.toLowerCase();
      list = list.filter(s => s.name?.toLowerCase().includes(q) || s.description?.toLowerCase().includes(q) || s.category?.toLowerCase().includes(q));
    }
    return list;
  }, [services, search, initialCategory]);

  const grouped = useMemo(() => {
    if (initialCategory) return { [initialCategory]: filtered };
    const map = {};
    filtered.forEach(s => { (map[s.category] = map[s.category] || []).push(s); });
    return map;
  }, [filtered, initialCategory]);

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>{initialCategory || 'All Services'}</Text>
        <Text style={styles.count}>{filtered.length} services</Text>
      </View>
      <TextInput style={styles.search} placeholder="Search services..." placeholderTextColor={colors.textMuted} value={search} onChangeText={setSearch} />
      {Object.entries(grouped).map(([cat, items]) => (
        <View key={cat}>
          {!initialCategory && <Text style={styles.categoryTitle}>{cat}</Text>}
          {items.map(s => (
            <ServiceCard key={s._id} service={s} onPress={(svc) => navigation.navigate('ServiceDetail', { service: svc })} />
          ))}
        </View>
      ))}
      {filtered.length === 0 && <Text style={styles.empty}>No services found</Text>}
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 12 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  count: { fontSize: 13, color: colors.textMuted, marginTop: 4 },
  search: { backgroundColor: colors.surface, borderRadius: 12, marginHorizontal: 16, padding: 14, fontSize: 14, color: colors.textPrimary, borderWidth: 1, borderColor: colors.border, marginBottom: 8 },
  categoryTitle: { fontSize: 16, fontWeight: '700', color: colors.textSecondary, paddingHorizontal: 20, paddingTop: 16, paddingBottom: 4, textTransform: 'uppercase', letterSpacing: 1 },
  empty: { textAlign: 'center', color: colors.textMuted, marginTop: 40, fontSize: 14 },
});
