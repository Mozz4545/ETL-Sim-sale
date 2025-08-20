import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool _isLoading = false;

  static bool get isLoading => _isLoading;

  // ตรวจสอบว่า user login แล้วหรือยัง
  static Future<bool> isUserLoggedIn() async {
    try {
      _isLoading = true;
      User? user = _auth.currentUser;
      if (user != null) {
        // ตรวจสอบว่า user ยังใช้งานได้อยู่หรือไม่
        await user.reload();

        // ตรวจสอบจาก SharedPreferences ด้วย
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isRemembered = prefs.getBool('remember_login') ?? false;
        return isRemembered && _auth.currentUser != null;
      }
      return false;
    } catch (e) {
      print('Auth check error: $e');
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Login ด้วย Email และ Password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _isLoading = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // บันทึกสถานะ login
      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_login', true);
        await prefs.setString('user_email', email);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'ເກີດຂໍ້ຜິດພາດໃນການເຂົ້າສູ່ລະບົບ';
    } finally {
      _isLoading = false;
    }
  }

  // Sign Up ด้วย Email และ Password
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // บันทึกสถานะ login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_login', true);
      await prefs.setString('user_email', email);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'ເກີດຂໍ້ຜິດພາດໃນການສະໝັກສະມາຊິກ';
    } finally {
      _isLoading = false;
    }
  }

  // Logout
  static Future<void> signOut() async {
    try {
      _isLoading = true;
      await _auth.signOut();

      // ลบข้อมูลจาก SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('remember_login');
      await prefs.remove('user_email');
    } catch (e) {
      throw 'ເກີດຂໍ້ຜິດພາດໃນການອອກຈາກລະບົບ';
    } finally {
      _isLoading = false;
    }
  }

  // รีเซ็ตรหัสผ่าน
  static Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'ເກີດຂໍ້ຜິດພາດໃນການຣີເຊັດລະຫັດຜ່ານ';
    } finally {
      _isLoading = false;
    }
  }

  // ดึงข้อมูล User ปัจจุบัน
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Google Sign-In
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // สำหรับ Web Platform
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithPopup(googleProvider);

        // บันทึกสถานะ login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_login', true);
        if (userCredential.user?.email != null) {
          await prefs.setString('user_email', userCredential.user!.email!);
        }

        return userCredential;
      } else {
        // สำหรับ Mobile (Android/iOS) ใช้ FirebaseAuth signInWithProvider (ต้องตั้งค่า SHA-1/256 ใน Firebase Console)
        final googleProvider = GoogleAuthProvider();
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithProvider(googleProvider);

        // บันทึกสถานะ login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_login', true);
        if (userCredential.user?.email != null) {
          await prefs.setString('user_email', userCredential.user!.email!);
        }

        return userCredential;
      }
    } catch (e) {
      throw 'Google sign-in failed: $e';
    }
  }

  // Facebook Sign-In
  static Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // บันทึกสถานะ login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_login', true);
        if (userCredential.user?.email != null) {
          await prefs.setString('user_email', userCredential.user!.email!);
        }

        return userCredential;
      } else {
        throw 'Facebook sign-in failed: ${result.message}';
      }
    } catch (e) {
      throw 'Facebook sign-in failed: $e';
    }
  }

  // จัดการ error message
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'ບໍ່ພົບຜູ້ໃຊ້ນີ້ໃນລະບົບ';
      case 'wrong-password':
        return 'ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ';
      case 'email-already-in-use':
        return 'ອີເມວນີ້ຖືກໃຊ້ງານແລ້ວ';
      case 'weak-password':
        return 'ລະຫັດຜ່ານບໍ່ປອດໄພ ກະລຸນາໃຊ້ລະຫັດຜ່ານທີ່ແຂງແກ່ງກວ່າ';
      case 'invalid-email':
        return 'ຮູບແບບອີເມວບໍ່ຖືກຕ້ອງ';
      case 'user-disabled':
        return 'ບັນຊີຜູ້ໃຊ້ນີ້ຖືກປິດການໃຊ້ງານ';
      case 'too-many-requests':
        return 'ມີການພະຍາຍາມເຂົ້າສູ່ລະບົບຫຼາຍເກີນໄປ ກະລຸນາລໍຖ້າສັກຄູ່';
      case 'network-request-failed':
        return 'ບໍ່ສາມາດເຊື່ອມຕໍ່ອິນເຕີເນັດໄດ້';
      case 'invalid-credential':
        return 'ຂໍ້ມູນການເຂົ້າສູ່ລະບົບບໍ່ຖືກຕ້ອງ';
      case 'operation-not-allowed':
        return 'ການດໍາເນີນງານນີ້ບໍ່ໄດ້ຮັບອະນຸຍາດ';
      default:
        return 'ເກີດຂໍ້ຜິດພາດ: ${e.message}';
    }
  }
}
