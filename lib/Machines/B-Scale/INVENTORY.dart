import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_v3_nextgen/Machines/machines.dart';
import 'package:login_v3_nextgen/main.dart';
import 'package:login_v3_nextgen/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BScaleInventoryScreen extends StatefulWidget {
  final String username;

  const BScaleInventoryScreen({Key? key, required this.username})
      : super(key: key);

  @override
  _BScaleInventoryScreenState createState() => _BScaleInventoryScreenState();
}

class _BScaleInventoryScreenState extends State<BScaleInventoryScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String appVersion = 'v.4.1.78.6';

  // Lazy loading config
  final int itemsPerPage = 20;
  int currentPage = 1;
  bool isLoadingMore = false;

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _locations = [
    {"name": "Location_A", "code": "LOC-01", "capacity": 99999, "overallQty": 88888},
    {"name": "Location_B", "code": "LOC-02", "capacity": 99999, "overallQty": 77777},
  ];

  List<Map<String, dynamic>> _visibleProducts = [];
  List<Map<String, dynamic>> _visibleCategories = [];
  List<Map<String, dynamic>> _visibleLocations = [];

  bool _loading = true;
  int _currentTab = 0; // 0 = Products, 1 = Categories, 2 = Locations

  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(const Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
  }

  Future<void> _loadVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getString('app_version');
    setState(() => appVersion = storedVersion ?? appVersion);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadVersion();
    _searchController.addListener(_onSearchChanged);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final categories = await _authService.getCategories();
    final products = await _authService.getProducts();
    setState(() {
      _categories = categories;
      _products = products;
      _resetVisibleData();
      _loading = false;
    });
  }

  void _resetVisibleData() {
    currentPage = 1;
    _visibleProducts = _products.take(itemsPerPage).toList();
    _visibleCategories = _categories.take(itemsPerPage).toList();
    _visibleLocations = _locations.take(itemsPerPage).toList();
  }

  void _loadMoreData() async {
    if (isLoadingMore) return;

    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentTab == 0 && _visibleProducts.length < _products.length) {
      final nextItems = _products.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();
      _visibleProducts.addAll(nextItems);
    } else if (_currentTab == 1 && _visibleCategories.length < _categories.length) {
      final nextItems = _categories.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();
      _visibleCategories.addAll(nextItems);
    } else if (_currentTab == 2 && _visibleLocations.length < _locations.length) {
      final nextItems = _locations.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();
      _visibleLocations.addAll(nextItems);
    }

    currentPage++;
    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentTab == 0) {
            _createProductDialog();
          } else if (_currentTab == 1) {
            _createCategoryDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabs(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildList(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, minimumSize: const Size(80, 40)),
            onPressed: _onSearchChanged,
            child: const Text("SEARCH"),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, minimumSize: const Size(80, 40)),
            onPressed: () {
              _searchController.clear();
              _loadData();
            },
            child: const Text("CLEAR"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          _buildTab("PRODUCTS (${_products.length})", 0),
          const SizedBox(width: 10),
          _buildTab("CATEGORIES (${_categories.length})", 1),
          const SizedBox(width: 10),
          _buildTab("LOCATIONS (${_locations.length})", 2),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int tabIndex) {
    final bool active = _currentTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _currentTab = tabIndex;
          _resetVisibleData();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.blue.shade600 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: active ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    List<Map<String, dynamic>> visibleData;
    if (_currentTab == 0) {
      visibleData = _visibleProducts;
    } else if (_currentTab == 1) {
      visibleData = _visibleCategories;
    } else {
      visibleData = _visibleLocations;
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: visibleData.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= visibleData.length) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = visibleData[index];

        if (_currentTab == 0) {
          return ListTile(
            title: Text(item["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text(item["description"] ?? ""),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editProductDialog(item)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteProduct(item["id"])),
              ],
            ),
          );
        } else if (_currentTab == 1) {
          return ListTile(
            title: Text(item["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editCategoryDialog(item)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCategory(item["id"])),
              ],
            ),
          );
        } else {
          return ListTile(
            title: Text(item["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text(item["code"] ?? ""),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Cap: ${item["capacity"]}", style: const TextStyle(fontSize: 12)),
                Text("Qty: ${item["overallQty"]}", style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _createCategoryDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create Category"),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Name")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await _authService.createCategory("text", name: controller.text);
              Navigator.pop(context);
              _loadData();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editCategoryDialog(Map<String, dynamic> category) async {
    final controller = TextEditingController(text: category["name"]);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await _authService.updateCategory(
                category["id"],
                name: controller.text,
              );
              Navigator.pop(context);
              _loadData();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(int id) async {
    await _authService.deleteCategory(id);
    _loadData();
  }

  Future<void> _createProductDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    int? selectedCategoryId =
    _categories.isNotEmpty ? _categories.first["id"] : null;
    bool status = true;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description")),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                items: _categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat["id"],
                    child: Text(cat["name"]),
                  );
                }).toList(),
                onChanged: (val) => selectedCategoryId = val,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              SwitchListTile(
                value: status,
                onChanged: (val) => status = val,
                title: const Text("Status"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (selectedCategoryId != null) {
                await _authService.createProduct(
                  name: nameController.text,
                  description: descController.text,
                  status: status,
                  categoryId: selectedCategoryId!,
                );
              }
              Navigator.pop(context);
              _loadData();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editProductDialog(Map<String, dynamic> product) async {
    final nameController = TextEditingController(text: product["name"]);
    final descController =
    TextEditingController(text: product["description"]);
    int? selectedCategoryId = product["categoryId"];
    bool status = product["status"] ?? true;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description")),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                items: _categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat["id"],
                    child: Text(cat["name"]),
                  );
                }).toList(),
                onChanged: (val) => selectedCategoryId = val,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              SwitchListTile(
                value: status,
                onChanged: (val) => status = val,
                title: const Text("Status"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (selectedCategoryId != null) {
                await _authService.updateProduct(
                  product["id"],
                  name: nameController.text,
                  description: descController.text,
                  status: status,
                  categoryId: selectedCategoryId!,
                );
              }
              Navigator.pop(context);
              _loadData();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(int id) async {
    await _authService.deleteProduct(id);
    _loadData();
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

  PopupMenuItem<String> _buildMenuItem(
      IconData icon, String text, String value) {
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
          Text(
            appVersion,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Spacer(),
          Text(
            getUsaGmtMinus4DateTime(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (_currentTab == 0) {
        _products = _products.where((prod) {
          final name = prod['name'].toString().toLowerCase();
          final desc = (prod['description'] ?? "").toString().toLowerCase();
          return name.contains(query) || desc.contains(query);
        }).toList();
      } else if (_currentTab == 1) {
        _categories = _categories.where((cat) {
          final name = cat['name'].toString().toLowerCase();
          return name.contains(query);
        }).toList();
      } else {
        _locations = _locations.where((loc) {
          final name = loc['name'].toString().toLowerCase();
          final code = loc['code'].toString().toLowerCase();
          return name.contains(query) || code.contains(query);
        }).toList();
      }
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
}
