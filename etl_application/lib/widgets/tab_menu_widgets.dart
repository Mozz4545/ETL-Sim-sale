import 'package:flutter/material.dart';

class TabMenuItem extends StatelessWidget {
  final String title;
  final bool lao;
  final VoidCallback? onPressed;
  const TabMenuItem({required this.title, this.lao = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onPressed ?? () {},
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontFamily: lao ? 'Phetsalath_OT' : null,
            fontWeight: lao ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class TabDropdownMenu extends StatelessWidget {
  final String title;
  final List<String> items;
  const TabDropdownMenu({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    bool isLao(String text) {
      // crude check for Lao unicode range
      return RegExp(r'[\u0E80-\u0EFF]').hasMatch(text);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: isLao(title) ? 'Phetsalath_OT' : null,
              fontWeight: isLao(title) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(
                      fontFamily: isLao(e) ? 'Phetsalath_OT' : null,
                      fontWeight: isLao(e)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {},
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
