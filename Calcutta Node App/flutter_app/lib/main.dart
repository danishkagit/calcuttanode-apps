import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants/colors.dart';
import 'providers/auth_provider.dart';
import 'widgets/loading_spinner.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/services/services_list_screen.dart';
import 'screens/services/service_detail_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/ai/ai_chat_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/products/products_screen.dart';
import 'screens/subscriptions/subscriptions_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalcuttaNodeApp());
}

class CalcuttaNodeApp extends StatelessWidget {
  const CalcuttaNodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Calcutta Node.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.neonCyan,
            secondary: AppColors.electricViolet,
            surface: AppColors.surface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
          ),
        ),
        home: const AuthGate(),
        routes: {
          '/login': (c) => const LoginScreen(),
          '/register': (c) => const RegisterScreen(),
          '/home': (c) => const HomeScreen(),
          '/services': (c) => const ServicesListScreen(),
          '/service-detail': (c) => const ServiceDetailScreen(),
          '/orders': (c) => const OrdersScreen(),
          '/ai': (c) => const AIChatScreen(),
          '/dashboard': (c) => const DashboardScreen(),
          '/wallet': (c) => const WalletScreen(),
          '/products': (c) => const ProductsScreen(),
          '/subscriptions': (c) => const SubscriptionsScreen(),
          '/profile': (c) => const ProfileScreen(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (c, auth, _) {
        if (auth.loading) return const LoadingSpinner();
        return const HomeScreen();
      },
    );
  }
}
