import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../Distributer/Home/home_page.dart';
import '../Login/login_page.dart';
import '../Vendor/Home/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession();
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 3500), () {});

    checkSts();

    return true;
  }

  checkSts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool vendorloginsts = prefs.getBool("vLogSts");
    final bool distributerloginsts = prefs.getBool("dLogSts");

    if (vendorloginsts == false && distributerloginsts == false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    } else if (vendorloginsts == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => VendorHomePage()));
    }
    else if (distributerloginsts == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => DistributorHomePage()));
    }
    else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    width: MediaQuery.of(context).size.width * 1,
                    height: 210,
                    child: Opacity(
                        opacity: 1, child: Image.asset('images/logo.jpg')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
