import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/customer/entry_screen.dart';
import 'screens/customer/session_screen.dart';
import 'screens/customer/exit_payment_screen.dart';
import 'screens/customer/payment_method_screen.dart';
import 'screens/customer/payment_form_screen.dart';
import 'screens/customer/payment_success_screen.dart';
import 'screens/customer/receipt_screen.dart';

void main() {
  runApp(const SmartParkingApp());
}

class SmartParkingApp extends StatelessWidget {
  const SmartParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SM SmartParking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/': (_) => const HomeScreen(),
        '/entry': (_) => const EntryScreen(),
        '/session': (_) => const SessionScreen(),
        '/exit-payment': (_) => const ExitPaymentScreen(),
        '/payment-method': (_) => const PaymentMethodScreen(),
        '/payment-form': (_) => const PaymentFormScreen(),
        '/payment-success': (_) => const PaymentSuccessScreen(),
        '/receipt': (_) => const ReceiptScreen(),
      },
    );
  }
}
