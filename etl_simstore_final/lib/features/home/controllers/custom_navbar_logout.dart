import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features/auth/service/auth_service.dart';
import '../../checkout/pages/checkout_page.dart';
import 'main_menu_bar.dart';

class CustomNavbarLogout extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onCartPressed;
  final VoidCallback? onHomePressed;
  final VoidCallback? onLoginPressed;

  const CustomNavbarLogout({
    super.key,
    this.onCartPressed,
    this.onHomePressed,
    this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Top contact bar
          Container(
            color: const Color.fromARGB(255, 22, 53, 134),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Saylom Rd, Saylom Village, Vientiane Capital',
                      style: GoogleFonts.notoSansLaoLooped(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.phone, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+(856)21 260051',
                      style: GoogleFonts.notoSansLaoLooped(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.email, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'csd@etllao.com',
                      style: GoogleFonts.notoSansLaoLooped(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.white),
                      iconSize: 18,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.music_note, color: Colors.white),
                      iconSize: 18,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                      ),
                      iconSize: 18,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main menu bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/home'),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/ETL_logo.jpg',
                          width: 48,
                          height: 48,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        _buildMenuButton(
                          'ໜ້າຫຼັກ',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/home'),
                        ),
                        _buildMenuButton(
                          'ຊິມກາດ',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sim-store'),
                        ),
                        _buildMenuButton(
                          'ແພັກເກດຂໍ້ມູນ',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sim-store'),
                        ),
                        _buildDropdownMenu(context, 'ລາຍການສັ່ງຊື້', {
                          'ຄຳສັ່ງຊື້ສຳຫລັບຊິມກາດ':
                              '/cart', // เปลี่ยนไปหน้าตะกร้า
                          'ປະຫວັດການສັ່ງຊື້': '/order-history',
                        }),
                        _buildMenuButton(
                          'ບັນຊີຜູ້ໃຊ້',
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/profile',
                          ), // เปลี่ยนไปหน้า profile
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Color.fromARGB(255, 0, 149, 255),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CheckoutPage(),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 0, 0),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: const Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () async {
                        // แสดง confirmation dialog
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'ຢືນຢັນການອອກຈາກລະບົບ',
                              style: GoogleFonts.notoSansLaoLooped(),
                            ),
                            content: Text(
                              'ທ່ານຕ້ອງການອອກຈາກລະບົບບໍ?',
                              style: GoogleFonts.notoSansLaoLooped(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  'ຍົກເລີກ',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    0,
                                    0,
                                  ),
                                ),
                                child: Text(
                                  'ອອກຈາກລະບົບ',
                                  style: GoogleFonts.notoSansLaoLooped(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          try {
                            await AuthService.signOut();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/splash',
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'ເກີດຂໍ້ຜິດພາດ: ${e.toString()}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'ອອກຈາກລະບົບ',
                        style: TextStyle(fontFamily: 'NotoSansLao'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, {VoidCallback? onPressed}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: GoogleFonts.notoSansLaoLooped(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownMenu(
    BuildContext context,
    String title,
    Map<String, String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 150,
        constraints: const BoxConstraints(minHeight: 40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.black,
            style: GoogleFonts.notoSansLaoLooped(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            hint: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: GoogleFonts.notoSansLaoLooped(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            isExpanded: true,
            onChanged: (value) {
              if (value != null && items.containsKey(value)) {
                Navigator.pushNamed(context, items[value]!);
              }
            },
            items: items.keys.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.notoSansLaoLooped(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbarLogout(
        onCartPressed: () {
          // TODO: handle cart pressed
        },
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // ...widget
          ],
        ),
      ),
    );
  }
}

class _HoverMenuButton extends StatefulWidget {
  final String title;

  const _HoverMenuButton({required this.title});

  @override
  State<_HoverMenuButton> createState() => _HoverMenuButtonState();
}

class _HoverMenuButtonState extends State<_HoverMenuButton> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHover = true),
          onExit: (_) => setState(() => _isHover = false),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.notoSansLaoLooped(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: _isHover
                      ? (TextPainter(
                          text: TextSpan(
                            text: widget.title,
                            style: GoogleFonts.notoSansLaoLooped(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        )..layout()).size.width
                      : 0,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
  ปัญหานี้เกิดจากการจัด padding และ alignment ของ DropdownMenu กับ MenuButton ไม่เท่ากัน
  วิธีแก้: ปรับ _buildDropdownMenu ให้ใช้ padding และ minHeight เหมือนกับ _HoverMenuButton
  และปรับ alignment ของ DropdownMenuItem ให้ตรงกับ TextButton
*/

// ปรับ _buildDropdownMenu ให้เหมือนกับ _buildMenuButton

/*
  ปรับตำแหน่ง dropdown ให้สูงขึ้นอีกนิด โดยเพิ่ม margin ด้านบนใน Container ของ _buildDropdownMenu
*/

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainMenuBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // เนื้อหาอื่น ๆ
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Welcome to the Home Page!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
