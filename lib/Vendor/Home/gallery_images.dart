import 'dart:convert';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GalleryImages extends StatefulWidget {
  final String name;
  final String id;
  const GalleryImages({Key key, this.name, this.id}) : super(key: key);

  @override
  State<GalleryImages> createState() => _MyBlogsState();
}

class _MyBlogsState extends State<GalleryImages> {


  List _myList;
  List _myCatList;

  var mypincode, myidd;

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myidd = prefs.getString("myidd") ?? "";
      mypincode = prefs.getString("mypincode");
      if(mypincode != null)
        getListData();
    });
  }


  Future<String> getListData() async {
    try {
      final response = await http.get(Uri.parse(API_VENDOR_EVENT+widget.id));

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: _myList == null ? Center(child: CircularProgressIndicator()) : _myList.length == 0 ? Center(child: Text("No data found!"))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _myList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:(MediaQuery.of(context).size.width / 3) / 105.0,
              crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Card(
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SizedBox(
                              height: MediaQuery.of(context).size.height ,
                              width: 300,
                              child: Image.network(apiImageBaseURL + _myList[index]["image"])),
                        )
                    );
                  },
                  child:Container(
                    height: 140,
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: apiImageBaseURL + _myList[index]["image"],
                      imageBuilder: (context, imageProvider) => Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          image: DecorationImage(image: AssetImage('images/logo.jpg'), fit: BoxFit.cover),
                        ),
                      ),
                    ),
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
