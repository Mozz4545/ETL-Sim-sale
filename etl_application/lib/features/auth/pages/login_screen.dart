import 'package:flutter/material.dart';
import '../../custom_navbar.dart'; // นำเข้า CustomNavbar
import 'sign_up_screen.dart'; // นำเข้า SignUpScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Phetsarath OT,Noto Sans Lao', // ใช้ฟอนต์ Phetsarath OT
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbar(), // แสดง CustomNavbar ที่ด้านบน
      body: Center(
        child: Container(
          width: 400, // ลดความกว้างลง
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            // ป้องกัน Overflow แนวตั้ง
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ຍິນດີຕ້ອນຮັບ',
                  style: TextStyle(
                    fontFamily: 'Phetsarath OT',
                    fontWeight: FontWeight.bold,
                    fontSize: 30, // ลดขนาดฟอนต์
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'ຊື່ຜູ້ໃຊ້',
                    labelStyle: const TextStyle(fontFamily: 'Phetsarath OT'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດຜ່ານ',
                    labelStyle: const TextStyle(fontFamily: 'Phetsarath OT'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: handle login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 22, 53, 134),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'ເຂົ້າສູ່ລະບົບ',
                      style: TextStyle(
                        fontFamily: 'Phetsarath OT',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SocialLoginButtons(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ຍັງບໍ່ມີບັນຊີ?",
                      style: TextStyle(fontFamily: 'Phetsarath OT'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'Phetsarath OT',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ປຸ່ມ Login ດ້ວຍ Facebook และ Google
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: SizedBox(
              height: 20,
              width: 20,
              child: const Icon(Icons.facebook, color: Colors.white),
            ),
            label: const Text(
              'Login ຜ່ານ Facebook',
              style: TextStyle(
                fontFamily: 'Noto Sans Lao',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1877F3),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
            ),
            onPressed: () {
              // TODO: handle Facebook login
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.mail, color: Colors.white),
            label: const Text(
              'Login ຜ່ານ Gmail',
              style: TextStyle(
                fontFamily: 'Noto Sans Lao',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(221, 255, 255, 255),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 226, 17, 17),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFDD4B39)),
              ),
              elevation: 3,
            ),
            onPressed: () {
              // TODO: handle Mail login
            },
          ),
        ],
      ),
    );
  }
}
