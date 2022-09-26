import 'package:flutter/material.dart';

class MyCustomers extends StatefulWidget {
  const MyCustomers({Key key}) : super(key: key);

  @override
  State<MyCustomers> createState() => _DistDashboardState();
}

class _DistDashboardState extends State<MyCustomers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Customers",
        ),
      ),
    );
  }
}
