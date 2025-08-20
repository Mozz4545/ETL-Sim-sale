import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
import '../service/session_manager.dart';

// ตัวอย่างการใช้งาน Auth Provider ใน Widget
class AuthExampleWidget extends ConsumerWidget {
  const AuthExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final user = ref.watch(userProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final isLoading = ref.watch(authLoadingProvider);
    final error = ref.watch(authErrorProvider);

    // Watch session data
    final sessionData = ref.watch(sessionDataProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAuthenticated ? 'ຍິນດີຕ້ອນຮັບ' : 'ເຂົ້າສູ່ລະບົບ',
          style: const TextStyle(fontFamily: 'NotoSansLao'),
        ),
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _handleSignOut(ref),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error Display
            if (error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontFamily: 'NotoSansLao',
                  ),
                ),
              ),

            // User Info Display
            if (isAuthenticated && user != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ຂໍ້ມູນຜູ້ໃຊ້',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansLao',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ອີເມວ: ${user.email ?? "ບໍ່ມີ"}',
                        style: const TextStyle(fontFamily: 'NotoSansLao'),
                      ),
                      Text(
                        'UID: ${user.uid}',
                        style: const TextStyle(fontFamily: 'NotoSansLao'),
                      ),
                      Text(
                        'ຊື່ຜູ້ໃຊ້: ${user.displayName ?? "ບໍ່ມີ"}',
                        style: const TextStyle(fontFamily: 'NotoSansLao'),
                      ),
                      Text(
                        'ຢືນຢັນອີເມວ: ${user.emailVerified ? "ແລ້ວ" : "ຍັງບໍ່"}',
                        style: const TextStyle(fontFamily: 'NotoSansLao'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Session Info
              sessionData.when(
                data: (data) {
                  if (data != null) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ຂໍ້ມູນ Session',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSansLao',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ເວລາເຂົ້າສູ່ລະບົບ: ${data['loginTime']}',
                              style: const TextStyle(fontFamily: 'NotoSansLao'),
                            ),
                            Text(
                              'ໄລຍະ Session: ${data['sessionDuration']} ວັນ',
                              style: const TextStyle(fontFamily: 'NotoSansLao'),
                            ),
                            Text(
                              'ສະຖານະ: ${data['isValid'] ? "ໃຊ້ໄດ້" : "ໝົດອາຍຸ"}',
                              style: const TextStyle(fontFamily: 'NotoSansLao'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
            ],

            // Auth Actions
            if (!isAuthenticated) ...[
              ElevatedButton(
                onPressed: () => _showLoginDialog(context, ref),
                child: const Text(
                  'ເຂົ້າສູ່ລະບົບດ້ວຍອີເມວ',
                  style: TextStyle(fontFamily: 'NotoSansLao'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _handleGoogleSignIn(ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'ເຂົ້າສູ່ລະບົບດ້ວຍ Google',
                  style: TextStyle(fontFamily: 'NotoSansLao'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _handleFacebookSignIn(ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'ເຂົ້າສູ່ລະບົບດ້ວຍ Facebook',
                  style: TextStyle(fontFamily: 'NotoSansLao'),
                ),
              ),
            ],

            const Spacer(),

            // Clear Error Button
            if (error != null)
              ElevatedButton(
                onPressed: () => ref.read(authProvider.notifier).clearError(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text(
                  'ລຶບຂໍ້ຜິດພາດ',
                  style: TextStyle(fontFamily: 'NotoSansLao'),
                ),
              ),

            // Refresh Button
            ElevatedButton(
              onPressed: () =>
                  ref.read(authProvider.notifier).refreshAuthState(),
              child: const Text(
                'ໂຫຼດຂໍ້ມູນໃໝ່',
                style: TextStyle(fontFamily: 'NotoSansLao'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool rememberMe = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'ເຂົ້າສູ່ລະບົບ',
            style: TextStyle(fontFamily: 'NotoSansLao'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'ອີເມວ',
                  labelStyle: TextStyle(fontFamily: 'NotoSansLao'),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'ລະຫັດຜ່ານ',
                  labelStyle: TextStyle(fontFamily: 'NotoSansLao'),
                ),
                obscureText: true,
              ),
              CheckboxListTile(
                title: const Text(
                  'ຈົດຈໍາການເຂົ້າສູ່ລະບົບ',
                  style: TextStyle(fontFamily: 'NotoSansLao'),
                ),
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ຍົກເລີກ',
                style: TextStyle(fontFamily: 'NotoSansLao'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleEmailLogin(
                  ref,
                  emailController.text,
                  passwordController.text,
                  rememberMe,
                );
              },
              child: const Text(
                'ເຂົ້າສູ່ລະບົບ',
                style: TextStyle(fontFamily: 'NotoSansLao'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEmailLogin(
    WidgetRef ref,
    String email,
    String password,
    bool rememberMe,
  ) async {
    try {
      await ref
          .read(authProvider.notifier)
          .signInWithEmailAndPassword(
            email: email,
            password: password,
            rememberMe: rememberMe,
          );
    } catch (e) {
      // Error handled by provider
    }
  }

  Future<void> _handleGoogleSignIn(WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      // Error handled by provider
    }
  }

  Future<void> _handleFacebookSignIn(WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signInWithFacebook();
    } catch (e) {
      // Error handled by provider
    }
  }

  Future<void> _handleSignOut(WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signOut();
      await SessionManager.clearSession();
    } catch (e) {
      // Error handled by provider
    }
  }
}
