import 'package:flutter/material.dart';
import '../constants/colors.dart';

class LoadingSpinner extends StatelessWidget {
  final bool fullScreen;
  const LoadingSpinner({super.key, this.fullScreen = true});

  @override
  Widget build(BuildContext context) {
    if (!fullScreen) {
      return const Center(child: CircularProgressIndicator(color: AppColors.neonCyan));
    }
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: CircularProgressIndicator(color: AppColors.neonCyan)),
    );
  }
}
