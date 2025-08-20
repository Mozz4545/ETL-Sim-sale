import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

// Auth State Model
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

// Auth Provider Class
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _initAuth();
  }

  // ตรวจสอบสถานะ auth เมื่อเริ่มต้น
  Future<void> _initAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final isLoggedIn = await AuthService.isUserLoggedIn();
      final user = AuthService.getCurrentUser();

      state = state.copyWith(
        user: user,
        isLoggedIn: isLoggedIn,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isLoggedIn: false,
      );
    }
  }

  // Login ด้วย Email และ Password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userCredential = await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (userCredential != null) {
        state = state.copyWith(
          user: userCredential.user,
          isLoggedIn: true,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isLoggedIn: false,
      );
      rethrow;
    }
  }

  // Sign Up ด้วย Email และ Password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userCredential = await AuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        state = state.copyWith(
          user: userCredential.user,
          isLoggedIn: true,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isLoggedIn: false,
      );
      rethrow;
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userCredential = await AuthService.signInWithGoogle();

      if (userCredential != null) {
        state = state.copyWith(
          user: userCredential.user,
          isLoggedIn: true,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isLoggedIn: false,
      );
      rethrow;
    }
  }

  // Facebook Sign-In
  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userCredential = await AuthService.signInWithFacebook();

      if (userCredential != null) {
        state = state.copyWith(
          user: userCredential.user,
          isLoggedIn: true,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isLoggedIn: false,
      );
      rethrow;
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await AuthService.resetPassword(email);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await AuthService.signOut();
      state = state.copyWith(
        user: null,
        isLoggedIn: false,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Clear Error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Refresh Auth State
  Future<void> refreshAuthState() async {
    await _initAuth();
  }
}

// Provider Definitions
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenient Providers for specific states
final userProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

// Auth Stream Provider (for real-time auth state changes)
final authStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
