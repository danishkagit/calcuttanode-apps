import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';
import '../../api/client.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final auth = context.watch<AuthProvider>();
    final features = service['features'] as List<dynamic>? ?? [];
    final price = service['price'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Service Details', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${service['category']}', style: const TextStyle(fontSize: 12, color: AppColors.electricViolet, fontWeight: FontWeight.w600, letterSpacing: 1)),
              Text('₹${price is int ? price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') : price}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.neonCyan)),
            ],
          ),
          const SizedBox(height: 12),
          Text('${service['name']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Text('${service['description']}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
          if (features.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("What's Included", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 14),
                  ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✓ ', style: TextStyle(fontSize: 14, color: AppColors.neonCyan, fontWeight: FontWeight.w700)),
                        Expanded(child: Text('$f', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!auth.isAuthenticated) {
                  Navigator.pushNamed(context, '/login');
                  return;
                }
                try {
                  final token = await ApiClient.getToken();
                  final res = await http.post(
                    Uri.parse('${AppConfig.apiBaseUrl}/dashboard/order'),
                    headers: {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
                    body: jsonEncode({'serviceId': service['_id']}),
                  );
                  if (res.statusCode == 200 || res.statusCode == 201) {
                    if (context.mounted) {
                      showDialog(context: context, builder: (c) => AlertDialog(
                        backgroundColor: AppColors.surface,
                        title: const Text('Order Placed!', style: TextStyle(color: AppColors.neonCyan)),
                        content: const Text('Your service has been booked.', style: TextStyle(color: AppColors.textSecondary)),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(c); Navigator.pushNamed(context, '/orders'); }, child: const Text('Track Order', style: TextStyle(color: AppColors.neonCyan))),
                          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK', style: TextStyle(color: AppColors.textMuted))),
                        ],
                      ));
                    }
                  } else {
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to place order')));
                  }
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonCyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Book This Service', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

}
