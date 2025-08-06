import 'package:flutter/material.dart';
import 'package:etl_application/screens/dashboard_screen.dart';
import 'package:etl_application/widgets/tab_menu_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                color: Colors.grey[300],
                height: 60,
                child: Row(
                  children: [
                    // ตำแหน่งโลโก้ ETL (สามารถเปลี่ยนเป็นรูปภาพได้ภายหลัง)
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
                    // เว้นระยะห่างระหว่างโลโก้ ETL กับเมนู
                    const Spacer(),
                    // เมนูหลัก
                    TabMenuItem(
                      title: 'ໜ້າຫຼັກ',
                      lao: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                      },
                    ),
                    TabMenuItem(title: 'ຊິມກາດ', lao: true),
                    TabMenuItem(title: 'ແພັດເກັດຂໍ້ມູນ', lao: true),
                    TabDropdownMenu(
                      title: 'FTTH',
                      items: ['FTTH', 'FTTH via CPE'],
                    ),
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
                    // ไอคอนตะกร้าสินค้าพร้อมแสดงจำนวน
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 32,
                          color: Colors.black87,
                        ),
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
                    // ปุ่มเข้าสู่ระบบ
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('ເຂົ້າສູ່ລະບົບ'),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              // ส่วนกลางสำหรับล็อกอิน
              Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'ເຂົ້າສູ່ລະບົບ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Phetsalath_OT',
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        icon: const Icon(Icons.mail),
                        label: const Text('Login via Gmail'),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        icon: const Icon(Icons.facebook),
                        label: const Text('Login via Facebook'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ...existing code...
