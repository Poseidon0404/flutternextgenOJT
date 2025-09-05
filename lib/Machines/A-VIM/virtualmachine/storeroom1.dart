import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/Machines/A-VIM/virtualmachine/Homev3.dart';
import 'package:login_v3_nextgen/Machines/machines.dart';
import 'package:login_v3_nextgen/accounts/dialog.dart';
import 'package:login_v3_nextgen/accounts/softwareupdate.dart';
import 'package:login_v3_nextgen/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryScreen extends StatefulWidget {
  final String username;

  const InventoryScreen({Key? key, required this.username}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isProductTab = true;

  final List<String> allProducts = [
    'Gadget 001', 'Item 002', 'Item 003', 'Tool 004', 'Gadget 005',
    'Widget 006', 'Component 007', 'Device 008', 'Item 009', 'Tool 010',
    'Gadget 011', 'Tool 012', 'Component 013', 'Gadget 014', 'Widget 015',
    'Device 016', 'Tool 017', 'Gadget 018', 'Widget 019', 'Component 020',
    'Tool 021', 'Gadget 022', 'Widget 023', 'Device 024', 'Item 025',
    'Tool 026', 'Gadget 027', 'Component 028', 'Widget 029', 'Device 030',
    'Tool 031', 'Gadget 032', 'Component 033', 'Widget 034', 'Device 035',
    'Tool 036', 'Gadget 037', 'Component 038', 'Item 039', 'Device 040',
    'Tool 041', 'Gadget 042', 'Component 043', 'Widget 044', 'Device 045',
    'Tool 046', 'Gadget 047', 'Component 048', 'Item 049', 'Device 050',
    'Tool 051', 'Gadget 052', 'Component 053', 'Widget 054', 'Device 055',
    'Component 056',
  ];

  final List<String> allLocations = [
    'Warehouse A1', 'Storage A2', 'Unit A3', 'Warehouse A4', 'Unit A5',
    'Facility A6', 'Storage A7', 'Depot A8', 'Facility A9', 'Unit A10',
    'Warehouse A11', 'Depot A12', 'Facility A13', 'Unit A14', 'Storage A15',
    'Warehouse A16', 'Storehouse A17', 'Depot A18', 'Facility A19', 'Storage A20',
    'Warehouse A21', 'Storehouse A22', 'Unit A23', 'Depot A24', 'Facility A25',
    'Storage A26', 'Warehouse B1', 'Storehouse B2', 'Depot B3', 'Facility B4',
    'Unit B5', 'Storage B6', 'Warehouse B7', 'Storehouse B8', 'Depot B9',
    'Facility B10', 'Unit B11', 'Storage B12', 'Warehouse B13', 'Storehouse B14',
    'Depot B15', 'Facility B16', 'Unit B17', 'Storage B18', 'Warehouse B19',
    'Storehouse B20', 'Depot B21', 'Facility B22', 'Unit B23', 'Storage B24',
    'Warehouse B25', 'Storehouse B26', 'Depot B27', 'Facility B28', 'Unit B29',
    'Depot B30',
  ];

  List<String> filteredProducts = [];
  List<String> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
    filteredLocations = allLocations;
    _searchController.addListener(_onSearchChanged);
    _loadVersion();
  }

  String appVersion = 'v.4.1.78.6'; // default version

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

  void _showUpdate(BuildContext context) {
    final String appVersion = 'v.4.1.78.20'; // new version

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

                    // Buttons
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (isProductTab) {
        filteredProducts = allProducts
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      } else {
        filteredLocations = allLocations
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleTab(bool productTab) {
    setState(() {
      isProductTab = productTab;
      _onSearchChanged();
    });
  }

  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabSection(),
            _buildResultsSection(),
            _buildFooter(),
          ],
        ),
      ),
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => MachineScreen(username: widget.username)));
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


  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.black.withOpacity(0.1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              width: 250,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Product / Location',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _onSearchChanged,
              icon: Icon(Icons.search, size: 18),
              label: Text('SEARCH'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
              },
              icon: Icon(Icons.clear, size: 18),
              label: Text('CLEAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[250],
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      height: 50,
      color: Colors.white70,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 16),
            Text(
              'STORE ROOM 001-1001',
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _toggleTab(true),
              icon: Icon(Icons.grid_view, size: 18),
              label: Text('PRODUCTS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isProductTab ? Colors.blue[700] : Colors.grey[200],
                foregroundColor: isProductTab ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => _toggleTab(false),
              icon: Icon(Icons.storage, size: 18),
              label: Text('LOCATIONS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: !isProductTab ? Colors.blue[700] : Colors.grey[200],
                foregroundColor: !isProductTab ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final data = isProductTab ? filteredProducts : filteredLocations;

    if (data.isEmpty) {
      return Expanded(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'NO RESULTS FOUND',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(isProductTab ? Icons.inventory : Icons.place),
              title: Text(data[index]),
              subtitle: Text(isProductTab ? 'Product Details' : 'Location Info'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Tap logic here
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFa50000), Color(0xFFc40000)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Image.asset('assets/images/logobot.png', height: 20),
          SizedBox(width: 10),
          Text( appVersion, style: TextStyle(color: Colors.white, fontSize: 12)),
          Spacer(),
          Text(getUsaGmtMinus4DateTime(), style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
