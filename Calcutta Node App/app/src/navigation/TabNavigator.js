import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Text, View, StyleSheet } from 'react-native';
import HomeScreen from '../screens/home/HomeScreen';
import ServicesListScreen from '../screens/services/ServicesListScreen';
import OrdersScreen from '../screens/orders/OrdersScreen';
import AIChatScreen from '../screens/ai/AIChatScreen';
import DashboardScreen from '../screens/dashboard/DashboardScreen';
import { colors } from '../constants/colors';

const Tab = createBottomTabNavigator();

function TabIcon({ icon, label, focused }) {
  return (
    <View style={tabStyles.iconContainer}>
      <Text style={[tabStyles.icon, focused && tabStyles.iconActive]}>{icon}</Text>
      <Text style={[tabStyles.label, focused && tabStyles.labelActive]}>{label}</Text>
    </View>
  );
}

const tabStyles = StyleSheet.create({
  iconContainer: { alignItems: 'center', justifyContent: 'center', paddingTop: 4 },
  icon: { fontSize: 20 },
  iconActive: { fontSize: 22 },
  label: { fontSize: 10, color: colors.textMuted, marginTop: 2 },
  labelActive: { color: colors.neonCyan, fontWeight: '600' },
});

export default function TabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: colors.surface,
          borderTopColor: colors.border,
          borderTopWidth: 1,
          height: 70,
          paddingBottom: 8,
          paddingTop: 4,
        },
        tabBarShowLabel: false,
        tabBarActiveTintColor: colors.neonCyan,
        tabBarInactiveTintColor: colors.textMuted,
      }}
    >
      <Tab.Screen
        name="Home"
        component={HomeScreen}
        options={{ tabBarIcon: ({ focused }) => <TabIcon icon="🏠" label="Home" focused={focused} /> }}
      />
      <Tab.Screen
        name="Services"
        component={ServicesListScreen}
        initialParams={{}}
        options={{ tabBarIcon: ({ focused }) => <TabIcon icon="📦" label="Services" focused={focused} /> }}
      />
      <Tab.Screen
        name="AIChat"
        component={AIChatScreen}
        options={{ tabBarIcon: ({ focused }) => <TabIcon icon="🤖" label="AI Chat" focused={focused} /> }}
      />
      <Tab.Screen
        name="Orders"
        component={OrdersScreen}
        options={{ tabBarIcon: ({ focused }) => <TabIcon icon="📋" label="Orders" focused={focused} /> }}
      />
      <Tab.Screen
        name="Dashboard"
        component={DashboardScreen}
        options={{ tabBarIcon: ({ focused }) => <TabIcon icon="👤" label="Account" focused={focused} /> }}
      />
    </Tab.Navigator>
  );
}
