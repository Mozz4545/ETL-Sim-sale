import 'package:flutter/material.dart';
import 'package:etl_application/core/widgets/tab_menu_widgets.dart';
import 'package:etl_application/screens/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // แถบสีน้ำเงินด้านบน
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Saylom Rd, Saylom Village, Chanthabuly District, Vientiane Capital 01000 Lao PDR Post code: 7953',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 24),
                    Icon(Icons.phone, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '+(856)21 260051',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(width: 24),
                    Icon(Icons.mail, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'csd@etllao.com',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // แถบเมนูสีเทา
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            height: 60,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Center(
                      child: Image.asset(
                        'assets/ETL_logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                TabMenuItem(title: 'ໜ້າຫຼັກ', lao: true),
                TabMenuItem(title: 'ຊິມກາດ', lao: true),
                TabMenuItem(title: 'ແພັດເກັດຂໍ້ມູນ', lao: true),
                TabDropdownMenu(title: 'FTTH', items: ['FTTH', 'FTTH via CPE']),
                TabDropdownMenu(
                  title: 'ລາຍການສັ່ງຊື່',
                  items: [
                    'ຄຳສັ່ງຊື້ສຳລັບຊິມກາດ',
                    'ຄຳສັ່ງຊື້ FTTH',
                    'ປະຫວັດການສັ່ງຊື້',
                  ],
                ),
                TabDropdownMenu(
                  title: 'ບັນຊີຂອງຂ້ອຍ',
                  items: [
                    'ຄວາມຄິດເຫັນ',
                    'ຕິດຕໍ່ພວກເຮົາ',
                    'ພະນັກງານເຂົ້າສູ່ລະບົບ',
                  ],
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(Icons.shopping_cart, size: 32, color: Colors.black87),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('ເຂົ້າສູ່ລະບົບ'),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // ส่วนเนื้อหา dashboard
          Expanded(
            child: Center(
              child: Text(
                'Welcome to Dashboard!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
