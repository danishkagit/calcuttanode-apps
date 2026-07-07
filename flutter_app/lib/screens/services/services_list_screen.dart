import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';
import '../../widgets/service_card.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _filtered = [];
  final _searchCtrl = TextEditingController();
  String? _category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _category = args?['category'] as String?;
    if (_all.isEmpty) _fetch();
  }

  Future<void> _fetch() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/services'));
      if (res.statusCode == 200) {
        _all = List<Map<String, dynamic>>.from(jsonDecode(res.body));
        _applyFilter();
      }
    } catch (_) {}
  }

  void _applyFilter() {
    setState(() {
      _filtered = _all.where((s) {
        if (_category != null && s['category'] != _category) return false;
        final q = _searchCtrl.text.toLowerCase();
        if (q.isEmpty) return true;
        return '${s['name']}'.toLowerCase().contains(q) || '${s['description']}'.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final s in _filtered) {
      (grouped[s['category']] ??= []).add(s);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_category ?? 'All Services', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => _applyFilter(),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search services...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_category == null)
                  ...grouped.entries.map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(e.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1)),
                      ),
                      ...e.value.map((s) => ServiceCard(
                        service: s,
                        onTap: () => Navigator.pushNamed(context, '/service-detail', arguments: s),
                      )),
                    ],
                  ))
                else
                  ..._filtered.map((s) => ServiceCard(
                    service: s,
                    onTap: () => Navigator.pushNamed(context, '/service-detail', arguments: s),
                  )),
                if (_filtered.isEmpty) const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text('No services found', style: TextStyle(color: AppColors.textMuted))),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
