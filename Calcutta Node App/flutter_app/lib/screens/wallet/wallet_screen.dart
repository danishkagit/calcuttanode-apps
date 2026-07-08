import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../api/client.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 0;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final token = await ApiClient.getToken();
      if (token == null) return;
      final h = {'Authorization': 'Bearer $token'};
      final bal = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/dashboard/wallet'), headers: h);
      final txs = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/dashboard/transactions'), headers: h);
      if (bal.statusCode == 200) setState(() => _balance = (jsonDecode(bal.body)['balance'] ?? 0).toDouble());
      if (txs.statusCode == 200) setState(() => _transactions = List<Map<String, dynamic>>.from(jsonDecode(txs.body)));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wallet', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: RefreshIndicator(
        color: AppColors.neonCyan,
        onRefresh: _fetch,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Text('Available Balance', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Text('₹${_balance.toStringAsFixed(0)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.neonCyan)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            if (_transactions.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No transactions yet', style: TextStyle(color: AppColors.textMuted))))
            else
              ..._transactions.map((tx) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${tx['type'] ?? 'Transaction'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text(tx['createdAt'] != null ? '${DateTime.parse('${tx['createdAt']}').toString().split(' ')[0]}' : '', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                    Text(
                      '${tx['type'] == 'credit' ? '+' : '-'}₹${(tx['amount'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tx['type'] == 'credit' ? AppColors.success : AppColors.error),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}
