import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/main.dart';
import 'package:login_v3_nextgen/services/auth_services.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String username;

  const VerifyEmailScreen({super.key, required this.username});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _authService = AuthService();
  final _codeController = TextEditingController();
  String _error = '';
  bool _success = false;

  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
  }

  void _submit() async {
    final code = _codeController.text.trim();
    final ok = await _authService.verifyEmail(widget.username, code);
    if (ok) {
      setState(() {
        _success = true;
        _error = '';
      });
    } else {
      setState(() {
        _error = _authService.lastError ?? 'Verification failed.';
      });
    }
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: const Color(0xFFc40000),
      title: Row(
        children: [
          Image.asset('assets/images/logo1.png', fit: BoxFit.fill, width: 30, height: 30),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'SUPPLYSYSTEM INTELLIGENT SOFTWARE',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSans(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
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
              colors: [Color(0xFF333351), Color(0x7B333351), Color(0xFF2D2D53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFa50000), Color(0xFFc40000)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset('assets/images/logobot.png', height: 20),
          const SizedBox(width: 10),
          const Text('V.4.1.78.6', style: TextStyle(color: Colors.white, fontSize: 12)),
          const Spacer(),
          Text(
            getUsaGmtMinus4DateTime(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter the verification code sent to your email.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _codeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Verification Code',
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text(
              "Verify",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (_error.isNotEmpty)
            Text(
              _error,
              style: const TextStyle(color: Colors.redAccent),
            ),

          if (_success) ...[
            const Text(
              '✅ Email verified. You can now log in.',
              style: TextStyle(color: Colors.greenAccent),
            ),
            Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                });
                return const SizedBox.shrink();
              },
            ),
          ],
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2F34),
      appBar: _buildHeader(),
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(child: _buildForm()),
          ),
        ],
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }
}
