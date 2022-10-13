import 'dart:convert';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:allycart_manager/Distributer/Vendor/add_vendor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyVendors extends StatefulWidget {
  const MyVendors({Key key}) : super(key: key);

  @override
  State<MyVendors> createState() => _DistDashboardState();
}

class _DistDashboardState extends State<MyVendors> {

  List vendorListData;
  var myidd;

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myidd = prefs.getString("myidd");
    });
    getVendorData();
  }

  Future<String> getVendorData() async {
    var response = await http.get(
        Uri.parse(
            API_GET_VENDORS + myidd),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (mounted) {
      setState(() {
        // getTruckData();
        var dataConvertedToJSON = json.decode(response.body)["data"];
        vendorListData = dataConvertedToJSON;
      });
    }

    print("aaaaaaaaaaabbbbbb : "+vendorListData[9].toString());
    print("aaaaaaaaaaabbbbbb : "+vendorListData[10].toString());

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Vendors",
        ),
      ),
      body: Container(
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => AddVendor(idd: myidd,)));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        textStyle: TextStyle(
                            color: Colors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '      ADD VENDOR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              _truckView(orientation),
            ],
          )),
    );
  }


  Widget _truckView(var orientation) {
    return vendorListData == null
        ? Center(
      child: Container(
          height: 25, width: 25, child: CircularProgressIndicator()),
    )
        : vendorListData.length == 0
        ? Center(
      child: Container(
        child: Text("Data Not Found!"),
      ),
    )
        : Expanded(
      child: GridView.builder(
        itemCount: vendorListData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio:(MediaQuery.of(context).size.width / 3) / 125.0,
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: new Card(
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => ShopViewScreen(image: global.appInfo.imageUrl + vendorListData[index]["vuers"]["admin_image"], shopId : vendorListData[index]["user_id"].toString(), name: vendorListData[index]["shop_name"]),
                  //   ),
                  // );
                },
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: apiImageBaseURL + vendorListData[index]["vuers"]["admin_image"],
                        imageBuilder: (context, imageProvider) => Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: AssetImage('images/logo.jpg'), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        '${vendorListData[index]["shop_name"]}',
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  
}
