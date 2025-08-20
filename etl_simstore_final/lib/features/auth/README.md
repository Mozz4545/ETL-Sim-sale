# Authentication Provider Documentation

## การติดตั้งและใช้งาน Authentication Provider สำหรับ ETL Simstore

### 1. ไฟล์ที่สร้างขึ้น

- `lib/features/auth/provider/auth_provider.dart` - Main authentication provider
- `lib/features/auth/service/session_manager.dart` - Session management 
- `lib/features/auth/widgets/auth_example_widget.dart` - ตัวอย่างการใช้งาน
- `lib/features/auth/auth.dart` - Index export file

### 2. ความสามารถ

#### Authentication Methods
- ✅ Email/Password Sign In
- ✅ Email/Password Sign Up
- ✅ Google Sign-In (Web + Mobile)
- ✅ Facebook Sign-In
- ✅ Password Reset
- ✅ Sign Out

#### State Management
- ✅ Real-time auth state tracking
- ✅ Loading states
- ✅ Error handling
- ✅ User information management

#### Session Management
- ✅ Remember Me functionality
- ✅ Session validation
- ✅ Auto-login
- ✅ Session refresh

### 3. การใช้งานใน main.dart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization...
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 4. การใช้งานใน Widget

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/provider/auth_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch authentication state
    final user = ref.watch(userProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final isLoading = ref.watch(authLoadingProvider);
    final error = ref.watch(authErrorProvider);
    
    if (isLoading) {
      return CircularProgressIndicator();
    }
    
    if (isAuthenticated) {
      return Text('ຍິນດີຕ້ອນຮັບ: ${user?.email}');
    }
    
    return LoginButton();
  }
}
```

### 5. การ Login

```dart
// Email/Password Login
await ref.read(authProvider.notifier).signInWithEmailAndPassword(
  email: email,
  password: password,
  rememberMe: true,
);

// Google Sign-In
await ref.read(authProvider.notifier).signInWithGoogle();

// Facebook Sign-In
await ref.read(authProvider.notifier).signInWithFacebook();
```

### 6. การ Sign Up

```dart
await ref.read(authProvider.notifier).createUserWithEmailAndPassword(
  email: email,
  password: password,
);
```

### 7. การ Logout

```dart
await ref.read(authProvider.notifier).signOut();
await SessionManager.clearSession();
```

### 8. การจัดการ Error

```dart
final error = ref.watch(authErrorProvider);
if (error != null) {
  // แสดง error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error)),
  );
  
  // Clear error
  ref.read(authProvider.notifier).clearError();
}
```

### 9. Auto-Login Check

```dart
class SplashScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLogin = ref.watch(autoLoginProvider);
    
    return autoLogin.when(
      data: (isLoggedIn) {
        if (isLoggedIn) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => LoginPage(),
    );
  }
}
```

### 10. Session Management

```dart
// บันทึก session
await SessionManager.saveSession(
  email: user.email!,
  rememberMe: true,
  sessionDurationDays: 30,
);

// ตรวจสอบ session
final isValid = await SessionManager.isSessionValid();

// ดึงข้อมูล session
final sessionData = await SessionManager.getSessionData();

// ลบ session
await SessionManager.clearSession();
```

### 11. ตัวอย่างการใช้งานใน Navigation

```dart
class AppRouter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    
    return MaterialApp(
      home: isAuthenticated ? HomePage() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
```

### 12. การอัพเดท UI แบบ Real-time

```dart
class AuthStateListener extends ConsumerWidget {
  final Widget child;
  
  const AuthStateListener({required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth stream for real-time updates
    ref.listen(authStreamProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          // User logged in
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // User logged out
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
    
    return child;
  }
}
```

### 13. การทดสอบ

```dart
// ในไฟล์ test
void main() {
  testWidgets('Auth provider test', (WidgetTester tester) async {
    final container = ProviderContainer();
    
    // Test initial state
    expect(container.read(isAuthenticatedProvider), false);
    
    // Test login
    await container.read(authProvider.notifier).signInWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    );
    
    expect(container.read(isAuthenticatedProvider), true);
  });
}
```

### 14. การ Debug

```dart
// เปิด debug mode
class DebugAuthWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return Column(
      children: [
        Text('User: ${authState.user?.email ?? "None"}'),
        Text('Loading: ${authState.isLoading}'),
        Text('Error: ${authState.error ?? "None"}'),
        Text('Logged In: ${authState.isLoggedIn}'),
      ],
    );
  }
}
```

### 15. Best Practices

1. **Error Handling**: ใช้ try-catch ในการเรียก auth methods
2. **Loading States**: แสดง loading indicator ระหว่างรอ auth operations
3. **Session Management**: ใช้ SessionManager สำหรับ remember me
4. **Real-time Updates**: ใช้ authStreamProvider สำหรับ real-time auth changes
5. **Navigation**: ใช้ auth state เพื่อ navigate ระหว่างหน้า
6. **Security**: ไม่เก็บ sensitive data ใน shared preferences

### 16. Firebase Configuration Requirements

- Firebase project ต้องเปิดใช้ Authentication
- Email/Password provider ต้องเปิดใช้
- Google Sign-In ต้องตั้งค่า OAuth และ SHA keys (Android)
- Facebook Sign-In ต้องตั้งค่า Facebook Developer App

### 17. การ Import ใน Project

```dart
// ใช้ index file สำหรับ import ทั้งหมด
import 'features/auth/auth.dart';

// หรือ import แยก
import 'features/auth/provider/auth_provider.dart';
import 'features/auth/service/session_manager.dart';
```
