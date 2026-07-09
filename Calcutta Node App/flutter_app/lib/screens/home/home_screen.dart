import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/service_card.dart';
import '../../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _services = [];
  List<String> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/services'));
      if (res.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(jsonDecode(res.body));
        setState(() {
          _services = data;
          _categories = data.map((s) => '${s['category']}').toSet().toList();
          _loading = false;
        });
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeNotifier>();
    final user = auth.user;
    final featured = _services.where((s) => s['featured'] == true).take(5).toList();
    final isDark = theme.isDark;

    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final accent = isDark ? AppColors.neonCyan : AppColors.lightNeonCyan;
    final border = isDark ? AppColors.border : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        color: accent,
        onRefresh: _fetchServices,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: bg,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello${user != null ? ', ${user['name']}' : ''} 👋', style: TextStyle(fontSize: 14, color: textSecondary)),
                  Text('Calcutta Node.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textPrimary)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Text('🤖', style: TextStyle(fontSize: 22)),
                  onPressed: () => Navigator.pushNamed(context, '/ai'),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    _statBox('${_services.length}', 'Services', accent, textMuted),
                    Container(width: 1, height: 40, color: border),
                    _statBox('${_categories.length}', 'Categories', accent, textMuted),
                    Container(width: 1, height: 40, color: border),
                    _statBox('🌐', 'Worldwide', accent, textMuted),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((cat) {
                        final count = _services.where((s) => s['category'] == cat).length;
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 50) / 2,
                          child: CategoryCard(
                            name: cat,
                            count: count,
                            onTap: () => Navigator.pushNamed(context, '/services', arguments: {'category': cat}),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            if (featured.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Featured Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/services'),
                        child: Text('See all →', style: TextStyle(color: accent, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ServiceCard(
                    service: featured[index],
                    onTap: () => Navigator.pushNamed(context, '/service-detail', arguments: featured[index]),
                  ),
                  childCount: featured.length,
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, String label, Color accent, Color textMuted) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: accent)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
        ],
      ),
    );
  }
}
