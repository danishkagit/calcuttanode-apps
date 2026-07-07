import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    if ([_nameCtrl, _emailCtrl, _phoneCtrl, _passCtrl].any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().register(_nameCtrl.text, _emailCtrl.text, _phoneCtrl.text, _passCtrl.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/logo.png', width: 80, height: 80),
              const SizedBox(height: 8),
              const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Join Calcutta Node. today', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              _field(_nameCtrl, 'Full Name'),
              const SizedBox(height: 12),
              _field(_emailCtrl, 'Email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _field(_phoneCtrl, 'Phone', keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _field(_passCtrl, 'Password', obscure: true),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricViolet,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_loading ? 'Creating...' : 'Create Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ', style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    children: [TextSpan(text: 'Login', style: TextStyle(color: AppColors.electricViolet, fontWeight: FontWeight.w600))],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, {bool obscure = false, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      ),
    );
  }
}
