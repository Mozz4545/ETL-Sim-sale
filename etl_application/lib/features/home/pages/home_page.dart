import 'package:flutter/material.dart';
import '../../custom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(
        onCartPressed: () {
          // โค้ดเมื่อกดตะกร้า
        },
        onLanguagePressed: () {
          // โค้ดเมื่อกดเปลี่ยนภาษา
        },
      ),
      body: const Center(child: Text('Welcome to ETL Home!')),
    );
  }
}
