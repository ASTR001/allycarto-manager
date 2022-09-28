import 'package:allycart_manager/Distributer/Customers/my_customers.dart';
import 'package:allycart_manager/Distributer/Home/dashboard.dart';
import 'package:allycart_manager/Distributer/Profile/Profile.dart';
import 'package:allycart_manager/Distributer/Vendor/my_vendors.dart';
import 'package:flutter/material.dart';

class DistributorHomePage extends StatefulWidget {
  const DistributorHomePage({Key key}) : super(key: key);

  @override
  State<DistributorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<DistributorHomePage> {

  int _selectedIndex;

  @override
  void initState() {
    setState(() {
      // _selectedIndex = widget.pageNo;
      _selectedIndex = 0;
    });
    // getSharedPref();
    super.initState();
  }

  final pages = [
    DistDashboard(),
    MyVendors(),
    MyCustomers(),
    ProfilePage(),
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
                backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shop_outlined),
                label: 'My Vendors',
                backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                label: 'My Customers',
                backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
                backgroundColor: Colors.blue
            ),
          ],
          // type: BottomNavigationBarType.shifting,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.grey[200],
          selectedItemColor: Colors.blue,
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
