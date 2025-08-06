import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _loginWithGoogle(BuildContext context) {
    // TODO: Implement Google login logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login with Google pressed')));
  }

  void _loginWithFacebook(BuildContext context) {
    // TODO: Implement Facebook login logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login with Facebook pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ເຂົ້າສູ່ລະບົບ',
          style: TextStyle(fontFamily: 'Phetsalath_OT'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text(
                  'ເຂົ້າສູ່ລະບົບດ້ວຍ Gmail',
                  style: TextStyle(fontFamily: 'Phetsalath_OT'),
                ),
                onPressed: () => _loginWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.facebook),
                label: const Text('เข้าสู่ระบบด้วย Facebook'),
                onPressed: () => _loginWithFacebook(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
