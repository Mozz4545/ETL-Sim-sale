// Deprecated: Use `MainMenuBar` in `features/home/controllers/main_menu_bar.dart` instead.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features/auth/provider/auth_provider.dart';

@Deprecated(
  'Use MainMenuBar (features/home/controllers/main_menu_bar.dart) instead',
)
class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBack;

  const MainAppBar({super.key, this.title, this.actions, this.showBack = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return AppBar(
      automaticallyImplyLeading: showBack,
      title: Text(
        title ?? 'ETL Sim Store',
        style: GoogleFonts.notoSansLaoLooped(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 22, 53, 134),
      actions:
          actions ??
          [
            if (user != null)
              IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'Profile',
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Cart',
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
            if (user == null)
              IconButton(
                icon: const Icon(Icons.login),
                tooltip: 'Login',
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
          ],
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
