import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/theme_provider.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    final isDark = theme.isDark;
    final features = service['features'] as List<dynamic>? ?? [];
    final price = service['price'] ?? 0;

    final cardBg = isDark ? AppColors.cardBg : AppColors.lightCardBg;
    final border = isDark ? AppColors.border : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final accent = isDark ? AppColors.neonCyan : AppColors.lightNeonCyan;
    final violet = isDark ? AppColors.electricViolet : AppColors.lightElectricViolet;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${service['category'] ?? ''}',
                  style: TextStyle(fontSize: 11, color: violet, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
                Text(
                  '₹${price is int ? price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') : price}',
                  style: TextStyle(fontSize: 13, color: accent, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${service['name'] ?? ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              '${service['description'] ?? ''}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            if (features.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...features.take(3).map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    Text('✦ ', style: TextStyle(fontSize: 12, color: textMuted)),
                    Expanded(child: Text('$f', style: TextStyle(fontSize: 12, color: textMuted))),
                  ],
                ),
              )),
              if (features.length > 3)
                Text('+${features.length - 3} more', style: TextStyle(fontSize: 11, color: accent)),
            ],
          ],
        ),
      ),
    );
  }
}
