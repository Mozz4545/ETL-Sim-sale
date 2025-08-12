import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onCartPressed;
  final VoidCallback? onLanguagePressed;

  const CustomNavbar({super.key, this.onCartPressed, this.onLanguagePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top contact bar
        Container(
          color: const Color(0xFF0C1B40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 14),
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
          color: const Color(0xFF2C3E70),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/ETL_logo.jpg',
                    width: 60, // โลโก้เล็กลง
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      _buildMenuButton('ໜ້າຫຼັກ'),
                      _buildMenuButton('ຂໍ້ມູນຕິດຕໍ່'),
                      _buildMenuButton('ແພັກເກດຂໍ້ມູນ'),
                      _buildDropdownMenu('FTTH', ['FTTH', 'FTTH Via CPE']),
                      _buildDropdownMenu('ລາຍການສັ່ງຊື້ຂອງຂ້ອຍ', [
                        'ເບິ່ງຄຳສັ່ງຊື້ FTTH',
                        'ຄຳສັ່ງຊື້ສຳລັບຊິມກາດ',
                        'ປະຫວັດການສັ່ງຊື້',
                      ]),
                      _buildMenuButton('ບັນຊີຜູ້ໃຊ້'),
                    ],
                  ),
                ],
              ),

              // Right actions
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: onCartPressed,
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
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
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.login, size: 16),
                    label: Text(
                      'ເຂົ້າສູ່່ລະບົບ',
                      style: GoogleFonts.notoSansLaoLooped(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.language, color: Colors.white),
                    onPressed: onLanguagePressed,
                  ),
                ],
              ),
            ],
          ),
        ),
        // ลบ Expanded และ SingleChildScrollView ออก เพราะไม่ควรอยู่ใน AppBar
      ],
    );
  }

  Widget _buildMenuButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: GoogleFonts.notoSansLaoLooped(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDropdownMenu(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF2C3E70),
          iconEnabledColor: Colors.white,
          style: GoogleFonts.notoSansLaoLooped(color: Colors.white),
          hint: Text(
            title,
            style: GoogleFonts.notoSansLaoLooped(color: Colors.white),
          ),
          onChanged: (value) {
            // TODO: Handle dropdown selection
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.notoSansLaoLooped(color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
