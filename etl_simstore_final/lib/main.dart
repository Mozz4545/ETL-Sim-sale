import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/home/pages/home_page.dart';
import 'features/auth/pages/login_screen.dart';
import 'features/auth/pages/splash_page.dart';
import 'features/auth/pages/signup_screen.dart';
import 'features/auth/auth.dart';
import 'features/history/pages/order_detail_page.dart';
import 'features/history/pages/order_history_page.dart';
import 'features/sim_store/pages/sim_store_page.dart';
import 'features/checkout/pages/checkout_page.dart';
import 'session_demo_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCd-2ep63U1llld2qVXGBdYgbb_JJj7Wws",
          authDomain: "etl-project-bd7fa.firebaseapp.com",
          projectId: "etl-project-bd7fa",
          storageBucket: "etl-project-bd7fa.appspot.com",
          messagingSenderId: "102219512141",
          appId: "1:102219512141:web:f1558b6ec6e6ffb8e5df04",
          measurementId: "G-3P5K5YHXHB",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ETL Application',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansLaoTextTheme(),
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansLao',
      ),
      home: const SplashPage(), // เปลี่ยนกลับเป็น SplashPage
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/session-demo': (context) => const SessionDemoPage(),
        '/order-history': (context) => const OrderHistoryPage(),
        '/order-detail': (context) => const OrderDetailPage(),
        '/sim-store': (context) => const SimStorePage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}

class CustomAnimatedContainer extends StatelessWidget {
  final bool isHover;

  const CustomAnimatedContainer({super.key, required this.isHover});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 20000),
      height: 2,
      width: isHover ? 100 : 0,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
