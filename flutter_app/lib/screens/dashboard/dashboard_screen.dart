import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';
import '../../api/client.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _overview;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final token = await ApiClient.getToken();
      if (token == null) return;
      final res = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/dashboard/overview'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) setState(() => _overview = jsonDecode(res.body));
    } catch (_) {}
  }

  static const _menuItems = [
    {'key': 'orders', 'label': 'My Orders', 'icon': '📋', 'route': '/orders'},
    {'key': 'wallet', 'label': 'Wallet', 'icon': '💰', 'route': '/wallet'},
    {'key': 'subscription', 'label': 'Subscriptions', 'icon': '📅', 'route': '/subscriptions'},
    {'key': 'products', 'label': 'Purchases', 'icon': '📦', 'route': '/products'},
    {'key': 'profile', 'label': 'Profile', 'icon': '👤', 'route': '/profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: () { auth.logout(); Navigator.pushReplacementNamed(context, '/login'); },
            child: const Text('Logout', style: TextStyle(color: AppColors.error, fontSize: 12)),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.neonCyan,
        onRefresh: _fetch,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.electricViolet.withValues(alpha: 0.2),
                    child: Text('${(user?['name'] as String? ?? 'U')[0].toUpperCase()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.electricViolet)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${user?['name'] ?? 'User'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Text('${user?['email'] ?? ''}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_overview != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _statBox('${_overview!['activeOrders'] ?? 0}', 'Active Orders'),
                  _statBox('₹${_overview!['walletBalance'] ?? 0}', 'Wallet'),
                  _statBox('${_overview!['loyaltyPoints'] ?? 0}', 'Points'),
                  _statBox('₹${_overview!['referralEarnings'] ?? 0}', 'Referrals'),
                ],
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _menuItems.map((item) => GestureDetector(
                onTap: () => Navigator.pushNamed(context, item['route'] as String),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 52) / 3,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text('${item['icon']}', style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text('${item['label']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Container(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.neonCyan)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
