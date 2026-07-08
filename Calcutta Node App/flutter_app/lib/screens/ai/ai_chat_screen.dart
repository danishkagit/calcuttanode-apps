import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../constants/config.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Map<String, String>> _messages = [];
  String _selectedModel = 'deepseek-v4-flash-free';
  bool _loading = false;
  List<Map<String, String>> _models = [
    {'id': 'deepseek-v4-flash-free', 'name': 'DeepSeek V4 Flash', 'icon': '🔍'},
    {'id': 'mimo-v2.5-free', 'name': 'MiMo V2.5', 'icon': '🧠'},
    {'id': 'north-mini-code-free', 'name': 'North Mini Code', 'icon': '⚡'},
    {'id': 'nemotron-3-ultra-free', 'name': 'Nemotron 3 Ultra', 'icon': '🚀'},
    {'id': 'hy3-free', 'name': 'Hy3', 'icon': '🌊'},
    {'id': 'big-pickle', 'name': 'Big Pickle', 'icon': '🥒'},
    {'id': 'antigravity-gemini-3.1-pro', 'name': 'Gemini 3.1 Pro', 'icon': '🌟'},
    {'id': 'antigravity-gemini-3-flash', 'name': 'Gemini 3 Flash', 'icon': '⚡'},
    {'id': 'gemini-2.5-flash', 'name': 'Gemini 2.5 Flash', 'icon': '💎'},
    {'id': 'antigravity-claude-sonnet-4-6', 'name': 'Claude Sonnet 4.6', 'icon': '🎯'},
    {'id': 'antigravity-claude-opus-4-6-thinking', 'name': 'Claude Opus 4.6', 'icon': '🧠'},
  ];

  static const _suggestions = ['What services do you offer?', 'How can I fix a slow computer?', 'Tell me about your hosting plans'];
  static const _seoSuggestions = [
    'Write a blog post about "Benefits of Remote IT Support for Small Businesses"',
    'Generate SEO meta tags for a web development services page',
    'Suggest keywords for "digital marketing agency in Kolkata"',
    'Create a JSON-LD schema for a local business',
  ];

  @override
  void initState() {
    super.initState();
    _fetchModels();
  }

  Future<void> _fetchModels() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/ai/models'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        if (data.isNotEmpty) {
          final fetched = data.map((m) => {
            'id': m['id'] as String,
            'name': m['name'] as String,
            'icon': (m['icon'] as String?) ?? '🧠',
          }).toList();
          setState(() {
            _models = fetched;
            _selectedModel = fetched.first['id']!;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _send(String text) async {
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _loading = true;
    });
    _msgCtrl.clear();
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/ai/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text, 'model': _selectedModel}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _messages.add({'role': 'assistant', 'content': data['reply'] ?? 'No response'}));
      }
    } catch (_) {
      setState(() => _messages.add({'role': 'assistant', 'content': 'Sorry, I encountered an error.'}));
    }
    setState(() => _loading = false);
    Future.delayed(const Duration(milliseconds: 100), () => _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut));
  }

  @override
  void dispose() { _msgCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI Chat', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 18)),
            Text('${_models.length} free models — auto-fallback', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: _models.map((m) {
                final active = _selectedModel == m['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Text('${m['icon']}', style: const TextStyle(fontSize: 14)),
                    label: Text('${m['name']}', style: TextStyle(fontSize: 13, color: active ? AppColors.neonCyan : AppColors.textMuted)),
                    selected: active,
                    selectedColor: AppColors.neonCyan.withValues(alpha: 0.15),
                    backgroundColor: AppColors.surface,
                    side: BorderSide(color: active ? AppColors.neonCyan : AppColors.border),
                    onSelected: (v) => setState(() => _selectedModel = m['id'] as String),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🤖', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      const Text('How can I help you?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      const Text('Ask about services, pricing, or tech support', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _suggestions.map((s) => ActionChip(
                          label: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                          onPressed: () => _send(s),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('🔍 SEO Tools', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.neonCyan)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _seoSuggestions.map((s) => ActionChip(
                          label: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          backgroundColor: AppColors.neonCyan.withValues(alpha: 0.1),
                          side: const BorderSide(color: AppColors.neonCyan),
                          onPressed: () => _send(s),
                        )).toList(),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_loading ? 1 : 0),
                  itemBuilder: (c, i) {
                    if (i == _messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Thinking...', style: TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic)),
                        ),
                      );
                    }
                    final msg = _messages[i];
                    final isUser = msg['role'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isUser ? AppColors.neonCyan : AppColors.surfaceLight,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
                            bottomRight: isUser ? Radius.zero : const Radius.circular(18),
                          ),
                          border: isUser ? null : Border.all(color: AppColors.border),
                        ),
                        child: Text('${msg['content']}', style: TextStyle(fontSize: 14, color: isUser ? Colors.black : AppColors.textPrimary)),
                      ),
                    );
                  },
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    maxLines: 4,
                    minLines: 1,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Ask anything...',
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _msgCtrl.text.trim().isEmpty ? AppColors.neonCyan.withValues(alpha: 0.4) : AppColors.neonCyan,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 18),
                    onPressed: _msgCtrl.text.trim().isEmpty || _loading ? null : () => _send(_msgCtrl.text.trim()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
