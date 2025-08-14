import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/Machines/A-VIM/virtualmachine/Homev3.dart';
import 'package:login_v3_nextgen/accounts/softwareupdate.dart';
import 'package:login_v3_nextgen/main.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TakeScreen(username: 'Admin'),
  ));
}

class TakeScreen extends StatefulWidget {
  final String username;
  const TakeScreen({super.key, required this.username});

  @override
  State<TakeScreen> createState() => _TakeScreenState();
}

class _TakeScreenState extends State<TakeScreen> {
  int step = 0;
  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
  }

  void nextStep() => setState(() => step++);
  void backToStart() => setState(() => step = 0);

  final List<String> fakeScales = [
    'ScaleProfile-BOX-001',
    'ScaleProfile-BOX-002',
    'ScaleProfile-BOX-003',
  ];

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
              const SizedBox(height: 20),
              _buildTabBar(),
              const SizedBox(height: 30),
              Expanded(child: _buildStepContent()),
              _buildButtons(),
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
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          onSelected: (value) async {
            switch (value) {
              case 'home':
                Navigator.push(context, MaterialPageRoute(builder: (_) => Homev3Screen(username: widget.username)));
                break;
              case 'force_sync':
              // Navigate to Force Sync screen
                break;
              case 'initialize_db':
              // Navigate to Initialize DB screen
                break;
              case 'about':
              // Navigate to About screen
                break;
              case 'check_update':
                Navigator.push(context, MaterialPageRoute(builder: (_) => SoftwareUpdateScreen(username: widget.username)));
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

  Widget _buildTabBar() {
    return Container(
      height: 40,
      color: const Color(0xFFEBEBEB),
      child: Row(
        children: [
          Container(
            width: 60,
            color: const Color(0xFFB40000),
            child: Center(
              child: Text('TAKE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.chevron_right, color: Colors.black),
          const SizedBox(width: 4),
          Text('STORE ROOM 001-1001', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case 0:
        return _noScalesDetected();
      case 1:
        return _scaleList();
      case 2:
        return _inputForm();
      case 3:
        return _dialogStep('INITIATE TAKE', 'Please remove products from the scale.', Icons.assignment_turned_in, Colors.blue);
      case 4:
        return _dialogStep('RECALIBRATING', 'Please stand still during the recalibration.', Icons.precision_manufacturing, Colors.orange);
      case 5:
        return _dialogStep('CALIBRATION FAILED', 'Scale reading is not stable.', Icons.cancel, Colors.red);
      case 6:
        return _dialogStep('TAKE COMPLETE', 'Take was successful.', Icons.check_circle, Colors.green);
      default:
        return Center(child: Text('Invalid Step'));
    }
  }

  Widget _noScalesDetected() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.desktop_access_disabled, size: 40, color: Colors.grey),
            SizedBox(height: 10),
            Text('NO SCALES DETECTED', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _scaleList() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Color(0xFFE5E5E5),
            child: Row(
              children: [
                Icon(Icons.lock, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'SCALES',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                Spacer(),
                Text(
                  '${fakeScales.length}', // Dynamic count
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Column(
            children: fakeScales.map((e) {
              return InkWell(
                onTap: () => setState(() => step = 2),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Name + Location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'LOC-A-${fakeScales.indexOf(e) + 1}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      // Right: Quantity
                      Text(
                        '99999',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Widget _inputForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF2B2B2B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Info Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.folder_open, color: Colors.orange, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Prod-Loc-A-A12001',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('PART-NUM-C01',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.image, color: Colors.grey),
                  ],
                ),
                const Divider(),
                Row(
                  children: const [
                    Icon(Icons.storage, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Text('Stock-Loc-A-A12001',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quantities Row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _valueBox('MINIMUM', '99999'),
              _valueBox('MAXIMUM', '99999'),
            ],
          ),

          const SizedBox(height: 12),
          // Quantities Row 2
          _valueBoxWithLabel('Current Quantity', '99999', Icons.inventory),
          const SizedBox(height: 12),
          _valueBoxWithLabel('Physical Max', '99999', Icons.warning_amber_rounded),
          const SizedBox(height: 12),
          _quantityInputBox(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _valueBox(String label, String value) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(Icons.refresh, size: 18),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _valueBoxWithLabel(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3B49),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Text(value,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _quantityInputBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Text('QUANTITY',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          Spacer(),
          Text('99999',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }


  Widget _dialogStep(String title, String subtitle, IconData icon, Color color) {
    Future.delayed(const Duration(seconds: 2), () {
      if (step == 3) setState(() => step = 4);
      else if (step == 4) setState(() => step = 5);
      else if (step == 5) setState(() => step = 6);
    });
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    List<Widget> actions = [];
    switch (step) {
      case 0:
        actions = [
          _actionBtn('DONE', Colors.green, nextStep, icon: Icons.check),
          _actionBtn('CANCEL', Colors.red, backToStart, icon: Icons.cancel),
        ];
        break;
      case 1:
        actions = [_actionBtn('CANCEL', Colors.red, backToStart, icon: Icons.cancel)];
        break;
      case 2:
        actions = [
          _actionBtn('TAKE', Colors.green, nextStep, icon: Icons.download),
          _actionBtn('CANCEL', Colors.red, backToStart, icon: Icons.cancel),
        ];
        break;
      case 5:
        actions = [
          _actionBtn('RETRY', Colors.blue, () => setState(() => step = 3), icon: Icons.refresh),
          _actionBtn('CANCEL', Colors.red, backToStart, icon: Icons.cancel),
        ];
        break;
      case 6:
        actions = [_actionBtn('OK', Colors.green, backToStart, icon: Icons.check_circle)];
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: actions.map((btn) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: btn)).toList(),
      ),
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap, {IconData? icon}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 30,
      color: const Color(0xFFB40000),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Image.asset('assets/images/logobot.png', height: 18),
          const SizedBox(width: 10),
          const Text('V.4.1.78.6', style: TextStyle(color: Colors.white, fontSize: 12)),
          const Spacer(),
          Text(
            getUsaGmtMinus4DateTime(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
