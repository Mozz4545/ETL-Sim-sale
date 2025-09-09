import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ETL Company Information Bar Widget
/// A responsive footer/info bar that displays company information,
/// contact details, and social media links.
///
/// Usage:
/// ```dart
/// InfoBar()
/// ```
class InfoBar extends StatelessWidget {
  const InfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      children: [
        Container(
          color: isDark ? Colors.grey[900] : const Color(0xFF061731),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogoSection(),
                    const SizedBox(height: 24),
                    _buildContactSection(isDark),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogoSection(),
                    const SizedBox(width: 48),
                    Expanded(child: _buildContactSection(isDark)),
                  ],
                ),
        ),
        Container(
          width: double.infinity,
          color: isDark ? Colors.black : const Color(0xFF031226),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          child: Center(
            child: Text.rich(
              TextSpan(
                text: '© ',
                style: GoogleFonts.notoSansLao(
                  color: isDark ? Colors.white70 : Colors.white,
                  fontSize: 13,
                ),
                children: const [
                  TextSpan(
                    text: 'ETL Shopping',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' - @ETL Company Ltd, Business Support Division, Software Development',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00A9E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset('assets/ETL_logo.jpg', fit: BoxFit.contain),
    );
  }

  Widget _buildContactSection(bool isDark) {
    final iconColor = isDark ? Colors.white70 : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get In Touch',
          style: GoogleFonts.notoSansLao(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.location_on,
          'Saylom Rd, Saylom Village, Chanthabuly District, Vientiane Capital, Lao PDR',
          iconColor,
          textColor,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.email, 'csd@etllao.com', iconColor, textColor),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.phone, '+(856)21 260051', iconColor, textColor),
        const SizedBox(height: 20),
        Row(
          children: [
            _socialIcon(Icons.facebook, Colors.blue[800]!),
            const SizedBox(width: 10),
            _socialIcon(Icons.video_library, Colors.black),
            const SizedBox(width: 10),
            _socialIcon(Icons.play_circle, Colors.red[700]!),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    Color iconColor,
    Color textColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.notoSansLao(
              color: textColor,
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
