import React from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuth } from '../../context/AuthContext';
import { colors } from '../../constants/colors';
import { COMPANY_INFO } from '../../constants/config';

export default function ProfileScreen({ navigation }) {
  const { user, logout } = useAuth();

  const infoRows = [
    { label: 'Name', value: user?.name },
    { label: 'Email', value: user?.email },
    { label: 'Phone', value: user?.phone },
    { label: 'Role', value: user?.role },
  ];

  return (
    <ScrollView style={styles.container}>
      <LinearGradient colors={['rgba(139,92,246,0.04)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>Profile</Text>
      </View>

      <View style={styles.avatarSection}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{user?.name?.charAt(0)?.toUpperCase() || 'U'}</Text>
        </View>
      </View>

      <View style={styles.infoCard}>
        {infoRows.map((row, i) => (
          row.value && (
            <View key={i} style={[styles.infoRow, i < infoRows.length - 1 && styles.infoBorder]}>
              <Text style={styles.infoLabel}>{row.label}</Text>
              <Text style={styles.infoValue}>{row.value}</Text>
            </View>
          )
        ))}
      </View>

      <TouchableOpacity style={styles.logoutButton} onPress={logout}>
        <Text style={styles.logoutText}>Logout</Text>
      </TouchableOpacity>

      <View style={styles.footer}>
        <Text style={styles.footerText}>{COMPANY_INFO.name}</Text>
        <Text style={styles.footerSub}>{COMPANY_INFO.email}</Text>
      </View>

      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 200 },
  header: { paddingHorizontal: 20, paddingTop: 56, paddingBottom: 16 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  avatarSection: { alignItems: 'center', marginBottom: 24 },
  avatar: { width: 80, height: 80, borderRadius: 40, backgroundColor: colors.electricViolet + '30', justifyContent: 'center', alignItems: 'center', borderWidth: 2, borderColor: colors.electricViolet },
  avatarText: { fontSize: 32, fontWeight: '800', color: colors.electricViolet },
  infoCard: { marginHorizontal: 16, backgroundColor: colors.cardBg, borderRadius: 16, borderWidth: 1, borderColor: colors.border, overflow: 'hidden' },
  infoRow: { flexDirection: 'row', justifyContent: 'space-between', paddingHorizontal: 16, paddingVertical: 14 },
  infoBorder: { borderBottomWidth: 1, borderBottomColor: colors.border },
  infoLabel: { fontSize: 13, color: colors.textMuted },
  infoValue: { fontSize: 14, color: colors.textPrimary, fontWeight: '500', maxWidth: '60%', textAlign: 'right' },
  logoutButton: { marginHorizontal: 16, marginTop: 24, backgroundColor: colors.error + '15', borderRadius: 14, padding: 16, alignItems: 'center', borderWidth: 1, borderColor: colors.error + '30' },
  logoutText: { color: colors.error, fontSize: 15, fontWeight: '700' },
  footer: { alignItems: 'center', marginTop: 32 },
  footerText: { fontSize: 12, color: colors.textMuted },
  footerSub: { fontSize: 11, color: colors.textMuted, marginTop: 2 },
});
