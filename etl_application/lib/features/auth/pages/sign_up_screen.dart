import 'package:flutter/material.dart';
import '../../custom_navbar.dart'; // นำเข้า CustomNavbar

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbar(),
      body: Center(
        child: Container(
          width: 400,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ລົງທະບຽນ',
                style: TextStyle(
                  fontFamily: 'Phetsarath OT',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'ອີເມວ',
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
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'ຢືນຢັນລະຫັດຜ່ານ',
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
                    // TODO: handle sign up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'ລົງທະບຽນ',
                    style: TextStyle(
                      fontFamily: 'Phetsarath OT',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              buildSocialSignUpButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSocialSignUpButtons() {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // TODO: handle Facebook sign up
          },
          icon: const Icon(Icons.facebook, color: Colors.white),
          label: const Text(
            'Facebook',
            style: TextStyle(fontFamily: 'Phetsarath OT', color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1877F3),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: handle Gmail sign up
          },
          icon: const Icon(Icons.mail, color: Colors.white),
          label: const Text(
            'Gmail',
            style: TextStyle(
              fontFamily: 'Phetsarath OT',
              color: Color.fromARGB(221, 255, 255, 255),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 0, 0),
            foregroundColor: const Color.fromARGB(221, 255, 255, 255),
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}
