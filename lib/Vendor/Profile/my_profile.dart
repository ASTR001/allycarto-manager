import 'dart:convert';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:allycart_manager/Distributer/Vendor/add_vendor.dart';
import 'package:allycart_manager/Vendor/Orders/order_details.dart';
import 'package:allycart_manager/Vendor/Product/add_product.dart';
import 'package:allycart_manager/Vendor/Profile/arx_wallet.dart';
import 'package:allycart_manager/Vendor/Profile/bank_details.dart';
import 'package:allycart_manager/Vendor/Profile/kyc_screen.dart';
import 'package:allycart_manager/Vendor/Profile/profile_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class MyVendorProfile extends StatefulWidget {
  const MyVendorProfile({Key key}) : super(key: key);

  @override
  State<MyVendorProfile> createState() => _DistDashboardState();
}

class _DistDashboardState extends State<MyVendorProfile> {

  var vendorListData;
  var myidd, mynamee, myemail, mymobile, myimage;
  bool _isDataLoaded = false;

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myidd = prefs.getString("myidd");
      mynamee = prefs.getString("mynamee");
      myemail = prefs.getString("myemail");
      mymobile = prefs.getString("mymobile");
      myimage = prefs.getString("myimage");
    });
    getData();
  }

  Future<String> getData() async {

    var map = new Map<String, dynamic>();
    map['user_id'] = myidd;

    var response = await http.post(
      Uri.parse(
          API_GET_PROFILE),
      body: map,
    );

    print("aaaaaaaaaaaaaaaabbbbbbb : "+response.body.toString());

    if (mounted) {
      setState(() {
        // getTruckData();
        var dataConvertedToJSON = json.decode(response.body);
        vendorListData = dataConvertedToJSON["data"];

        mynamee = vendorListData["name"];
        myemail = vendorListData["email"];
        mymobile = vendorListData["lmobile"];
        myimage = vendorListData["admin_image"];

        _isDataLoaded = true;
      });
    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Profile",
        ),
      ),
      body: Column(
        children: [
          _isDataLoaded
              ? Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(45),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFe03337), Color(0xFFb73537)],
              ),
            ),
            alignment: Alignment.topCenter,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 240,
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/myprofile.png'),
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: myimage != null
                            ? CachedNetworkImage(
                          imageUrl: apiImageBaseURL + myimage,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 106,
                            width: 106,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: new BorderRadius.all(
                                new Radius.circular(106),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                            : CircleAvatar(
                          radius: 53,
                          child: Icon(
                            Icons.person,
                            size: 53,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  child: Text(
                    mynamee,
                    style: Theme.of(context).primaryTextTheme.headline6.copyWith(color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  child: Text(
                    "${mymobile} | ${myemail}",
                    style: TextStyle(color: Colors.white, fontSize: 16)
                  ),
                ),
                Positioned(
                  bottom: -20,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(namee: vendorListData["name"] ?? "",maill: vendorListData["email"] ?? "",
                          mobb: vendorListData["lmobile"] ?? "", imgg: vendorListData["admin_image"] ?? "",shopp: vendorListData["uers"]["shop_name"] ?? "",),
                        ),
                      ).then((value) => getSharedPref());
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Image.asset('images/edit.png'),
                    ),
                  ),
                ),
              ],
            ),
          )
              : Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              children: [
                SizedBox(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  child: Card(),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isDataLoaded
                    ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      ListTile(
                        onTap: () {
                          if(vendorListData["uers"]["is_approved"] == null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KYCEditScreen(),
                              ),
                            ).then((value) => getSharedPref());
                          } else if(vendorListData["uers"]["is_approved"] == "0"){
                            Fluttertoast.showToast(
                                msg: "KYC is Under Veryfying!", toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "KYC is Verified!", toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                          }
                        },
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        minLeadingWidth: 30,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(
                          Icons.file_download,
                          color: Colors.red.withOpacity(0.7),
                          size: 24,
                        ),
                        title: Text(
                          "Update KYC",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BankDetailsScreen(myidd: myidd, bankk: vendorListData["uers"]["bankname"] ?? "",
                                accc: vendorListData["uers"]["account_number"] ?? "",ifscc: vendorListData["uers"]["ifsc"] ?? "",
                                namee: vendorListData["uers"]["accountholder_name"] ?? "",),
                            ),
                          ).then((value) => getSharedPref());
                        },
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        minLeadingWidth: 30,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(
                          Icons.food_bank_outlined,
                          color: Colors.red.withOpacity(0.7),
                          size: 24,
                        ),
                        title: Text(
                          "Manage Bank Details",
                          style:TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ARXWalletScreen(),
                            ),
                          ).then((value) => getSharedPref());
                        },
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        minLeadingWidth: 30,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(
                          Icons.wallet,
                          color: Colors.red.withOpacity(0.7),
                          size: 24,
                        ),
                        title: Text(
                          "ARX Token Wallet",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20,),
                      // ListTile(
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => IncentiveWalletScreen(a: widget.analytics, o: widget.observer),
                      //       ),
                      //     );
                      //   },
                      //   visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      //   minLeadingWidth: 30,
                      //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      //   leading: Icon(
                      //     MdiIcons.walletOutline,
                      //     color: Theme.of(context).primaryIconTheme.color.withOpacity(0.7),
                      //     size: 20,
                      //   ),
                      //   title: Text(
                      //     "Incentive Wallet",
                      //     style: Theme.of(context).primaryTextTheme.bodyText1,
                      //   ),
                      // ),
                      Divider(),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                )
                    : _similarProductShimmer(),
              ))
        ],
      ),
    );
  }

  Widget _similarProductShimmer() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - profileScreen.dart - _similarProductShimmer():" + e.toString());
      return SizedBox();
    }
  }

}
