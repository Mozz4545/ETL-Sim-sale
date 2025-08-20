import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/session_manager.dart';

/// Widget แสดงข้อมูล session ปัจจุบัน
/// รวมเวลาล็อกอิน, เวลาที่เหลือก่อน auto-logout, และสถานะ session
class SessionInfoWidget extends ConsumerStatefulWidget {
  const SessionInfoWidget({super.key});

  @override
  ConsumerState<SessionInfoWidget> createState() => _SessionInfoWidgetState();
}

class _SessionInfoWidgetState extends ConsumerState<SessionInfoWidget> {
  Map<String, dynamic>? sessionData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessionData();

    // อัปเดตข้อมูลทุก 30 วินาที
    _startPeriodicUpdate();
  }

  void _startPeriodicUpdate() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _loadSessionData();
        _startPeriodicUpdate();
      }
    });
  }

  Future<void> _loadSessionData() async {
    final data = await SessionManager.getSessionData();
    if (mounted) {
      setState(() {
        sessionData = data;
        isLoading = false;
      });
    }
  }

  String _formatDuration(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return '${duration.inDays} ວັນກ່ອນ';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ຊົ່ວໂມງກ່ອນ';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} ນາທີກ່ອນ';
    } else {
      return 'ຫາກໃສ່';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (sessionData == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'ບໍ່ມີ session ທີ່ມີຜົນບັງຄັບໃຊ້',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final email = sessionData!['email'] as String;
    final loginTime = sessionData!['loginTime'] as DateTime;
    final lastActivity = sessionData!['lastActivity'] as DateTime?;
    final timeRemaining = sessionData!['timeRemaining'] as int;
    final isValid = sessionData!['isValid'] as bool;
    final isInactivityExpired = sessionData!['isInactivityExpired'] as bool;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isValid ? Icons.security : Icons.security_outlined,
                  color: isValid ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'ຂໍ້ມູນ Session',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),

            // Session Status
            _buildInfoRow(
              'ສະຖານະ',
              isValid ? 'ຍັງມີຜົນ' : 'ໝົດອາຍຸແລ້ວ',
              isValid ? Colors.green : Colors.red,
            ),

            // Email
            _buildInfoRow('ອີເມວ', email, Colors.blue),

            // Login Time
            _buildInfoRow(
              'ເວລາເຂົ້າສູ່ລະບົບ',
              _formatDuration(loginTime),
              Colors.grey[600],
            ),

            // Last Activity
            if (lastActivity != null)
              _buildInfoRow(
                'ກິດຈະກຳຫຼ້າສຸດ',
                _formatDuration(lastActivity),
                Colors.grey[600],
              ),

            // Time Remaining
            _buildInfoRow(
              'ເວລາທີ່ເຫຼືອກ່ອນ Auto-logout',
              timeRemaining > 0 ? '$timeRemaining ນາທີ' : 'ໝົດເວລາແລ້ວ',
              timeRemaining > 10
                  ? Colors.green
                  : timeRemaining > 0
                  ? Colors.orange
                  : Colors.red,
            ),

            // Inactivity Status
            if (isInactivityExpired)
              _buildInfoRow(
                'ສາເຫດ',
                'ບໍ່ມີການເຄື່ອນໄຫວເກີນ 60 ນາທີ',
                Colors.red,
              ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loadSessionData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ອັບເດດ'),
                ),
                const SizedBox(width: 8),
                if (isValid)
                  TextButton.icon(
                    onPressed: () async {
                      await SessionManager.updateActivity();
                      _loadSessionData();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ອັບເດດການເຄື່ອນໄຫວແລ້ວ'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.touch_app),
                    label: const Text('ອັບເດດການເຄື່ອນໄຫວ'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
