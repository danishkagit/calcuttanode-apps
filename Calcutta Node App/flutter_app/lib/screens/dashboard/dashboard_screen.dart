import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
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
    final theme = context.watch<ThemeNotifier>();
    final user = auth.user;
    final isDark = theme.isDark;

    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final surface = isDark ? AppColors.surface : AppColors.lightSurface;
    final cardBg = isDark ? AppColors.cardBg : AppColors.lightCardBg;
    final border = isDark ? AppColors.border : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final accent = isDark ? AppColors.neonCyan : AppColors.lightNeonCyan;
    final violet = isDark ? AppColors.electricViolet : AppColors.lightElectricViolet;
    final err = isDark ? AppColors.error : AppColors.lightError;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: surface,
        iconTheme: IconThemeData(color: textPrimary),
        actions: [
          TextButton(
            onPressed: () { auth.logout(); Navigator.pushReplacementNamed(context, '/login'); },
            child: Text('Logout', style: TextStyle(color: err, fontSize: 12)),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: accent,
        onRefresh: _fetch,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: violet.withValues(alpha: 0.2),
                    child: Text('${(user?['name'] as String? ?? 'U')[0].toUpperCase()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: violet)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user?['name'] ?? 'User'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                        Text('${user?['email'] ?? ''}', style: TextStyle(fontSize: 12, color: textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isDark ? '🌙 Dark Mode' : '☀️ Light Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
                  Switch(
                    value: !isDark,
                    onChanged: (_) => theme.toggleTheme(),
                    activeColor: accent,
                    activeTrackColor: accent.withValues(alpha: 0.3),
                    inactiveThumbColor: textMuted,
                    inactiveTrackColor: border,
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
                  _statBox('${_overview!['activeOrders'] ?? 0}', 'Active Orders', accent, cardBg, border, textMuted),
                  _statBox('₹${_overview!['walletBalance'] ?? 0}', 'Wallet', accent, cardBg, border, textMuted),
                  _statBox('${_overview!['loyaltyPoints'] ?? 0}', 'Points', accent, cardBg, border, textMuted),
                  _statBox('₹${_overview!['referralEarnings'] ?? 0}', 'Referrals', accent, cardBg, border, textMuted),
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
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      Text('${item['icon']}', style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text('${item['label']}', style: TextStyle(fontSize: 12, color: textSecondary), textAlign: TextAlign.center),
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

  Widget _statBox(String value, String label, Color accent, Color cardBg, Color border, Color textMuted) {
    return Container(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: accent)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
        ],
      ),
    );
  }
}
