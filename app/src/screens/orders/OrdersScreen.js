import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, RefreshControl } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import api from '../../api/client';
import { colors } from '../../constants/colors';

const statusColors = { pending: '#F59E0B', 'in-progress': '#7EBBC5', completed: '#10B981', cancelled: '#EF4444' };

export default function OrdersScreen() {
  const [orders, setOrders] = useState([]);
  const [refreshing, setRefreshing] = useState(false);
  const [filter, setFilter] = useState('all');

  useEffect(() => { fetchOrders(); }, []);

  async function fetchOrders() {
    try {
      const { data } = await api.get('/dashboard/orders');
      setOrders(Array.isArray(data) ? data : []);
    } catch {}
  }

  function onRefresh() {
    setRefreshing(true);
    fetchOrders().finally(() => setRefreshing(false));
  }

  const filtered = filter === 'all' ? orders : orders.filter(o => o.status === filter);

  return (
    <ScrollView style={styles.container} refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={colors.neonCyan} />}>
      <LinearGradient colors={['rgba(0,229,255,0.04)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>My Orders</Text>
        <Text style={styles.count}>{orders.length} total</Text>
      </View>
      <View style={styles.filterRow}>
        {['all', 'pending', 'in-progress', 'completed', 'cancelled'].map((f) => (
          <TouchableOpacity key={f} style={[styles.filterChip, filter === f && styles.filterChipActive]} onPress={() => setFilter(f)}>
            <Text style={[styles.filterText, filter === f && styles.filterTextActive]}>{f.charAt(0).toUpperCase() + f.slice(1)}</Text>
          </TouchableOpacity>
        ))}
      </View>
      {filtered.length === 0 ? (
        <Text style={styles.empty}>No orders found</Text>
      ) : (
        filtered.map((order) => (
          <View key={order._id} style={styles.orderCard}>
            <View style={styles.orderHeader}>
              <Text style={styles.orderService}>{order.service?.name || 'Service'}</Text>
              <View style={[styles.statusBadge, { backgroundColor: (statusColors[order.status] || '#6B7280') + '20' }]}>
                <Text style={[styles.statusText, { color: statusColors[order.status] || colors.textMuted }]}>{order.status}</Text>
              </View>
            </View>
            <Text style={styles.orderDate}>{new Date(order.createdAt).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })}</Text>
            {order.amount && <Text style={styles.orderAmount}>₹{order.amount.toLocaleString()}</Text>}
          </View>
        ))
      )}
      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 150 },
  header: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 12 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  count: { fontSize: 13, color: colors.textMuted, marginTop: 4 },
  filterRow: { flexDirection: 'row', paddingHorizontal: 16, gap: 8, marginBottom: 16, flexWrap: 'wrap' },
  filterChip: { paddingHorizontal: 14, paddingVertical: 6, borderRadius: 20, backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border },
  filterChipActive: { backgroundColor: colors.neonCyan + '20', borderColor: colors.neonCyan },
  filterText: { fontSize: 12, color: colors.textMuted, fontWeight: '500' },
  filterTextActive: { color: colors.neonCyan, fontWeight: '600' },
  empty: { textAlign: 'center', color: colors.textMuted, marginTop: 40, fontSize: 14 },
  orderCard: { marginHorizontal: 16, marginVertical: 6, backgroundColor: colors.cardBg, borderRadius: 14, padding: 16, borderWidth: 1, borderColor: colors.border },
  orderHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  orderService: { fontSize: 15, fontWeight: '600', color: colors.textPrimary, flex: 1 },
  statusBadge: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  statusText: { fontSize: 11, fontWeight: '600' },
  orderDate: { fontSize: 12, color: colors.textMuted, marginTop: 6 },
  orderAmount: { fontSize: 16, fontWeight: '700', color: colors.neonCyan, marginTop: 4 },
});
