import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, RefreshControl } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuth } from '../../context/AuthContext';
import api from '../../api/client';
import ServiceCard from '../../components/ServiceCard';
import CategoryCard from '../../components/CategoryCard';
import { colors } from '../../constants/colors';

const categoryIcons = {
  'Website Development': '🌐', 'App Development': '📱', 'Marketing': '📈',
  'Remote Support': '🖥️', 'Troubleshooting': '🔧', 'Design': '🎨', 'Data Recovery': '💾',
};

export default function HomeScreen({ navigation }) {
  const { user } = useAuth();
  const [services, setServices] = useState([]);
  const [categories, setCategories] = useState([]);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    fetchData();
  }, []);

  async function fetchData() {
    try {
      const { data } = await api.get('/services');
      setServices(Array.isArray(data) ? data : []);
      const cats = [...new Set((Array.isArray(data) ? data : []).map(s => s.category))];
      setCategories(cats);
    } catch {}
  }

  function onRefresh() {
    setRefreshing(true);
    fetchData().finally(() => setRefreshing(false));
  }

  const featured = services.filter(s => s.featured).slice(0, 5);
  const categoryCounts = categories.map(c => ({ name: c, count: services.filter(s => s.category === c).length }));

  return (
    <ScrollView style={styles.container} refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={colors.neonCyan} />}>
      <LinearGradient colors={['rgba(0,229,255,0.06)', 'transparent']} style={styles.headerGrad} />
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Hello{user ? `, ${user.name}` : ''} 👋</Text>
          <Text style={styles.tagline}>Calcutta Node.</Text>
        </View>
        <TouchableOpacity style={styles.aiButton} onPress={() => navigation.navigate('AIChat')}>
          <Text style={styles.aiIcon}>🤖</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.quickStats}>
        <View style={styles.statItem}>
          <Text style={styles.statValue}>{services.length}</Text>
          <Text style={styles.statLabel}>Services</Text>
        </View>
        <View style={styles.statDivider} />
        <View style={styles.statItem}>
          <Text style={styles.statValue}>{categories.length}</Text>
          <Text style={styles.statLabel}>Categories</Text>
        </View>
        <View style={styles.statDivider} />
        <View style={styles.statItem}>
          <Text style={styles.statValue}>🌐</Text>
          <Text style={styles.statLabel}>Worldwide</Text>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Categories</Text>
      </View>
      <View style={styles.categoryGrid}>
        {categoryCounts.map((cat) => (
          <CategoryCard key={cat.name} name={cat.name} count={cat.count} onPress={() => navigation.navigate('ServicesList', { category: cat.name })} />
        ))}
      </View>

      {featured.length > 0 && (
        <>
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Featured Services</Text>
          </View>
          {featured.map((s) => (
            <ServiceCard key={s._id} service={s} onPress={(svc) => navigation.navigate('ServiceDetail', { service: svc })} />
          ))}
        </>
      )}

      <TouchableOpacity style={styles.browseAll} onPress={() => navigation.navigate('ServicesList', {})}>
        <Text style={styles.browseAllText}>Browse All Services →</Text>
      </TouchableOpacity>

      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  headerGrad: { position: 'absolute', top: 0, left: 0, right: 0, height: 200 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingTop: 60, paddingBottom: 20 },
  greeting: { fontSize: 14, color: colors.textSecondary },
  tagline: { fontSize: 24, fontWeight: '800', color: colors.textPrimary, marginTop: 2 },
  aiButton: { width: 44, height: 44, borderRadius: 22, backgroundColor: colors.surface, justifyContent: 'center', alignItems: 'center', borderWidth: 1, borderColor: 'rgba(0,229,255,0.3)' },
  aiIcon: { fontSize: 22 },
  quickStats: { flexDirection: 'row', marginHorizontal: 20, backgroundColor: colors.cardBg, borderRadius: 16, padding: 16, borderWidth: 1, borderColor: colors.border, marginBottom: 20 },
  statItem: { flex: 1, alignItems: 'center' },
  statValue: { fontSize: 20, fontWeight: '800', color: colors.neonCyan },
  statLabel: { fontSize: 11, color: colors.textMuted, marginTop: 2 },
  statDivider: { width: 1, backgroundColor: colors.border },
  section: { paddingHorizontal: 20, marginBottom: 12 },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: colors.textPrimary },
  categoryGrid: { flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 16, justifyContent: 'space-between' },
  browseAll: { alignItems: 'center', paddingVertical: 16, marginTop: 8 },
  browseAllText: { color: colors.neonCyan, fontSize: 14, fontWeight: '600' },
});
