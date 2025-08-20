import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAuthAndNavigate();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    // รอ animation เสร็จก่อน (อย่างน้อย 3 วินาที)
    await Future.delayed(const Duration(seconds: 3));

    try {
      // ตรวจสอบสถานะ login จาก Firebase
      bool isLoggedIn = await AuthService.isUserLoggedIn();

      if (mounted) {
        if (isLoggedIn) {
          // ถ้า login แล้ว ไปหน้า Home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // ถ้ายังไม่ login ไปหน้า Login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      // ถ้า Firebase ยังไม่พร้อม ให้ไปหน้า Login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // โลโก้ ETL
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/ETL_logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ชื่อแอป
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: const Column(
                    children: [
                      Text(
                        'ETL Application',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'NotoSansLao',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ຊິມກາດ ແລະ ບໍລິການອິນເຕີເນັດ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'NotoSansLao',
                        ),
                      ),
                      SizedBox(height: 40),

                      // Loading indicator
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ກຳລັງກວດສອບການເຂົ້າສູ່ລະບົບ...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'NotoSansLao',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 100),

            // ข้อมูลด้านล่าง
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value * 0.7,
                  child: const Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '© 2025 ETL Company. All rights reserved.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
