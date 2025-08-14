import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/pages/home_page.dart';
import 'features/auth/pages/login_screen.dart'; // เพิ่มบรรทัดนี้

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETL Application',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansLaoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginScreen(), // เพิ่มบรรทัดนี้
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
      width: isHover ? 100 : 0, // ปรับค่าตรงนี้ให้ยาวหรือสั้นตามต้องการ
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
