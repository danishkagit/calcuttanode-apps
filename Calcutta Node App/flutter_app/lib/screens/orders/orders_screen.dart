import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../api/client.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> _orders = [];
  String _filter = 'all';

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
        Uri.parse('${AppConfig.apiBaseUrl}/dashboard/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) setState(() => _orders = List<Map<String, dynamic>>.from(jsonDecode(res.body)));
    } catch (_) {}
  }

  static const _statusColors = {
    'pending': AppColors.warning,
    'in-progress': AppColors.neonCyan,
    'completed': AppColors.success,
    'cancelled': AppColors.error,
  };

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all' ? _orders : _orders.where((o) => o['status'] == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: RefreshIndicator(
        color: AppColors.neonCyan,
        onRefresh: _fetch,
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                children: ['all', 'pending', 'in-progress', 'completed', 'cancelled'].map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f[0].toUpperCase() + f.substring(1), style: TextStyle(fontSize: 12, color: active ? AppColors.neonCyan : AppColors.textMuted, fontWeight: active ? FontWeight.w600 : FontWeight.w500)),
                      selected: active,
                      selectedColor: AppColors.neonCyan.withValues(alpha: 0.15),
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: active ? AppColors.neonCyan : AppColors.border),
                      onSelected: (v) => setState(() => _filter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No orders found', style: TextStyle(color: AppColors.textMuted)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (c, i) {
                        final o = filtered[i];
                        final status = '${o['status']}';
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(o['service']?['name'] ?? 'Service', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (_statusColors[status] ?? AppColors.textMuted).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColors[status] ?? AppColors.textMuted)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(o['createdAt'] != null ? DateTime.parse('${o['createdAt']}').toString().split(' ')[0] : '', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              if (o['amount'] != null) ...[
                                const SizedBox(height: 4),
                                Text('₹${(o['amount'] as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.neonCyan)),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
