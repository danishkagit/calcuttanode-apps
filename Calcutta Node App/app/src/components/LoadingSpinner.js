import React from 'react';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { colors } from '../constants/colors';

export default function LoadingSpinner({ size = 'large', fullScreen = true }) {
  if (!fullScreen) {
    return <ActivityIndicator size={size} color={colors.neonCyan} />;
  }
  return (
    <View style={styles.container}>
      <ActivityIndicator size={size} color={colors.neonCyan} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.background,
  },
});
