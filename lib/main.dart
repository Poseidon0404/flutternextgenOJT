import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:login_v3_nextgen/services/auth_services.dart';
import 'package:login_v3_nextgen/Machines/machines.dart';
import 'package:login_v3_nextgen/login/VerifyEmailScreen.dart';
import 'package:login_v3_nextgen/login/RequestPasswordResetScreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
      apiKey: 'AIzaSyDGnX9e4pDEB5UILMQ_M6p8Ut51PqxnuBk',
      appId: '1:21491793885:android:f4f529e05c6d0f2782c034',
      messagingSenderId: '21491793885',
      projectId: 'wesafe-d0090',
      databaseURL:
      "https://wesafe-d0090-default-rtdb.asia-southeast1.firebasedatabase.app",
    )
        : null,
  );

  // Initialize local notifications
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic usage',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );

  // Ask for notification permission
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Foreground FCM listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Foreground FCM: ${message.notification?.title}");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'New Message',
        body: message.notification?.body ?? '',
      ),
    );
  });

  // FCM message click listener
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📩 FCM message clicked!");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SupplySystem',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const AuthScreen(),
    );
  }
}

// Loading overlay widget
class LoadingScreen extends StatelessWidget {
  final String message;
  const LoadingScreen({super.key, this.message = 'Please wait...'});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Authentication Screen
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLogin = true;
  String _error = '';
  String appVersion = 'v.4.1.78.6';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      appVersion = prefs.getString('app_version') ?? appVersion;
    });
  }

  Future<void> _submit() async {
    setState(() => _error = '');
    HapticFeedback.selectionClick();

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    if (_isLogin) {
      final loginResult = await _authService.login(username, password);

      if (loginResult == 'emailNotConfirmed') {
        _showEmailNotConfirmedDialog(username);
        return;
      }

      if (loginResult != null && loginResult.isNotEmpty) {
        _showLoadingDialog('Logging in...');

        final fcmToken = await FirebaseMessaging.instance.getToken();
        print("FCM Token: $fcmToken");

        await _authService.saveUserToken(username, fcmToken);

        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'basic_channel',
            title: 'Login Successful',
            body: 'Welcome back, $username! Have a nice day!',
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context).pop();

        final roles = List<String>.from(loginResult['roles'] ?? [])
            .map((r) => r.trim().toLowerCase())
            .toList();

        if (roles.contains('admin')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MachineScreen(username: username)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ManageUsersPage(username: username)),
          );
        }

      } else {
        setState(() => _error =
            _authService.lastError ?? 'Incorrect username or password.');
      }
    } else {
      final ok = await _authService.signup(username, password, email);
      if (ok) {
        setState(() {
          _isLogin = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Check your email.'),
          ),
        );
      } else {
        setState(() => _error = _authService.lastError ??
            'Username or email may already exist.');
      }
    }
  }


  void _showEmailNotConfirmedDialog(String username) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Email Not Confirmed'),
        content: const Text(
          'Your email is not confirmed. Please verify your email before logging in.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyEmailScreen(username: username),
                ),
              );
            },
            child: const Text('Verify Now'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login_background.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF25458E),
                  Color(0x990224ff),
                  Color(0xFF020120),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', height: 80),
                    const SizedBox(height: 15),
                    Text(
                      'SupplySystem',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Intelligent Software',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _buildInputDecoration('Username'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: _buildInputDecoration('Password'),
                    ),
                    const SizedBox(height: 12),
                    if (!_isLogin)
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black),
                        decoration: _buildInputDecoration('Email'),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _submit,
                      child: Text(
                        _isLogin ? 'Login' : 'Sign Up',
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _error = '';
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Don\'t have an account? Sign Up'
                            : 'Already have an account? Login',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    if (_isLogin)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RequestPasswordResetScreen(username: ''),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    if (_error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _error,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      appVersion,
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
