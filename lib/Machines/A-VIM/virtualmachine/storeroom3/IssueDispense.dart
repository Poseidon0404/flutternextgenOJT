import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IssueDispenseScreen extends StatefulWidget {
  final String username;

  const IssueDispenseScreen({Key? key, required this.username}) : super(key: key);

  @override
  _IssueDispenseScreenState createState() => _IssueDispenseScreenState();
}

class _IssueDispenseScreenState extends State<IssueDispenseScreen> {
  late String currentTime;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> products = List.generate(99, (index) {
    final number = (index + 1).toString().padLeft(3, '0');
    return {
      'code': 'ap-01-$number',
      'name': 'Automation_prod-$number',
      'location': 'Prod-Loc-A-A${(index + 1)}2001',
      'qty': '99'
    };
  });

  List<Map<String, String>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    currentTime = _getUsaGmtMinus4DateTime();
    filteredProducts = products;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(Duration(hours: 4));
    return DateFormat('MM/dd/yyyy hh:mm a').format(gmtMinus4);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final code = product['code']!.toLowerCase();
        final name = product['name']!.toLowerCase();
        final location = product['location']!.toLowerCase();
        return code.contains(query) || name.contains(query) || location.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(),
      body: Column(
        children: [
          _IssueDispense(),
          _buildStoreroomBar(),
          _buildTabHeader(),
          Expanded(child: _buildProductList()),
          _buildFooter(),
        ],
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
            // Handle menu actions here
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

  Widget _IssueDispense() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.black,
      child: Row(
        children: [
          Text('ISSUE / DISPENSE', style: TextStyle(fontSize: 16, color: Colors.white , fontWeight: FontWeight.bold)),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildStoreroomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.black87,
      child: Row(
        children: [
          Icon(Icons.grid_view_rounded, color: Colors.white),
          SizedBox(width: 10),
          Text('STOREROOM 003', style: TextStyle(color: Colors.white)),
          Spacer(),
          Container(
            width: 180,
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: Colors.grey),
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration.collapsed(hintText: 'Search...'),
                  ),
                ),
                Icon(Icons.qr_code, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader() {
    return Container(
      height: 50,
      color: Color(0xFF0f6cbf),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text('PRODUCTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('TOTAL ${filteredProducts.length}', style: TextStyle(color: Colors.black)),
          ),
          Container(width: 1, color: Colors.white54),
          Expanded(
            child: Center(
              child: Text('LOCATION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('TOTAL ${filteredProducts.length}', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (_, index) {
          final product = filteredProducts[index];
          return Container(
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade300,
                        child: Text('AP', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['code']!, style: TextStyle(fontSize: 12, color: Colors.black87)),
                            Text(product['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('Product for Mobile', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Capacity', style: TextStyle(fontSize: 12, color: Colors.black)),
                    _buildCapacityBox('999'),
                    SizedBox(height: 8),
                    Text('Overall Qty', style: TextStyle(fontSize: 12)),
                    _buildOverallQtyBox('999'),
                  ],
                ),

                VerticalDivider(width: 20, thickness: 1, color: Colors.grey.shade300),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1113', style: TextStyle(fontSize: 12)),
                        Text(product['location']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Jprod113', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Quantity', style: TextStyle(fontSize: 12)),
                    _buildQtyBox(product['qty']!),
                  ],
                ),
              ],
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
          Text('V.4.1.78.6', style: TextStyle(color: Colors.white, fontSize: 12)),
          Spacer(),
          Text(_getUsaGmtMinus4DateTime(), style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildQtyBox(String qty) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(qty, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildOverallQtyBox(String qty) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(qty, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCapacityBox(String qty) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(qty, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
