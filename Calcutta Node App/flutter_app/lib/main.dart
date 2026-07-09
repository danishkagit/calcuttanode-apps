import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) {
          final isDark = theme.isDark;
          return MaterialApp(
            title: 'Calcutta Node.',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: isDark ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
              colorScheme: ColorScheme(
                brightness: isDark ? Brightness.dark : Brightness.light,
                primary: isDark ? AppColors.neonCyan : AppColors.lightNeonCyan,
                secondary: isDark ? AppColors.electricViolet : AppColors.lightElectricViolet,
                surface: isDark ? AppColors.surface : AppColors.lightSurface,
                error: isDark ? AppColors.error : AppColors.lightError,
                onPrimary: AppColors.textPrimary,
                onSecondary: AppColors.textPrimary,
                onSurface: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                onError: AppColors.textPrimary,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
                foregroundColor: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                elevation: 0,
              ),
              cardTheme: CardThemeData(
                color: isDark ? AppColors.cardBg : AppColors.lightCardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: isDark ? AppColors.border : AppColors.lightBorder),
                ),
              ),
              dividerColor: isDark ? AppColors.border : AppColors.lightBorder,
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
          );
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
