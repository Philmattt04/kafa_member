import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'screens/member_dashboard_screen.dart';

const _stripeKey = String.fromEnvironment(
  'STRIPE_KEY',
  defaultValue: 'pk_test_REPLACE_ME',
);

/// Generic demo member — no login required for portfolio demo.
const _demoMember = {
  'memberId': 'MK-DEMO-001',
  'full_name': 'Alex Johnson',
  'companyId': 'KAFA-001',
  'status': true,
  'locality': 'Miami, FL',
  'phone': '+1 (305) 555-0100',
  'email': 'alex.johnson@example.com',
  'payment_access': true,
  'payment_notification': null,
  'policies': [
    {
      'policyId': 'POL-DEMO-001',
      'planName': 'Family Protection Plan',
      'premium': 150,
      'currency': 'USD',
      'status': 'Active',
      'startDate': '2025-01-01',
      'nextPayDate': '2026-06-01',
      'beneficiaries': [
        {'name': 'Maria Johnson', 'relation': 'Spouse'},
        {'name': 'Liam Johnson', 'relation': 'Child'},
      ],
    },
    {
      'policyId': 'POL-DEMO-002',
      'planName': 'Individual Coverage',
      'premium': 75,
      'currency': 'USD',
      'status': 'Active',
      'startDate': '2024-06-01',
      'nextPayDate': '2026-06-01',
      'beneficiaries': [
        {'name': 'Maria Johnson', 'relation': 'Spouse'},
      ],
    },
  ],
  'payments': [
    {
      'paymentId': 'PAY-DEMO-001',
      'policyId': 'POL-DEMO-001',
      'amount': 150,
      'currency': 'USD',
      'date': '2026-04-01',
      'method': 'Card',
      'status': 'Confirmed',
    },
    {
      'paymentId': 'PAY-DEMO-002',
      'policyId': 'POL-DEMO-001',
      'amount': 150,
      'currency': 'USD',
      'date': '2026-03-01',
      'method': 'Card',
      'status': 'Confirmed',
    },
    {
      'paymentId': 'PAY-DEMO-003',
      'policyId': 'POL-DEMO-002',
      'amount': 75,
      'currency': 'USD',
      'date': '2026-04-01',
      'method': 'MonCash',
      'status': 'Confirmed',
    },
  ],
};

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrintStack(
      stackTrace: details.stack,
      label: 'Flutter Error: ${details.exception}',
    );
  };

  WidgetsFlutterBinding.ensureInitialized();

  final hasRealKey =
      _stripeKey.isNotEmpty && !_stripeKey.contains('REPLACE_ME');
  if (hasRealKey) {
    try {
      Stripe.publishableKey = _stripeKey;
      if (!kIsWeb) await Stripe.instance.applySettings();
    } catch (_) {}
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const KafaMemberDemoApp(),
    ),
  );
}

class KafaMemberDemoApp extends StatelessWidget {
  const KafaMemberDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KAFA Member Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8A96E),
          primary: const Color(0xFFC8A96E),
          secondary: const Color(0xFF1A5C2A),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A5C2A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC8A96E),
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFFC8A96E), width: 2),
          ),
        ),
      ),
      // Go straight to dashboard — no login required for portfolio demo
      home: const MemberDashboardScreen(member: _demoMember),
    );
  }
}
