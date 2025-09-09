import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/service/auth_service.dart';
import '../../checkout/pages/checkout_page.dart';
import '../../../features/auth/provider/auth_provider.dart';
import '../../sim_store/presentation/pages/cart_page.dart';
import '../../sim_store/providers/sim_store_provider.dart';

class MainMenuBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onLogout;

  const MainMenuBar({super.key, this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width >= 800;
    final authStream = ref.watch(authStreamProvider);
    final bool isAuthenticated = authStream.asData?.value != null;
    final cart = ref.watch(cartProvider);

    return SizedBox(
      height: isWide ? 120 : 72,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (isWide)
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
            child: isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: logo + menu
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
                                'ຫນ້າຫຼັກ',
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/home'),
                              ),
                              _buildMenuButton(
                                'ຊິມກາດ',
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/sim-store'),
                              ),

                              _buildDropdownMenu(context, 'ລາຍການສັ່ງຊື້', {
                                'ຄຳສັ່ງຊື້ສຳຫລັບຊິມກາດ': '/cart',
                                'ປະຫວັດການສັ່ງຊື້': '/order-history',
                              }),
                              _buildMenuButton(
                                'ບັນຊີຜູ້ໃຊ້',
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/profile'),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Right: cart + login/logout
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
                                      builder: (context) =>
                                          // Use CartPage instead of CheckoutPage
                                          // Import if needed
                                          // ignore: prefer_const_constructors
                                          CartPage(),
                                    ),
                                  );
                                },
                              ),
                              if (cart.isNotEmpty)
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
                                    child: Center(
                                      child: Text(
                                        '${cart.length}',
                                        style: const TextStyle(
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
                          if (isAuthenticated)
                            ElevatedButton(
                              onPressed:
                                  onLogout ??
                                  () async {
                                    final shouldLogout = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'ຢືນຢັນການອອກຈາກລະບົບ',
                                          style:
                                              GoogleFonts.notoSansLaoLooped(),
                                        ),
                                        content: Text(
                                          'ທ່ານຕ້ອງການອອກຈາກລະບົບບໍ?',
                                          style:
                                              GoogleFonts.notoSansLaoLooped(),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(false),
                                            child: Text(
                                              'ຍົກເລີກ',
                                              style:
                                                  GoogleFonts.notoSansLaoLooped(),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                    255,
                                                    255,
                                                    0,
                                                    0,
                                                  ),
                                            ),
                                            child: Text(
                                              'ອອກຈາກລະບົບ',
                                              style:
                                                  GoogleFonts.notoSansLaoLooped(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (shouldLogout == true) {
                                      try {
                                        await ref
                                            .read(authProvider.notifier)
                                            .signOut();
                                        ref.refresh(authProvider);
                                        if (context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/splash',
                                            (route) => false,
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
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
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  0,
                                  0,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                'ອອກຈາກລະບົບ',
                                style: GoogleFonts.notoSansLaoLooped(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Logo
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/home'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/ETL_logo.jpg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),

                      // Right: Cart + Hamburger
                      Row(
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
                          const SizedBox(width: 4),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.menu, color: Colors.black),
                            onSelected: (value) async {
                              switch (value) {
                                case 'home':
                                  Navigator.pushNamed(context, '/home');
                                  break;
                                case 'sim':
                                  Navigator.pushNamed(context, '/sim-store');
                                  break;
                                case 'package':
                                  Navigator.pushNamed(context, '/sim-store');
                                  break;
                                case 'checkout':
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CheckoutPage(),
                                    ),
                                  );
                                  break;
                                case 'orders':
                                  Navigator.pushNamed(
                                    context,
                                    '/order-history',
                                  );
                                  break;
                                case 'profile':
                                  Navigator.pushNamed(context, '/profile');
                                  break;
                                case 'logout':
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
                                            style:
                                                GoogleFonts.notoSansLaoLooped(),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  255,
                                                  0,
                                                  0,
                                                ),
                                          ),
                                          child: Text(
                                            'ອອກຈາກລະບົບ',
                                            style:
                                                GoogleFonts.notoSansLaoLooped(
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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
                                  break;
                                case 'login':
                                  Navigator.pushNamed(context, '/login');
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'home',
                                child: Text(
                                  'ຫນ້າຫຼັກ',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'sim',
                                child: Text(
                                  'ຊິມກາດ',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'package',
                                child: Text(
                                  'ແພັກເກດຂໍ້ມູນ',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem(
                                value: 'checkout',
                                child: Text(
                                  'ຄຳສັ່ງຊື້ສຳຫລັບຊິມກາດ',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'orders',
                                child: Text(
                                  'ປະຫວັດການສັ່ງຊື້',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem(
                                value: 'profile',
                                child: Text(
                                  'ບັນຊີຜູ້ໃຊ້',
                                  style: GoogleFonts.notoSansLaoLooped(),
                                ),
                              ),
                              if (isAuthenticated)
                                PopupMenuItem(
                                  value: 'logout',
                                  child: Text(
                                    'ອອກຈາກລະບົບ',
                                    style: GoogleFonts.notoSansLaoLooped(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              else
                                PopupMenuItem(
                                  value: 'login',
                                  child: Text(
                                    'ເຂົ້າສູ່ລະບົບ',
                                    style: GoogleFonts.notoSansLaoLooped(),
                                  ),
                                ),
                            ],
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
  Size get preferredSize {
    // Compute logical width without BuildContext for a dynamic height
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalWidth = view.physicalSize.width / view.devicePixelRatio;
    final bool isWide = logicalWidth >= 800;
    return Size.fromHeight(isWide ? 120 : 72);
  }
}
