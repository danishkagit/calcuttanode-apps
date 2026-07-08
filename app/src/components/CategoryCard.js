import React from 'react';
import { Text, TouchableOpacity, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../constants/colors';

const icons = {
  'Website Development': '🌐',
  'App Development': '📱',
  'Marketing': '📈',
  'Remote Support': '🖥️',
  'Troubleshooting': '🔧',
  'Design': '🎨',
  'Data Recovery': '💾',
};

export default function CategoryCard({ name, count, onPress }) {
  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.8} style={styles.wrapper}>
      <LinearGradient colors={['rgba(0,229,255,0.08)', 'rgba(139,92,246,0.04)']} style={styles.card}>
        <Text style={styles.icon}>{icons[name] || '📦'}</Text>
        <Text style={styles.name} numberOfLines={1}>{name}</Text>
        {count !== undefined && <Text style={styles.count}>{count} services</Text>}
      </LinearGradient>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  wrapper: { width: '48%', marginBottom: 12 },
  card: {
    borderRadius: 16,
    padding: 16,
    borderWidth: 1,
    borderColor: 'rgba(0,229,255,0.12)',
    alignItems: 'center',
  },
  icon: { fontSize: 28, marginBottom: 8 },
  name: { fontSize: 13, fontWeight: '600', color: colors.textPrimary, textAlign: 'center' },
  count: { fontSize: 11, color: colors.textMuted, marginTop: 4 },
});
