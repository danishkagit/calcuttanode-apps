import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    final rows = [
      {'label': 'Name', 'value': user?['name']},
      {'label': 'Email', 'value': user?['email']},
      {'label': 'Phone', 'value': user?['phone']},
      {'label': 'Role', 'value': user?['role']},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.electricViolet.withValues(alpha: 0.2),
              child: Text('${(user?['name'] as String? ?? 'U')[0].toUpperCase()}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.electricViolet)),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: rows.where((r) => r['value'] != null).toList().asMap().entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: e.key < rows.where((r) => r['value'] != null).length - 1
                      ? const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border)))
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${e.value['label']}', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      Text('${e.value['value']}', style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () { auth.logout(); Navigator.pushReplacementNamed(context, '/login'); },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Logout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Column(
              children: [
                Text(AppConfig.appName, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                SizedBox(height: 2),
                Text(AppConfig.email, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
