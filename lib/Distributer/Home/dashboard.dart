import 'package:flutter/material.dart';

class DistDashboard extends StatefulWidget {
  const DistDashboard({Key key}) : super(key: key);

  @override
  State<DistDashboard> createState() => _DistDashboardState();
}

class _DistDashboardState extends State<DistDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Dashboard",
        ),
      ),
    );
  }
}
