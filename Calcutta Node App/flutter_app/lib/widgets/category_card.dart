import 'package:flutter/material.dart';
import '../constants/colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width > 400 ? null : double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.12)),
          gradient: LinearGradient(
            colors: [
              AppColors.neonCyan.withValues(alpha: 0.08),
              AppColors.electricViolet.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(_icons[name] ?? '📦', style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('$count services', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
