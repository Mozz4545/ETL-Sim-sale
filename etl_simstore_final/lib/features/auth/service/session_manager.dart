import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/auth_provider.dart';

// Session Manager สำหรับจัดการ session และ auto-login
class SessionManager {
  static const String _keyRememberLogin = 'remember_login';
  static const String _keyUserEmail = 'user_email';
  static const String _keyLoginTime = 'login_time';
  static const String _keySessionDuration = 'session_duration';
  static const String _keyLastActivityTime = 'last_activity_time';
  static const String _keyInactivityTimeoutMinutes =
      'inactivity_timeout_minutes';

  // เก็บ timer สำหรับ auto logout
  static Timer? _inactivityTimer;
  static WidgetRef? _ref;

  // บันทึก session และเริ่ม inactivity timer
  static Future<void> saveSession({
    required String email,
    bool rememberMe = false,
    int sessionDurationDays = 30,
    int inactivityTimeoutMinutes = 60, // 60 นาที auto logout
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyRememberLogin, rememberMe);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setInt(_keyLoginTime, DateTime.now().millisecondsSinceEpoch);
    await prefs.setInt(_keySessionDuration, sessionDurationDays);
    await prefs.setInt(
      _keyLastActivityTime,
      DateTime.now().millisecondsSinceEpoch,
    );
    await prefs.setInt(_keyInactivityTimeoutMinutes, inactivityTimeoutMinutes);

    // เริ่ม inactivity timer
    _startInactivityTimer(inactivityTimeoutMinutes);
  }

  // เริ่ม timer สำหรับ auto logout
  static void _startInactivityTimer(int timeoutMinutes) {
    _cancelInactivityTimer();

    _inactivityTimer = Timer(Duration(minutes: timeoutMinutes), () async {
      print('Session timeout - Auto logout triggered');
      await _handleAutoLogout();
    });
  }

  // ยกเลิก timer
  static void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  // จัดการ auto logout
  static Future<void> _handleAutoLogout() async {
    try {
      // Clear session data
      await clearSession();

      // ถ้ามี provider reference ให้ logout ผ่าน provider
      if (_ref != null) {
        await _ref!.read(authProvider.notifier).signOut();
      }

      print('Auto logout completed due to inactivity');
    } catch (e) {
      print('Error during auto logout: $e');
    }
  }

  // อัพเดท activity time และรีสตาร์ท timer
  static Future<void> updateActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberLogin = prefs.getBool(_keyRememberLogin) ?? false;

