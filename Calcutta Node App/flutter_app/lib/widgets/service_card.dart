import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final features = service['features'] as List<dynamic>? ?? [];
    final price = service['price'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${service['category'] ?? ''}',
                  style: const TextStyle(fontSize: 11, color: AppColors.electricViolet, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
                Text(
                  '₹${price is int ? price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') : price}',
                  style: const TextStyle(fontSize: 13, color: AppColors.neonCyan, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${service['name'] ?? ''}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              '${service['description'] ?? ''}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            if (features.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...features.take(3).map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    const Text('✦ ', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Expanded(child: Text('$f', style: const TextStyle(fontSize: 12, color: AppColors.textMuted))),
                  ],
                ),
              )),
              if (features.length > 3)
                Text('+${features.length - 3} more', style: const TextStyle(fontSize: 11, color: AppColors.neonCyan)),
            ],
          ],
        ),
      ),
    );
  }
}
