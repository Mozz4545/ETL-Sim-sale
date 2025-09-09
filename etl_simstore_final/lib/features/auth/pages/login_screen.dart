import 'package:flutter/material.dart';
import '../../home/controllers/main_menu_bar.dart';
import '../service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('ກະລຸນາປ້ອນອີເມວ ແລະ ລະຫັດຜ່ານ');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      // เข้าสู่ระบบสำเร็จ ไปหน้า Home
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('ກະລຸນາປ້ອນອີເມວກ່ຽວກັບການລືມລະຫັດຜ່ານ');
      return;
    }

    try {
      await AuthService.resetPassword(_emailController.text.trim());
      _showSuccessDialog('ສົ່ງລິ້ງລີເຊັດລະຫັດຜ່ານໄປຍັງອີເມວແລ້ວ');
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'ເກີດຂໍ້ຜິດພາດ',
          style: TextStyle(fontFamily: 'NotoSansLao'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'NotoSansLao'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ຕົກລົງ',
              style: TextStyle(fontFamily: 'NotoSansLao'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'ສຳເລັດ',
          style: TextStyle(fontFamily: 'NotoSansLao'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'NotoSansLao'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ຕົກລົງ',
              style: TextStyle(fontFamily: 'NotoSansLao'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainMenuBar(),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ຍິນດີຕ້ອນຮັບ',
                  style: TextStyle(
                    fontFamily: 'NotoSansLao',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'ອີເມວ',
                    labelStyle: const TextStyle(fontFamily: 'NotoSansLao'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດຜ່ານ',
                    labelStyle: const TextStyle(fontFamily: 'NotoSansLao'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Remember Me Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'ຈົດຈໍາການເຂົ້າສູ່ລະບົບ',
                      style: TextStyle(fontFamily: 'NotoSansLao'),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 149, 255),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ເຂົ້າສູ່ລະບົບ',
                            style: TextStyle(
                              fontFamily: 'NotoSansLao',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: const Text(
                      'ລືມລະຫັດຜ່ານ?',
                      style: TextStyle(
                        fontFamily: 'NotoSansLao',
                        color: Color.fromARGB(255, 107, 106, 106),
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SocialLoginButtons(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ຍັງບໍ່ມີບັນຊີ?",
                      style: TextStyle(fontFamily: 'NotoSansLao'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "ສະໝັກສະມາຊິກ",
                        style: TextStyle(
                          fontFamily: 'NotoSansLao',
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// SocialLoginButtons widget เหมือนเดิม
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
            icon: const Icon(Icons.facebook, color: Colors.white, size: 20),
            label: const Text(
              'Login ຜ່ານ Facebook',
              style: TextStyle(
                fontFamily: 'NotoSansLao',
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
            icon: const Icon(Icons.mail, color: Colors.white, size: 20),
            label: const Text(
              'Login ຜ່ານ Gmail',
              style: TextStyle(
                fontFamily: 'NotoSansLao',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
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
            onPressed: () async {
              try {
                await AuthService.signInWithGoogle();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
