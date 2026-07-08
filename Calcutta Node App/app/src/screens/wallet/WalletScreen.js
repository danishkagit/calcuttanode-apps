import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, StyleSheet, RefreshControl } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import api from '../../api/client';
import { colors } from '../../constants/colors';

export default function WalletScreen() {
  const [balance, setBalance] = useState(0);
  const [transactions, setTransactions] = useState([]);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => { fetchData(); }, []);

  async function fetchData() {
    try {
      const [walletRes, txRes] = await Promise.all([
        api.get('/dashboard/wallet'),
        api.get('/dashboard/transactions'),
      ]);
      setBalance(walletRes.data?.balance || 0);
      setTransactions(Array.isArray(txRes.data) ? txRes.data : []);
    } catch {}
  }

  function onRefresh() {
    setRefreshing(true);
    fetchData().finally(() => setRefreshing(false));
  }

  return (
    <ScrollView style={styles.container} refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={colors.neonCyan} />}>
      <LinearGradient colors={['rgba(0,229,255,0.06)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>Wallet</Text>
      </View>
      <View style={styles.balanceCard}>
        <Text style={styles.balanceLabel}>Available Balance</Text>
        <Text style={styles.balanceAmount}>₹{balance.toLocaleString()}</Text>
      </View>
      <Text style={styles.sectionTitle}>Transactions</Text>
      {transactions.length === 0 ? (
        <Text style={styles.empty}>No transactions yet</Text>
      ) : (
        transactions.map((tx) => (
          <View key={tx._id} style={styles.txCard}>
            <View style={styles.txLeft}>
              <Text style={styles.txType}>{tx.type || 'Transaction'}</Text>
              <Text style={styles.txDate}>{new Date(tx.createdAt).toLocaleDateString()}</Text>
            </View>
            <Text style={[styles.txAmount, tx.type === 'credit' ? styles.credit : styles.debit]}>
              {tx.type === 'credit' ? '+' : '-'}₹{Math.abs(tx.amount || 0).toLocaleString()}
            </Text>
          </View>
        ))
      )}
      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 200 },
  header: { paddingHorizontal: 20, paddingTop: 56, paddingBottom: 16 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  balanceCard: { marginHorizontal: 16, backgroundColor: colors.cardBg, borderRadius: 20, padding: 24, borderWidth: 1, borderColor: colors.border, alignItems: 'center', marginBottom: 24 },
  balanceLabel: { fontSize: 13, color: colors.textMuted },
  balanceAmount: { fontSize: 36, fontWeight: '900', color: colors.neonCyan, marginTop: 8 },
  sectionTitle: { fontSize: 16, fontWeight: '700', color: colors.textPrimary, paddingHorizontal: 20, marginBottom: 12 },
  empty: { textAlign: 'center', color: colors.textMuted, marginTop: 20, fontSize: 14 },
  txCard: { marginHorizontal: 16, marginVertical: 4, backgroundColor: colors.cardBg, borderRadius: 12, padding: 14, borderWidth: 1, borderColor: colors.border, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  txLeft: { flex: 1 },
  txType: { fontSize: 14, fontWeight: '600', color: colors.textPrimary },
  txDate: { fontSize: 11, color: colors.textMuted, marginTop: 2 },
  txAmount: { fontSize: 15, fontWeight: '700' },
  credit: { color: colors.success },
  debit: { color: colors.error },
});
