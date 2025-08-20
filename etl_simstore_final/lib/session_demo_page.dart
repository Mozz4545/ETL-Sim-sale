import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/auth.dart';

/// ตัวอย่างการใช้งาน Auto-logout Session Management
/// สาธิตการแสดงข้อมูล session และการทดสอบ auto-logout
class SessionDemoPage extends ConsumerStatefulWidget {
  const SessionDemoPage({super.key});

  @override
  ConsumerState<SessionDemoPage> createState() => _SessionDemoPageState();
}

class _SessionDemoPageState extends ConsumerState<SessionDemoPage> {
  @override
  void initState() {
    super.initState();

    // ตั้งค่า provider reference สำหรับ auto-logout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ใช้ได้เฉพาะใน ConsumerWidget context
      // SessionManager.setProviderRef(ref); // จะตั้งค่าใน build method แทน
    });
  }

  void _simulateUserActivity() {
    // จำลองการกดปุ่มของผู้ใช้
    SessionManager.updateActivity();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎯 อัปเดตการเคื่อนไหวแล้ว - Timer รีเซ็ตใหม่'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _testAutoLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ทดสอบ Auto-logout'),
        content: const Text(
          'ระบบจะ logout อัตโนมัติหลังจาก 60 นาทีที่ไม่มีการเคื่อนไหว\n\n'
          'เพื่อทดสอบ คุณสามารถ:\n'
          '1. ปิดแอปทิ้งไว้ 60+ นาทีแล้วเปิดใหม่\n'
          '2. หรือแก้ไขเวลาใน SessionManager เป็น 1-2 นาที\n\n'
          'เมื่อ auto-logout เกิดขึ้น ระบบจะ:\n'
          '• ลบ session ออกจาก storage\n'
          '• อัปเดต auth state เป็น logged out\n'
          '• แสดง dialog แจ้งเตือน',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('เข้าใจแล้ว'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // ตั้งค่า provider reference ใน build method
    SessionManager.setProviderRef(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Management Demo'),
        backgroundColor: Colors.blue.shade100,
        actions: [
          if (isAuthenticated)
            IconButton(
              onPressed: () {
                ref.read(authProvider.notifier).signOut();
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Auth Status Card
            Card(
              color: isAuthenticated
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      isAuthenticated
                          ? Icons.security
                          : Icons.security_outlined,
                      size: 48,
                      color: isAuthenticated ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAuthenticated
                          ? 'ເຂົ້າສູ່ລະບົບແລ້ວ'
                          : 'ຍັງບໍ່ໄດ້ເຂົ້າສູ່ລະບົບ',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: isAuthenticated ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (authState.user != null)
                      Text(
                        authState.user!.email ?? 'No email',
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Session Info Widget (แสดงเฉพาะเมื่อ login แล้ว)
            if (isAuthenticated) ...[
              const SessionInfoWidget(),
              const SizedBox(height: 16),

              // Action Buttons
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'การทดสอบ Session Management',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Simulate Activity Button
                      ElevatedButton.icon(
                        onPressed: _simulateUserActivity,
                        icon: const Icon(Icons.touch_app),
                        label: const Text('จำลองการเคื่อนไหวของผู้ใช้'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Test Auto-logout Info Button
                      OutlinedButton.icon(
                        onPressed: _testAutoLogout,
                        icon: const Icon(Icons.info_outline),
                        label: const Text('ข้อมูลการทดสอบ Auto-logout'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info Text
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: const Text(
                          '💡 Tips:\n'
                          '• กดปุ่ม "จำลองการเคื่อนไหว" เพื่อรีเซ็ต timer\n'
                          '• ระบบจะ logout อัตโนมัติหลังจาก 60 นาทีไม่มีการเคื่อนไหว\n'
                          '• การเคื่อนไหวจริงในแอป เช่น การเลื่อน, กดปุ่ม จะรีเซ็ต timer อัตโนมัติ',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Login Example Widget (แสดงเมื่อยังไม่ login)
              const AuthExampleWidget(),
            ],
          ],
        ),
      ),
    );
  }
}
