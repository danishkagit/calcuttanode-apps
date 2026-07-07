import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Map<String, dynamic>> _plans = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/subscriptions/plans'));
      if (res.statusCode == 200) setState(() => _plans = List<Map<String, dynamic>>.from(jsonDecode(res.body)));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Membership Plans', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _plans.map((plan) {
          final features = plan['features'] as List<dynamic>? ?? [];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan['badge'] != null && '${plan['badge']}'.isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.neonCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.neonCyan)),
                      child: Text('${plan['badge']}', style: const TextStyle(fontSize: 10, color: AppColors.neonCyan, fontWeight: FontWeight.w600)),
                    ),
                  ),
                Text('${plan['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('₹${plan['price']}/mo', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.neonCyan)),
                Text('${plan['duration']} days', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 16),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✓ ', style: TextStyle(fontSize: 14, color: AppColors.success, fontWeight: FontWeight.w700)),
                      Expanded(child: Text('$f', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!auth.isAuthenticated) { Navigator.pushNamed(context, '/login'); return; }
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription feature coming soon')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonCyan,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Subscribe', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
