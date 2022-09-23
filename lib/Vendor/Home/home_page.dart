import 'package:allycart_manager/Vendor/Home/Gallay_main.dart';
import 'package:allycart_manager/Vendor/Home/coveragers.dart';
import 'package:allycart_manager/Vendor/Home/faq.dart';
import 'package:allycart_manager/Vendor/Home/my_blogs.dart';
import 'package:allycart_manager/Vendor/Home/my_promotion_video.dart';
import 'package:allycart_manager/Vendor/Home/shemes.dart';
import 'package:allycart_manager/Vendor/Home/tickets.dart';
import 'package:allycart_manager/Vendor/Home/vendor_dashboard.dart';
import 'package:allycart_manager/Vendor/Product/my_products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {

  int _selectedIndex;
  var myemail = "";
  var myname = "";

  @override
  void initState() {
    getSharedPref();
    setState(() {
      // _selectedIndex = widget.pageNo;
      _selectedIndex = 0;
    });
    // getSharedPref();
    super.initState();
  }


  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myname = prefs.getString("mynamee") ?? "";
      myemail = prefs.getString("myemail");
    });
  }

  final pages = [
    VendorDashboard(),
    MyProducts(),
    // MyOrders(),
    // VendorProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Dashboard',
                backgroundColor: Colors.red
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shop_outlined),
                label: 'My Products',
                backgroundColor: Colors.red
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                label: 'My Orders',
                backgroundColor: Colors.red
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.red
            ),
          ],
          // type: BottomNavigationBarType.shifting,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.grey[200],
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black54,
          iconSize: 22,
          showUnselectedLabels: true,
          selectedFontSize: 13,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );
  }
}