      if (rememberLogin) {
        await prefs.setInt(
          _keyLastActivityTime,
          DateTime.now().millisecondsSinceEpoch,
        );

        // รีสตาร์ท timer
        final timeoutMinutes = prefs.getInt(_keyInactivityTimeoutMinutes) ?? 60;
        _startInactivityTimer(timeoutMinutes);
      }
    } catch (e) {
      print('Error updating activity: $e');
    }
  }

  // ตรวจสอบว่า session หมดเวลาเนื่องจาก inactivity หรือไม่
  static Future<bool> isInactivityExpired() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final lastActivityTime = prefs.getInt(_keyLastActivityTime);
      final timeoutMinutes = prefs.getInt(_keyInactivityTimeoutMinutes) ?? 60;

      if (lastActivityTime == null) return false;

      final lastActivity = DateTime.fromMillisecondsSinceEpoch(
        lastActivityTime,
      );
      final expiryTime = lastActivity.add(Duration(minutes: timeoutMinutes));

      return DateTime.now().isAfter(expiryTime);
    } catch (e) {
      return false;
    }
  }

  // เซ็ต provider reference สำหรับ auto logout
  static void setProviderRef(dynamic ref) {
    _ref = ref as WidgetRef?;
  }

  // ตรวจสอบ session ยังใช้ได้หรือไม่ (รวม inactivity check)
  static Future<bool> isSessionValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final rememberLogin = prefs.getBool(_keyRememberLogin) ?? false;
      if (!rememberLogin) return false;

      final loginTime = prefs.getInt(_keyLoginTime);
      final sessionDuration = prefs.getInt(_keySessionDuration) ?? 30;

      if (loginTime == null) return false;

      // ตรวจสอบ session expiry (long term)
      final loginDate = DateTime.fromMillisecondsSinceEpoch(loginTime);
      final expiryDate = loginDate.add(Duration(days: sessionDuration));
      final isLongTermValid = DateTime.now().isBefore(expiryDate);

      // ตรวจสอบ inactivity expiry (short term)
      final isInactivityValid = !(await isInactivityExpired());

      // ถ้า inactivity หมดเวลาแล้ว ให้ auto logout
      if (!isInactivityValid) {
        await _handleAutoLogout();
        return false;
      }

      return isLongTermValid && isInactivityValid;
    } catch (e) {
      return false;
    }
  }

  // ดึงข้อมูล session (รวมข้อมูล inactivity)
  static Future<Map<String, dynamic>?> getSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final rememberLogin = prefs.getBool(_keyRememberLogin) ?? false;
      final userEmail = prefs.getString(_keyUserEmail);
      final loginTime = prefs.getInt(_keyLoginTime);
      final sessionDuration = prefs.getInt(_keySessionDuration) ?? 30;
      final lastActivityTime = prefs.getInt(_keyLastActivityTime);
      final timeoutMinutes = prefs.getInt(_keyInactivityTimeoutMinutes) ?? 60;

      if (!rememberLogin || userEmail == null || loginTime == null) {
        return null;
      }

      final lastActivity = lastActivityTime != null
          ? DateTime.fromMillisecondsSinceEpoch(lastActivityTime)
          : null;

      final timeRemaining = lastActivity != null
          ? lastActivity
                .add(Duration(minutes: timeoutMinutes))
                .difference(DateTime.now())
          : Duration.zero;

      return {
        'email': userEmail,
        'loginTime': DateTime.fromMillisecondsSinceEpoch(loginTime),
        'sessionDuration': sessionDuration,
        'lastActivity': lastActivity,
        'inactivityTimeout': timeoutMinutes,
        'timeRemaining': timeRemaining.inMinutes > 0
            ? timeRemaining.inMinutes
            : 0,
        'isValid': await isSessionValid(),
        'isInactivityExpired': await isInactivityExpired(),
      };
    } catch (e) {
      return null;
    }
  }

  // ล้าง session และยกเลิก timer
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_keyRememberLogin);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keyLoginTime);
      await prefs.remove(_keySessionDuration);
      await prefs.remove(_keyLastActivityTime);
      await prefs.remove(_keyInactivityTimeoutMinutes);

      // ยกเลิก timer เมื่อ logout manual
      _cancelInactivityTimer();

      print('🧹 ล้าง session เรียบร้อยแล้ว');
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการล้าง session: $e');
    }
  }

  // ต่ออายุ session
  static Future<void> refreshSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLogin = prefs.getBool(_keyRememberLogin) ?? false;

    if (rememberLogin) {
      await prefs.setInt(_keyLoginTime, DateTime.now().millisecondsSinceEpoch);
    }
  }
}

// Provider สำหรับ Session Manager
final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager();
});

// Provider สำหรับตรวจสอบ session validity
final sessionValidityProvider = FutureProvider<bool>((ref) async {
  return await SessionManager.isSessionValid();
});

// Provider สำหรับ session data
final sessionDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return await SessionManager.getSessionData();
});

// Auto-login Provider
final autoLoginProvider = FutureProvider<bool>((ref) async {
  try {
    // ตรวจสอบ session validity
    final isValid = await SessionManager.isSessionValid();
    if (!isValid) {
      await SessionManager.clearSession();
      return false;
    }

    // ตรวจสอบ Firebase Auth state ผ่าน provider
    final authState = ref.read(authProvider);
    if (authState.isLoggedIn) {
      // Refresh session time
      await SessionManager.refreshSession();
      return true;
    }

    // ถ้า session valid แต่ Firebase Auth หลุด ให้ clear session
    await SessionManager.clearSession();
    return false;
  } catch (e) {
    await SessionManager.clearSession();
    return false;
  }
});
