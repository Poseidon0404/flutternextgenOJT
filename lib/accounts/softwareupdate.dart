import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoftwareUpdateScreen extends StatefulWidget {
  final String username;

  const SoftwareUpdateScreen({Key? key, required this.username}) : super(key: key);

  @override
  _SoftwareUpdateScreenState createState() => _SoftwareUpdateScreenState();
}

class _SoftwareUpdateScreenState extends State<SoftwareUpdateScreen> {
  String appVersion = 'v.4.1.78.20'; // new version

  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
    return DateFormat('MM/dd/yy').format(gmtMinus4);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/login_background.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF25458E), // semi-transparent dark
                  Color(0x990224ff),
                  Color(0xFF020120),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Foreground Card
          Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildIcon(),
                  const SizedBox(height: 20),
                  _buildUpdateInfo(),
                  const SizedBox(height: 12),
                  _buildWarning(),
                  const SizedBox(height: 20),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.red[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Icon(Icons.system_update_alt, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Software Update',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return CircleAvatar(
      radius: 35,
      backgroundColor: Color(0xff061c5e),
      child: const Icon(Icons.download_rounded, size: 32, color: Colors.white),
    );
  }

  Widget _buildUpdateInfo() {
    return Column(
      children: [
        const Text(
          "A new version is available for download.",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 20),
        _infoRow(Icons.verified, Colors.green, "Current Version", "V.4.1.78.6"),
        _infoRow(Icons.calendar_today, Colors.purple, "Last Updated", getUsaGmtMinus4DateTime()),
        _infoRow(Icons.system_update, Colors.blue, "Update Version", appVersion),
        _infoRow(Icons.sd_storage, Colors.orange, "Download Size", "500 MB"),
      ],
    );
  }

  Widget _infoRow(IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning() {
    return Row(
      children: const [
        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'This Application will automatically reload after the update.',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting download...')),
              );

              await Future.delayed(const Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading update...')),
              );

              await Future.delayed(const Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New version: [$appVersion] installed.')),
              );

              await prefs.setString('app_version', appVersion);
              await Future.delayed(const Duration(seconds: 10));

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AuthScreen(),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('UPDATE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CLOSE'),
          ),
        ),
      ],
    );
  }
}
