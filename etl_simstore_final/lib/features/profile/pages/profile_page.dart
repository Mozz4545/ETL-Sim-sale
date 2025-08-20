import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/auth.dart';
import '../../home/controllers/custom_navbar_logout.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // เริ่ม Session Management เมื่อเข้าหน้า Profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SessionManager.setProviderRef(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: const CustomNavbarLogout(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 53, 134),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ບັນຊີຜູ້ໃຊ້',
                    style: GoogleFonts.notoSansLaoLooped(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ຈັດການຂໍ້ມູນສ່ວນຕົວແລະການຕັ້ງຄ່າບັນຊີ',
                    style: GoogleFonts.notoSansLaoLooped(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (!isAuthenticated) ...[
              // ถ้ายังไม่ Login
              _buildNotLoggedInCard(),
            ] else ...[
              // ถ้า Login แล้ว
              _buildUserInfoCard(user),
              const SizedBox(height: 16),
              _buildSessionInfoCard(),
              const SizedBox(height: 16),
              _buildQuickActionsCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedInCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Column(
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'ຍັງບໍ່ໄດ້ເຂົ້າສູ່ລະບົບ',
              style: GoogleFonts.notoSansLaoLooped(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ກະລຸນາເຂົ້າສູ່ລະບົບເພື່ອເບິ່ງຂໍ້ມູນບັນຊີ',
              style: GoogleFonts.notoSansLaoLooped(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              icon: const Icon(Icons.login),
              label: Text(
                'ເຂົ້າສູ່ລະບົບ',
                style: GoogleFonts.notoSansLaoLooped(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 22, 53, 134),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color.fromARGB(255, 22, 53, 134),
                  child: Text(
                    user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ຂໍ້ມູນຜູ້ໃຊ້',
                        style: GoogleFonts.notoSansLaoLooped(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 22, 53, 134),
                        ),
                      ),
                      Text(
                        user?.email ?? 'ບໍ່ມີຂໍ້ມູນ',
                        style: GoogleFonts.notoSansLaoLooped(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            _buildInfoRow('ອີເມວ:', user?.email ?? 'ບໍ່ມີຂໍ້ມູນ'),
            _buildInfoRow('ສະຖານະ:', 'ເຂົ້າສູ່ລະບົບແລ້ວ'),
            _buildInfoRow('ບົດບາດ:', 'ລູກຄ້າ'),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ຂໍ້ມູນ Session',
              style: GoogleFonts.notoSansLaoLooped(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 22, 53, 134),
              ),
            ),
            const SizedBox(height: 16),

            // Session Info Widget แบบ Embedded
            const SessionInfoWidget(),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      SessionManager.updateActivity();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'ອັບເດດການເຄື່ອນໄຫວແລ້ວ',
                            style: GoogleFonts.notoSansLaoLooped(),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'ອັບເດດການເຄື່ອນໄຫວ',
                      style: GoogleFonts.notoSansLaoLooped(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ການກະທຳດ່ວນ',
              style: GoogleFonts.notoSansLaoLooped(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 22, 53, 134),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'ປະຫວັດການສັ່ງຊື້',
                    Icons.history,
                    () => Navigator.pushNamed(context, '/order-history'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'ຮ້ານ SIM',
                    Icons.store,
                    () => Navigator.pushNamed(context, '/sim-store'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'ກະຕ່າ',
                    Icons.shopping_cart,
                    () => Navigator.pushNamed(context, '/cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'ໜ້າຫຼັກ',
                    Icons.home,
                    () => Navigator.pushNamed(context, '/home'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.notoSansLaoLooped(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.notoSansLaoLooped(color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: GoogleFonts.notoSansLaoLooped()),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 22, 53, 134),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
