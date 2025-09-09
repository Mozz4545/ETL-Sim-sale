import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const ProfileField({
    required this.label,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF4F8FFF)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F8FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    value.isEmpty ? '-' : value,
                    style: const TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
