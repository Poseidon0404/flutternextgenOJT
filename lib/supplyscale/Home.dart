import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_v3_nextgen/Machines/A-VIM/virtualmachine/storeroom1.dart';
import 'package:login_v3_nextgen/Machines/A-VIM/virtualmachine/storeroom3.dart';
import 'package:login_v3_nextgen/supplyscale/takescreen.dart';
import 'package:login_v3_nextgen/main.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({Key? key, required this.username}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String getUsaGmtMinus4DateTime() {
    final nowUtc = DateTime.now().toUtc();
    final gmtMinus4 = nowUtc.subtract(Duration(hours: 4));
    return DateFormat('yyyy/MM/dd hh:mm a').format(gmtMinus4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2e2e2e),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBackground(),
          _buildForegroundContent(),
        ],
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFc40000),
      title: Row(
        children: [
          Image.asset('assets/images/logo1.png', fit: BoxFit.fill),
          SizedBox(width: 10),
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
        Image.asset('assets/images/account.png', fit: BoxFit.fill),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.username,
            style: GoogleFonts.notoSans(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Image.asset('assets/images/exit.png', height: 24, width: 24),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
          },
        ),
      ],
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

  Widget _buildForegroundContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _buildStoreroomList()),
          SizedBox(width: 25),
          Expanded(flex: 9, child: _buildActionGrid()),
        ],
      ),
    );
  }

  Widget _buildStoreroomList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Storeroom', style: TextStyle(fontSize: 20, color: Colors.white)),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (index == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Storeroom3Screen(username: widget.username),
                        ),
                      );
                    }
                    else if (index == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryScreen(username: widget.username),
                        ),
                      );
                    } else {
                      print('Storeroom ${index + 1} pressed');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text(
                    'Storeroom ${index + 1}',
                    style: GoogleFonts.notoSans(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid() {
    final List<Map<String, dynamic>> actions = [
      {
        'label': 'TAKE23',
        'icon': Icons.download,
        'onTap': () {
          // Navigate correctly to TakeScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TakeScreen(username: widget.username)),
          );
        },
      },
      {
        'label': 'RETURN',
        'icon': Icons.upload,
        'onTap': () {
          // Example of return action
          print('Return action');
          // You can add a navigation here if needed:
          // Navigator.push(context, MaterialPageRoute(builder: (_) => ReturnScreen()));
        },
      },
      {
        'label': 'INVENTORY',
        'icon': Icons.inventory,
        'onTap': () {
          // Example of inventory action
          print('Inventory action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => InventoryScreen()));
        },
      },
      {
        'label': 'STOCK',
        'icon': Icons.store,
        'onTap': () {
          // Example of stock action
          print('Stock action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => StockScreen()));
        },
      },
      {
        'label': 'ORDER',
        'icon': Icons.shopping_cart,
        'onTap': () {
          // Example of order action
          print('Order action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => OrderScreen()));
        },
      },
      {
        'label': 'RECLAIM',
        'icon': Icons.restore,
        'onTap': () {
          // Example of reclaim action
          print('Reclaim action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => ReclaimScreen()));
        },
      },
      {
        'label': 'LOAD',
        'icon': Icons.cloud_upload,
        'onTap': () {
          // Example of load action
          print('Load action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => LoadScreen()));
        },
      },
      {
        'label': 'UNLOAD',
        'icon': Icons.cloud_download,
        'onTap': () {
          // Example of unload action
          print('Unload action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => UnloadScreen()));
        },
      },
      {
        'label': 'SEARCH',
        'icon': Icons.search,
        'onTap': () {
          // Example of search action
          print('Search action');
          // Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
        },
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
                    child: Icon(
                      action['icon'],
                      size: 32,
                      color: Colors.white,
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
            'V.4.1.78.6',
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
}
