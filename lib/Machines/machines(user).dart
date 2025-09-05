import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/main.dart';
import 'package:login_v3_nextgen/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage_users_page.dart';

class MachineScreenusers extends StatefulWidget {
  final String username;

  const MachineScreenusers({Key? key, required this.username}) : super(key: key);

  @override
  _MachineScreenusersState createState() => _MachineScreenusersState();
}

class _MachineScreenusersState extends State<MachineScreenusers> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _users = [];
  String appVersion = 'v.4.1.78.6'; // default version
  String _searchQuery = "";

  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
  }

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getString('app_version');

    setState(() {
      appVersion = storedVersion ?? appVersion;
    });
  }

  void _showSyncDialog() async {
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
            children: const [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Syncing database into devices...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 5));
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database synced successfully!')),
    );
  }

  void _showAbout(BuildContext context) {
    const String databaseVersion = '99.99.99';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gradient Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App Title
                  const Text(
                    'NextGen (Mobile Application)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    '(Official Build) (64-bit)',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // Version Info Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Text(
                              'App Version\n$appVersion',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Text(
                              'Database Version\n$databaseVersion',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SupplyWin Branding
                  const Text(
                    'SupplyWin App',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '© 2021 SupplyPro Inc.\nAll rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  // Links
                  const Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    children: [
                      Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'Terms of Services',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Close Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: const Text('CLOSE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // HEADER
  PreferredSizeWidget _buildHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
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
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          onSelected: (value) async {
            switch (value) {
              case 'about':
                _showAbout(context);
                break;
              case 'settings':
              // Navigate to Settings screen
                break;
              case 'logout':
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
                        children: const [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Saving all data into database...\nLogging out...',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                await Future.delayed(const Duration(seconds: 10));
                if (!context.mounted) return;
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            _buildMenuItem(Icons.info, 'About', 'about'),
            _buildMenuItem(Icons.settings, 'Settings', 'settings'),
            _buildMenuItem(Icons.logout, 'Logout', 'logout'),
          ],
          child: Row(
            children: [
              Image.asset('assets/images/account.png', width: 30, height: 30),
              const SizedBox(width: 5),
              Text(
                widget.username,
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String text, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 10),
          Text(text),
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
          Column(
            children: [
              const SizedBox(height: 40),
              _buildSelectMachineButton(),
              const SizedBox(height: 20),
              _buildSearchBox(),
              const SizedBox(height: 30),
              _buildMachineOptions(),
              const Spacer(),
              const SizedBox(height: 20),
              _buildFooter(),
            ],
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

  Widget _buildSelectMachineButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      width: 750,
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storage, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "SELECT MACHINE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      width: 750,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() => _searchQuery = value.toLowerCase());
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "SEARCH HERE",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMachineOptions() {
    final filteredMachines = _machines.where((machine) {
      return machine["keyword"].toLowerCase().contains(_searchQuery);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < filteredMachines.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMachineImage(
                    imagePath: filteredMachines[i]["image"],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            filteredMachines[i]["screen"](widget.username),
                      ),
                    ),
                  ),
                  if (i + 1 < filteredMachines.length)
                    _buildMachineImage(
                      imagePath: filteredMachines[i + 1]["image"],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              filteredMachines[i + 1]["screen"](widget.username),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildMachineImage({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }


  final List<Map<String, dynamic>> _machines = [
    {
      "keyword": "a-vim, avim",
      "image": "assets/icon/MachineType.png",
      "screen": (String username) => ManageUsersPage(username: username),
    },
    {
      "keyword": "b-scale, bscale",
      "image": "assets/icon/MachineTypeBscale.png",
      "screen": (String username) => ManageUsersPage(username: username),
    },
    {
      "keyword": "d-lock, dlock",
      "image": "assets/icon/MachineTypeDlock.png",
      "screen": (String username) => ManageUsersPage(username: username),
    },
    {
      "keyword": "c-scale, cscale",
      "image": "assets/icon/MachineTypeCscale.png",
      "screen": (String username) => ManageUsersPage(username: username),
    },
  ];

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
          Text(
              appVersion, style: TextStyle(color: Colors.white, fontSize: 12)),
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
}

