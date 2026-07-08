import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, RefreshControl, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuth } from '../../context/AuthContext';
import api from '../../api/client';
import { colors } from '../../constants/colors';

export default function ProductsScreen() {
  const [products, setProducts] = useState([]);
  const { isAuthenticated } = useAuth();

  useEffect(() => { fetchData(); }, []);

  async function fetchData() {
    try {
      const { data } = await api.get('/products/my/purchases');
      setProducts(Array.isArray(data) ? data : []);
    } catch {
      try { const { data } = await api.get('/products'); setProducts(Array.isArray(data) ? data : []); } catch {}
    }
  }

  async function handleDownload(product) {
    try {
      const { data } = await api.post(`/products/purchase`, { productId: product._id });
      Alert.alert('Download Started', 'Your purchase is being processed.');
    } catch (e) {
      Alert.alert('Error', e.response?.data?.message || 'Please login to purchase');
    }
  }

  return (
    <ScrollView style={styles.container}>
      <LinearGradient colors={['rgba(139,92,246,0.04)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>Digital Products</Text>
        <Text style={styles.subtitle}>{products.length} available</Text>
      </View>
      {products.length === 0 ? (
        <Text style={styles.empty}>No products available</Text>
      ) : (
        products.map((p) => (
          <View key={p._id} style={styles.productCard}>
            <Text style={styles.productName}>{p.name}</Text>
            <Text style={styles.productDesc} numberOfLines={2}>{p.description}</Text>
            <View style={styles.productFooter}>
              <Text style={styles.productPrice}>₹{p.price?.toLocaleString() || 'Free'}</Text>
              <TouchableOpacity style={styles.downloadBtn} onPress={() => handleDownload(p)}>
                <Text style={styles.downloadText}>{isAuthenticated ? 'Purchase' : 'Login to Buy'}</Text>
              </TouchableOpacity>
            </View>
          </View>
        ))
      )}
      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 150 },
  header: { paddingHorizontal: 20, paddingTop: 56, paddingBottom: 16 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  subtitle: { fontSize: 13, color: colors.textMuted, marginTop: 4 },
  empty: { textAlign: 'center', color: colors.textMuted, marginTop: 40, fontSize: 14 },
  productCard: { marginHorizontal: 16, marginVertical: 6, backgroundColor: colors.cardBg, borderRadius: 14, padding: 16, borderWidth: 1, borderColor: colors.border },
  productName: { fontSize: 15, fontWeight: '700', color: colors.textPrimary },
  productDesc: { fontSize: 13, color: colors.textSecondary, marginTop: 6, lineHeight: 18 },
  productFooter: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginTop: 12 },
  productPrice: { fontSize: 16, fontWeight: '700', color: colors.neonCyan },
  downloadBtn: { backgroundColor: colors.electricViolet + '20', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 10, borderWidth: 1, borderColor: colors.electricViolet + '30' },
  downloadText: { color: colors.electricViolet, fontSize: 12, fontWeight: '600' },
});
