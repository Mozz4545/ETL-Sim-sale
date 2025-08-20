import 'package:flutter/material.dart';
import '../../home/controllers/custom_navbar_login.dart';
import '../service/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final retypePassword = _retypePasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || retypePassword.isEmpty) {
      _showDialog('ກະລຸນາປ້ອນອີເມວ ແລະ ລະຫັດຜ່ານ');
      return;
    }
    if (password != retypePassword) {
      _showDialog('ລະຫັດຜ່ານບໍ່ກົງກັນ');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        _showDialog('ສຳເລັດ! ສ້າງບັນຊີແລ້ວ', isSuccess: true);
      }
    } catch (e) {
      _showDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isSuccess ? 'ສຳເລັດ' : 'ແຈ້ງເຕືອນ',
          style: const TextStyle(fontFamily: 'NotoSansLao'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'NotoSansLao'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbarLogin(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                      'ສະໝັກສະມາຊິກ',
                      style: TextStyle(
                        fontFamily: 'NotoSansLao',
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'ອີເມວ',
                        labelStyle: const TextStyle(fontFamily: 'NotoSansLao'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                    TextField(
                      controller: _retypePasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'ຢືນຢັນລະຫັດຜ່ານ',
                        labelStyle: const TextStyle(fontFamily: 'NotoSansLao'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            149,
                            255,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'ສະໝັກສະມາຊິກ',
                                style: TextStyle(
                                  fontFamily: 'NotoSansLao',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SocialSignUpButtons(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ມີບັນຊີແລ້ວ?',
                          style: TextStyle(fontFamily: 'NotoSansLao'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'ເຂົ້າສູ່ລະບົບ',
                            style: TextStyle(
                              fontFamily: 'NotoSansLao',
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialSignUpButtons extends StatelessWidget {
  const SocialSignUpButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1877F3),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.facebook, color: Colors.white, size: 22),
            ),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'ສະໝັກສະມາຊິກຜ່ານ Facebook', // เปลี่ยนเป็น "สมัครสมาชิกผ่าน Facebook"
                style: TextStyle(
                  fontFamily: 'NotoSansLao',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1877F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              shadowColor: Colors.blue.withOpacity(0.2),
            ),
            onPressed: () {
              // TODO: handle Facebook sign up
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 226, 17, 17),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.mail, color: Colors.white, size: 22),
            ),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'ສະໝັກສະມາຊິກຜ່ານ Gmail', // เปลี่ยนเป็น "สมัครสมาชิกผ่าน Gmail"
                style: TextStyle(
                  fontFamily: 'NotoSansLao',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(
                255,
                226,
                17,
                17,
              ), // แก้ไขโดยเพิ่ม comma
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              shadowColor: Colors.red.withOpacity(0.2),
            ),
            onPressed: () async {
              try {
                await AuthService.signInWithGoogle();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
        ),
      ],
    );
  }
}
