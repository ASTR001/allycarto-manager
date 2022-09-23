import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Const/Constants.dart';
import '../Distributer/Home/home_page.dart';
import '../Vendor/Home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _controller_username_login = new TextEditingController();
  TextEditingController _controller_pass_login = new TextEditingController();
  bool isChecked = false;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
      progress: 50.0,
      message: "Loading...",
      progressWidget: Container(
          padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        color: Colors.black45,
        fontSize: 13.0,
        fontFamily: 'SF UI Display Regular',
      ),
      messageTextStyle: TextStyle(
        color: Colors.black45,
        fontSize: 19.0,
        fontFamily: 'SF UI Display Regular',
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('images/primaryBg.png'),
            //       fit: BoxFit.cover,
            //     )),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.jpg',height: 150,width: 150,),
                ),
                Container(
                  child: Text(
                    'Ally Carto',
                    style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
                SizedBox(height: 20,),
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 604,
                      decoration: BoxDecoration(
                        color: layerOneBg,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60.0),
                            bottomRight: Radius.circular(60.0)
                        ),
                      ),
                    ),
                    Container(
                      width: 399,
                      height: 454,
                      decoration: BoxDecoration(
                        color: layerTwoBg,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          bottomRight: Radius.circular(60.0),
                          bottomLeft: Radius.circular(60.0),
                        ),
                      ),
                    ),
                    Container(
                      height: 354,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 59,
                            top: 59,
                            child: Text(
                              'Username',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Positioned(
                              left: 59,
                              top: 89,
                              child: Container(
                                width: 310,
                                child: TextField(
                                  controller: _controller_username_login,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Enter User name',
                                    hintStyle: TextStyle(color: hintText),
                                  ),
                                ),
                              )),
                          Positioned(
                            left: 59,
                            top: 159,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Positioned(
                              left: 59,
                              top: 189,
                              child: Container(
                                width: 310,
                                child: TextField(
                                  controller: _controller_pass_login,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(color: hintText),
                                  ),
                                ),
                              )),
                          // Positioned(
                          //     right: 60,
                          //     top: 296,
                          //     child: Text(
                          //       'Forgot Password',
                          //       style: TextStyle(
                          //           color: forgotPasswordText,
                          //           fontSize: 16,
                          //           fontFamily: 'Poppins-Medium',
                          //           fontWeight: FontWeight.w600),
                          //     )),
                          // Positioned(
                          //     left: 46,
                          //     top: 361,
                          //     child: Checkbox(
                          //       checkColor: Colors.black,
                          //       activeColor: checkbox,
                          //       value: isChecked,
                          //       onChanged: (bool value) {
                          //         isChecked = value;
                          //       },
                          //     )),
                          // const Positioned(
                          //     left: 87,
                          //     top: 375,
                          //     child: Text(
                          //       'Remember Me',
                          //       style: TextStyle(
                          //           color: forgotPasswordText,
                          //           fontSize: 16,
                          //           fontFamily: 'Poppins-Medium',
                          //           fontWeight: FontWeight.w500),
                          //     )),
                          Positioned(
                              top: 285,
                              right: 60,
                              child: InkWell(
                                onTap: () {
                                  if(_controller_username_login.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please enter username! ", toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                                  } else if(_controller_pass_login.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please enter password! ", toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                                  } else {
                                    LoginData();
                                  }
                                },
                                child: Container(
                                  width: 99,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    color: signInButton,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      'Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins-Medium',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future LoginData() async {

    // print("aaaaaaaaaaaaa : "+_controller_username_login.text.toString());
    // print("aaaaaaaaaaaaa : "+_controller_pass_login.text.toString());
    pr.show();
    Uri uri = Uri.parse(API_LOGIN);

    var map = new Map<String, dynamic>();
    map['user_phone'] = _controller_username_login.text.toString();
    map['password'] = _controller_pass_login.text.toString();

    http.Response response = await http.post(uri,
        body: map);

    print("aaaaaaaaaaaaa : "+response.body.toString());

    var jsonData = jsonDecode(response.body);
    String status = jsonData['status'].toString();
    String msg = jsonData['message'];

    if (status == "2") {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('myidd', jsonData['data']['user_id'].toString());
      prefs.setString('mynamee', jsonData['data']['name']);
      prefs.setString('myemail', jsonData['data']['email']);
      prefs.setString('mymobile', jsonData['data']['mobile']);
      prefs.setString('mypincode', jsonData['pincod']);
      prefs.setString('myimage', jsonData['data']['admin_image']);
      pr.hide();
      if(jsonData['data']['role_id'].toString()  == "3") {
        prefs.setBool('vLogSts', true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => VendorHomePage()));
      } else if(jsonData['data']['role_id'].toString()  == "2") {
        prefs.setBool('dLogSts', true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => DistributorHomePage()));
      }

      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
    } else {
      pr.hide();
      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
    }
  }

}
