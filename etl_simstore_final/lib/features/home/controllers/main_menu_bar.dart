import 'package:flutter/material.dart';

class MainMenuBar extends StatelessWidget implements PreferredSizeWidget {
  const MainMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 22, 53, 134),
      title: Text(
        'Main Menu',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 4,
      actions: screenWidth > 600
          ? [
              _buildMenuItem('Home', Icons.home),
              _buildMenuItem('Profile', Icons.person),
              _buildMenuItem('Settings', Icons.settings),
              _buildMenuItem('Logout', Icons.logout),
            ]
          : [
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle menu item selection
                  print('Selected: $value');
                },
                itemBuilder: (context) => [
                  _buildPopupMenuItem('Home', Icons.home),
                  _buildPopupMenuItem('Profile', Icons.person),
                  _buildPopupMenuItem('Settings', Icons.settings),
                  _buildPopupMenuItem('Logout', Icons.logout),
                ],
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String title, IconData icon) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
