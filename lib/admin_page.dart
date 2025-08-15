import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/Machines/A-VIM/virtualmachine/Homev3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // for isAdmin()

class AdminPage extends StatefulWidget {
  final String username;

  const AdminPage({Key? key, required this.username}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String appVersion = "v.4.1.78.6"; // Example version

  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
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


  void _showUpdate(BuildContext context) {
    final String appVersion = 'v.4.1.78.21'; // new version

    String getUsaGmtMinus4DateTime() {
      final nowUtc = DateTime.now().toUtc();
      final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
      return DateFormat('MM/dd/yy').format(gmtMinus4);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Background Card
              Container(
                width: 360,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
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
                    ),
                    const SizedBox(height: 20),

                    // Icon
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xff061c5e),
                      child: Icon(Icons.download_rounded, size: 32, color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    // Update Info
                    const Text(
                      "A new version is available for download.",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    _infoRow(Icons.verified, Colors.green, "Current Version", "V.4.1.78.6"),
                    _infoRow(Icons.calendar_today, Colors.purple, "Last Updated", getUsaGmtMinus4DateTime()),
                    _infoRow(Icons.system_update, Colors.blue, "Update Version", appVersion),
                    _infoRow(Icons.sd_storage, Colors.orange, "Download Size", "500 MB"),

                    const SizedBox(height: 12),

                    // Warning
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This Application will automatically reload after the update.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Row(
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

                              if (!context.mounted) return;
                              Navigator.of(context).pop(); // Close dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => AuthScreen()),
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
                              Navigator.of(context).pop();
                            },
                            child: const Text('CLOSE'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
              case 'home':
                Navigator.push(context, MaterialPageRoute(builder: (_) => Homev3Screen(username: widget.username)));
                break;
              case 'force_sync':
                _showSyncDialog();
                break;
              case 'initialize_db':
              // Navigate to Initialize DB screen
                break;
              case 'about':
                _showAbout(context);
                break;
              case 'check_update':
                _showUpdate(context);
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
            _buildMenuItem(Icons.home, 'Home', 'home'),
            _buildMenuItem(Icons.sync, 'Force Sync', 'force_sync'),
            _buildMenuItem(Icons.storage, 'Initialize DB', 'initialize_db'),
            _buildMenuItem(Icons.info, 'About', 'about'),
            _buildMenuItem(Icons.system_update_alt, 'Check Update', 'check_update'),
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
          Text(appVersion, style: const TextStyle(color: Colors.white, fontSize: 12)),
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

  Widget _buildBody() {
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

  Widget _buildForegroundContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _buildUser()),
          SizedBox(width: 25),
          Expanded(flex: 9, child: _buildActionGrid()),
        ],
      ),
    );
  }

  Widget _buildUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Admin', style: TextStyle(fontSize: 20, color: Colors.white)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildActionGrid() {
    final List<Map<String, dynamic>> actions = [
      {
        'label': 'TAKE',
        'image': 'assets/logos/take.png',
        'onTap': () => print('Take action')
      },
      {
        'label': 'RETURN',
        'image': 'assets/logos/return.png',
        'onTap': () => print('Return action')
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: action['onTap'],
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      action['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  action['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2F34),
      appBar: _buildHeader(),
      body: Stack(
        children: [
          _buildBody(),
          _buildForegroundContent(),
        ],
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }
}
