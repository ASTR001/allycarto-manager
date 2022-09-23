import 'dart:convert';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:allycart_manager/Distributer/Vendor/add_vendor.dart';
import 'package:allycart_manager/Vendor/Product/add_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyProducts extends StatefulWidget {
  const MyProducts({Key key}) : super(key: key);

  @override
  State<MyProducts> createState() => _DistDashboardState();
}

class _DistDashboardState extends State<MyProducts> {

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
            API_LIST_PRODUCT + myidd),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    print("aaaaaaaaaaaaaa : "+API_LIST_PRODUCT + myidd);

    if (mounted) {
      setState(() {
        // getTruckData();
        var dataConvertedToJSON = json.decode(response.body)["data"];
        vendorListData = dataConvertedToJSON["data"];
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
          "My Products",
        ),
      ),
      body: Container(
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => AddProduct(idd: myidd,)));
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '      ADD PRODUCTS',
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
        : Container(
      child: Expanded(
        child: GridView.builder(
          itemCount: vendorListData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:(MediaQuery.of(context).size.width / 2) / 95.0,
              crossAxisCount: (orientation == Orientation.portrait) ? 1 : 1),
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
                      Row(
                        children: [
                          Container(
                            height: 160,
                            width: 160,
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl: apiImageBaseURL + vendorListData[index]["product_image"],
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
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  'Idd : ${vendorListData[index]["product_id"]}',
                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 7,),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  '${vendorListData[index]["product_name"]}',
                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 7,),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  'MRP Price : ${vendorListData[index]["producvar"][0]["base_mrp"]}',
                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 7,),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  'Sell Price : ${vendorListData[index]["producvar"][0]["base_price"]}',
                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 7,),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  
}
