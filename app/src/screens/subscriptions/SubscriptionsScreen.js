import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuth } from '../../context/AuthContext';
import api from '../../api/client';
import { colors } from '../../constants/colors';

export default function SubscriptionsScreen() {
  const { isAuthenticated } = useAuth();
  const [plans, setPlans] = useState([]);
  const [activeSub, setActiveSub] = useState(null);

  useEffect(() => {
    fetchPlans();
    if (isAuthenticated) fetchActive();
  }, [isAuthenticated]);

  async function fetchPlans() {
    try { const { data } = await api.get('/subscriptions/plans'); setPlans(Array.isArray(data) ? data : []); } catch {}
  }

  async function fetchActive() {
    try { const { data } = await api.get('/subscriptions/my'); setActiveSub(data); } catch {}
  }

  async function handleSubscribe(planId) {
    if (!isAuthenticated) { Alert.alert('Login Required', 'Please login to subscribe'); return; }
    try {
      await api.post('/subscriptions/subscribe', { planId });
      Alert.alert('Subscribed!', 'Your subscription is active.');
      fetchActive();
    } catch (e) {
      Alert.alert('Error', e.response?.data?.message || 'Failed to subscribe');
    }
  }

  return (
    <ScrollView style={styles.container}>
      <LinearGradient colors={['rgba(0,229,255,0.04)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>Membership Plans</Text>
        {activeSub && <Text style={styles.activeTag}>Active: {activeSub.plan?.name}</Text>}
      </View>
      {plans.map((plan) => (
        <View key={plan._id} style={styles.planCard}>
          {plan.badge && <View style={styles.badge}><Text style={styles.badgeText}>{plan.badge}</Text></View>}
          <Text style={styles.planName}>{plan.name}</Text>
          <Text style={styles.planPrice}>₹{plan.price}/mo</Text>
          <Text style={styles.planDuration}>{plan.duration} days</Text>
          {plan.features?.map((f, i) => (
            <View key={i} style={styles.featureRow}>
              <Text style={styles.check}>✓</Text>
              <Text style={styles.featureText}>{f}</Text>
            </View>
          ))}
          <TouchableOpacity style={styles.subscribeBtn} onPress={() => handleSubscribe(plan._id)}>
            <Text style={styles.subscribeText}>{activeSub?.plan?._id === plan._id ? 'Active' : 'Subscribe'}</Text>
          </TouchableOpacity>
        </View>
      ))}
      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 150 },
  header: { paddingHorizontal: 20, paddingTop: 56, paddingBottom: 16 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  activeTag: { fontSize: 13, color: colors.success, marginTop: 4 },
  planCard: { marginHorizontal: 16, marginVertical: 8, backgroundColor: colors.cardBg, borderRadius: 20, padding: 20, borderWidth: 1, borderColor: colors.border, position: 'relative' },
  badge: { position: 'absolute', top: 12, right: 12, backgroundColor: colors.neonCyan + '20', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 8, borderWidth: 1, borderColor: colors.neonCyan },
  badgeText: { fontSize: 10, color: colors.neonCyan, fontWeight: '600' },
  planName: { fontSize: 18, fontWeight: '700', color: colors.textPrimary, marginBottom: 4 },
  planPrice: { fontSize: 28, fontWeight: '900', color: colors.neonCyan },
  planDuration: { fontSize: 12, color: colors.textMuted, marginBottom: 16 },
  featureRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 8 },
  check: { fontSize: 14, color: colors.success, marginRight: 8, fontWeight: '700' },
  featureText: { fontSize: 13, color: colors.textSecondary, flex: 1 },
  subscribeBtn: { marginTop: 16, backgroundColor: colors.neonCyan, borderRadius: 12, padding: 14, alignItems: 'center' },
  subscribeText: { color: colors.black, fontSize: 15, fontWeight: '700' },
});
