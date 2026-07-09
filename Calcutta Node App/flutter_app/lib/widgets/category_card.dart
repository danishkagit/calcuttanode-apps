import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/theme_provider.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.count,
    required this.onTap,
  });

  static const _icons = {
    'Website Development': '🌐',
    'App Development': '📱',
    'Marketing': '📈',
    'Remote Support': '🖥️',
    'Troubleshooting': '🔧',
    'Design': '🎨',
    'Data Recovery': '💾',
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    final isDark = theme.isDark;

    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final accent = isDark ? AppColors.neonCyan : AppColors.lightNeonCyan;
    final violet = isDark ? AppColors.electricViolet : AppColors.lightElectricViolet;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width > 400 ? null : double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.12)),
          gradient: LinearGradient(
            colors: [
              accent.withValues(alpha: 0.08),
              violet.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(_icons[name] ?? '📦', style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('$count services', style: TextStyle(fontSize: 11, color: textMuted)),
          ],
        ),
      ),
    );
  }
}
