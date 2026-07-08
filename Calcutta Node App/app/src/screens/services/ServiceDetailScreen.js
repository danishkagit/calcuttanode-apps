import React from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuth } from '../../context/AuthContext';
import api from '../../api/client';
import { colors } from '../../constants/colors';

export default function ServiceDetailScreen({ route, navigation }) {
  const { service } = route.params;
  const { isAuthenticated } = useAuth();

  async function handleBook() {
    if (!isAuthenticated) {
      Alert.alert('Login Required', 'Please login to book a service', [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Login', onPress: () => navigation.navigate('Login') },
      ]);
      return;
    }
    try {
      await api.post('/dashboard/order', { serviceId: service._id });
      Alert.alert('Order Placed!', 'Your service has been booked successfully.', [
        { text: 'Track Order', onPress: () => navigation.navigate('Orders') },
        { text: 'OK' },
      ]);
    } catch (e) {
      Alert.alert('Error', e.response?.data?.message || 'Failed to place order');
    }
  }

  return (
    <ScrollView style={styles.container}>
      <LinearGradient colors={['rgba(0,229,255,0.06)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.category}>{service.category}</Text>
        <Text style={styles.price}>₹{service.price?.toLocaleString()}</Text>
      </View>
      <Text style={styles.title}>{service.name}</Text>
      <Text style={styles.desc}>{service.description}</Text>

      {service.features && service.features.length > 0 && (
        <View style={styles.featuresCard}>
          <Text style={styles.featuresTitle}>What's Included</Text>
          {service.features.map((f, i) => (
            <View key={i} style={styles.featureRow}>
              <Text style={styles.checkMark}>✓</Text>
              <Text style={styles.featureText}>{f}</Text>
            </View>
          ))}
        </View>
      )}

      <TouchableOpacity style={styles.bookButton} onPress={handleBook}>
        <Text style={styles.bookText}>Book This Service</Text>
      </TouchableOpacity>

      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 200 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingTop: 60, paddingBottom: 8 },
  category: { fontSize: 12, color: colors.electricViolet, fontWeight: '600', textTransform: 'uppercase', letterSpacing: 1 },
  price: { fontSize: 24, fontWeight: '800', color: colors.neonCyan },
  title: { fontSize: 24, fontWeight: '800', color: colors.textPrimary, paddingHorizontal: 20, marginBottom: 12 },
  desc: { fontSize: 14, color: colors.textSecondary, paddingHorizontal: 20, lineHeight: 22, marginBottom: 24 },
  featuresCard: { marginHorizontal: 20, backgroundColor: colors.cardBg, borderRadius: 16, padding: 20, borderWidth: 1, borderColor: colors.border },
  featuresTitle: { fontSize: 15, fontWeight: '700', color: colors.textPrimary, marginBottom: 14 },
  featureRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 10 },
  checkMark: { fontSize: 14, color: colors.neonCyan, fontWeight: '700', marginRight: 10, width: 20 },
  featureText: { fontSize: 14, color: colors.textSecondary, flex: 1 },
  bookButton: { marginHorizontal: 20, marginTop: 28, backgroundColor: colors.neonCyan, borderRadius: 14, padding: 16, alignItems: 'center' },
  bookText: { color: colors.black, fontSize: 16, fontWeight: '700' },
});
