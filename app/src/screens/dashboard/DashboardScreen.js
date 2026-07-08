import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, RefreshControl } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuth } from '../../context/AuthContext';
import api from '../../api/client';
import { colors } from '../../constants/colors';

const menuItems = [
  { key: 'orders', label: 'My Orders', icon: '📋', screen: 'Orders' },
  { key: 'wallet', label: 'Wallet', icon: '💰', screen: 'Wallet' },
  { key: 'subscription', label: 'Subscriptions', icon: '📅', screen: 'Subscriptions' },
  { key: 'products', label: 'Purchases', icon: '📦', screen: 'Products' },
  { key: 'profile', label: 'Profile', icon: '👤', screen: 'Profile' },
];

export default function DashboardScreen({ navigation }) {
  const { user, logout, refreshUser } = useAuth();
  const [overview, setOverview] = useState(null);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    fetchOverview();
  }, []);

  async function fetchOverview() {
    try {
      const { data } = await api.get('/dashboard/overview');
      setOverview(data);
    } catch {}
  }

  function onRefresh() {
    setRefreshing(true);
    Promise.all([fetchOverview(), refreshUser()]).finally(() => setRefreshing(false));
  }

  return (
    <ScrollView style={styles.container} refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={colors.neonCyan} />}>
      <LinearGradient colors={['rgba(0,229,255,0.06)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>Dashboard</Text>
        <TouchableOpacity onPress={logout} style={styles.logoutBtn}>
          <Text style={styles.logoutText}>Logout</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.profileCard}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{user?.name?.charAt(0) || 'U'}</Text>
        </View>
        <View>
          <Text style={styles.userName}>{user?.name || 'User'}</Text>
          <Text style={styles.userEmail}>{user?.email || ''}</Text>
        </View>
      </View>

      {overview && (
        <View style={styles.statsRow}>
          <View style={styles.statBox}>
            <Text style={styles.statValue}>{overview.activeOrders || 0}</Text>
            <Text style={styles.statLabel}>Active Orders</Text>
          </View>
          <View style={styles.statBox}>
            <Text style={styles.statValue}>₹{overview.walletBalance || 0}</Text>
            <Text style={styles.statLabel}>Wallet</Text>
          </View>
          <View style={styles.statBox}>
            <Text style={styles.statValue}>{overview.loyaltyPoints || 0}</Text>
            <Text style={styles.statLabel}>Points</Text>
          </View>
          <View style={styles.statBox}>
            <Text style={styles.statValue}>₹{overview.referralEarnings || 0}</Text>
            <Text style={styles.statLabel}>Referrals</Text>
          </View>
        </View>
      )}

      <View style={styles.menuGrid}>
        {menuItems.map((item) => (
          <TouchableOpacity key={item.key} style={styles.menuCard} onPress={() => navigation.navigate(item.screen)}>
            <Text style={styles.menuIcon}>{item.icon}</Text>
            <Text style={styles.menuLabel}>{item.label}</Text>
          </TouchableOpacity>
        ))}
      </View>

      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 200 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingTop: 56, paddingBottom: 16 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  logoutBtn: { paddingHorizontal: 14, paddingVertical: 6, borderRadius: 8, backgroundColor: colors.error + '20' },
  logoutText: { color: colors.error, fontSize: 12, fontWeight: '600' },
  profileCard: { flexDirection: 'row', alignItems: 'center', marginHorizontal: 16, backgroundColor: colors.cardBg, borderRadius: 16, padding: 16, borderWidth: 1, borderColor: colors.border, marginBottom: 16 },
  avatar: { width: 48, height: 48, borderRadius: 24, backgroundColor: colors.electricViolet + '30', justifyContent: 'center', alignItems: 'center', marginRight: 14 },
  avatarText: { fontSize: 20, fontWeight: '700', color: colors.electricViolet },
  userName: { fontSize: 16, fontWeight: '700', color: colors.textPrimary },
  userEmail: { fontSize: 12, color: colors.textMuted, marginTop: 2 },
  statsRow: { flexDirection: 'row', flexWrap: 'wrap', marginHorizontal: 12, gap: 8, marginBottom: 20 },
  statBox: { flex: 1, minWidth: '45%', backgroundColor: colors.cardBg, borderRadius: 12, padding: 14, borderWidth: 1, borderColor: colors.border, alignItems: 'center' },
  statValue: { fontSize: 18, fontWeight: '800', color: colors.neonCyan },
  statLabel: { fontSize: 11, color: colors.textMuted, marginTop: 4 },
  menuGrid: { flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 12, gap: 10 },
  menuCard: { width: '30%', flex: 1, minWidth: 100, backgroundColor: colors.cardBg, borderRadius: 14, padding: 16, borderWidth: 1, borderColor: colors.border, alignItems: 'center' },
  menuIcon: { fontSize: 28, marginBottom: 8 },
  menuLabel: { fontSize: 12, color: colors.textSecondary, fontWeight: '500', textAlign: 'center' },
});
