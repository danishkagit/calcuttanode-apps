import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { colors } from '../constants/colors';

export default function ServiceCard({ service, onPress }) {
  return (
    <TouchableOpacity style={styles.card} onPress={() => onPress(service)} activeOpacity={0.8}>
      <View style={styles.header}>
        <Text style={styles.category}>{service.category}</Text>
        <Text style={styles.price}>₹{service.price?.toLocaleString()}</Text>
      </View>
      <Text style={styles.title}>{service.name}</Text>
      <Text style={styles.desc} numberOfLines={2}>{service.description}</Text>
      {service.features && (
        <View style={styles.features}>
          {service.features.slice(0, 3).map((f, i) => (
            <Text key={i} style={styles.feature}>✦ {f}</Text>
          ))}
          {service.features.length > 3 && (
            <Text style={styles.more}>+{service.features.length - 3} more</Text>
          )}
        </View>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.cardBg,
    borderRadius: 16,
    padding: 16,
    marginHorizontal: 16,
    marginVertical: 6,
    borderWidth: 1,
    borderColor: colors.border,
  },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 },
  category: { fontSize: 11, color: colors.electricViolet, fontWeight: '600', textTransform: 'uppercase', letterSpacing: 0.5 },
  price: { fontSize: 13, color: colors.neonCyan, fontWeight: '700' },
  title: { fontSize: 16, fontWeight: '700', color: colors.textPrimary, marginBottom: 4 },
  desc: { fontSize: 13, color: colors.textSecondary, lineHeight: 18, marginBottom: 10 },
  features: { gap: 3 },
  feature: { fontSize: 12, color: colors.textMuted },
  more: { fontSize: 11, color: colors.neonCyan, marginTop: 2 },
});
