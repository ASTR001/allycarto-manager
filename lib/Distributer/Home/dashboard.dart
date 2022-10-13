import 'dart:convert';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:allycart_manager/Login/login_page.dart';
import 'package:allycart_manager/Vendor/Home/Gallay_main.dart';
import 'package:allycart_manager/Vendor/Home/coveragers.dart';
import 'package:allycart_manager/Vendor/Home/faq.dart';
import 'package:allycart_manager/Vendor/Home/gallery_images.dart';
import 'package:allycart_manager/Vendor/Home/my_blogs.dart';
import 'package:allycart_manager/Vendor/Home/my_promotion_video.dart';
import 'package:allycart_manager/Vendor/Home/shemes.dart';
import 'package:allycart_manager/Vendor/Home/tickets.dart';
import 'package:allycart_manager/Vendor/Home/vendor_dashboard.dart';
import 'package:allycart_manager/Vendor/Product/my_products.dart';
import 'package:allycart_manager/Vendor/Profile/kyc_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class DistDashboard extends StatefulWidget {
  const DistDashboard({Key key}) : super(key: key);

  @override
  State<DistDashboard> createState() => _DistDashboardState();
}

class _DistDashboardState extends State<DistDashboard> {

  var myemail = "", myidd;
  var myname = "Ally Carto";
  bool _isDataLoaded = false;
  CarouselController _carouselController;
  int _currentIndex = 0;
  List _bannerData;
  List _myCatList;
  List _myList;
  var profileListData;
  List _myVideoList;
  YoutubePlayerController _controller;
  var totOrder = "", totProducts = "", totActiveProducts = "", totInActiveProducts = "";

  @override
  void initState() {
    getSharedPref();
    getBannerData();
    getListData();
    getalbumData();
    getVideoData();
    super.initState();
  }

  // Future<String> getData(String idd) async {
  //
  //   var map = new Map<String, dynamic>();
  //   map['user_id'] = idd;
  //
  //   var response = await http.post(
  //     Uri.parse(
  //         API_GET_PROFILE),
  //     body: map,
  //   );
  //
  //   print("aaaaaaaaaaaaaaaabbbbbbb : "+json.decode(response.body)["data"]["uers"].toString());
  //
  //   if (mounted) {
  //     setState(() {
  //       // getTruckData();
  //       var dataConvertedToJSON = json.decode(response.body);
  //       profileListData = dataConvertedToJSON["data"];
  //     });
  //   }
  //
  //   return "Success";
  // }

  Future<String> getTotalData(String idd) async {

    var map = new Map<String, dynamic>();
    map['user_id'] = idd;

    var response = await http.post(
      Uri.parse(
          API_GET_ALL_TOTALS),
      body: map,
    );

    print("bbbbbbbbbbbbbbbbbbbbbbbbb : "+response.body);

    if (mounted) {
      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        if(dataConvertedToJSON["status"].toString() == "200") {
          totOrder = dataConvertedToJSON["orders"].toString();
          totProducts = dataConvertedToJSON["product"].toString();
          totActiveProducts = dataConvertedToJSON["active product"].toString();
          totInActiveProducts = dataConvertedToJSON["inactive product"].toString();
        } else {
          totOrder = "0";
          totProducts = "0";
          totActiveProducts = "0";
          totInActiveProducts = "0";
        }
      });
    }

    return "Success";
  }

  Future<String> getVideoData() async {
    try {
      final response = await http.get(Uri.parse(API_VENDOR_PROMO));


      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myVideoList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  Future<String> getBannerData() async {
    try {
      final response = await http.get(Uri.parse(API_BANNER),);

      print("aaaaaaaaaaaaa : "+API_BANNER);

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _bannerData = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  Future<String> getListData() async {
    try {
      final response = await http.get(Uri.parse(API_VENDOR_ACHIVER));

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  Future<String> getalbumData() async {
    try {
      final response = await http.get(Uri.parse(API_VENDOR_ALBUM));

      print("Aaaaaaaaaaa : "+API_VENDOR_ALBUM);

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myCatList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }


  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myidd = prefs.getString("myidd") ?? "";
      myname = prefs.getString("mynamee") ?? "";
      myemail = prefs.getString("myemail");
    });
    // getData(myidd);
    getTotalData(myidd);
  }

  logoutSts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('vLogSts', false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Dashboard",
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(myname,style: TextStyle(fontSize: 18, color: Colors.white)),
              accountEmail: Text(myemail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: myname == null ? Text(
                  "A",
                  style: TextStyle(fontSize: 40.0,color: Colors.white),
                ) : Text(
                  myname[0].toString(),
                  style: TextStyle(fontSize: 40.0,color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.home),
                  SizedBox(width: 12,),
                  Text("Dashboard")
                ],
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyBlogs(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.newspaper),
                  SizedBox(width: 12,),
                  Text("My Blogs")
                ],
              ),
            ),

            // SizedBox(height: 15,),
            //
            // InkWell(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => MyGalley(),
            //       ),
            //     );
            //   },
            //   child: Row(
            //     children: [
            //       SizedBox(width: 12,),
            //       Icon(Icons.image),
            //       SizedBox(width: 12,),
            //       Text("Gallery")
            //     ],
            //   ),
            // ),

            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyPromotionVideos(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.play_circle_outline),
                  SizedBox(width: 12,),
                  Text("Promotional Videos")
                ],
              ),
            ),
            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TicketsPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.question_answer),
                  SizedBox(width: 12,),
                  Text("Ticket")
                ],
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Coverages(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.map_outlined),
                  SizedBox(width: 12,),
                  Text("Ally Carto Coverage")
                ],
              ),
            ),
            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Schems(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.next_plan_outlined),
                  SizedBox(width: 12,),
                  Text("Schems & Plans")
                ],
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQ(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.help_outline),
                  SizedBox(width: 12,),
                  Text("Help & Support (FAQs)")
                ],
              ),
            ),
            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                logoutSts();
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.logout),
                  SizedBox(width: 12,),
                  Text("Logout")
                ],
              ),
            ),

            SizedBox(height: 15,),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            _bannerData == null ? _bannerShimmer()
                : _bannerData.length > 0
                ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                child: CarouselSlider(
                    items: _bannerItems(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                        viewportFraction: 1,
                        initialPage: _currentIndex,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, _) {
                          _currentIndex = index;
                          setState(() {});
                        }))) : SizedBox(),
            _bannerData != null && _bannerData.length > 0
                ? DotsIndicator(
              dotsCount: _bannerData.length,
              position: _currentIndex.toDouble(),
              onTap: (i) {
                _currentIndex = i.toInt();
                _carouselController.animateToPage(_currentIndex, duration: Duration(microseconds: 1), curve: Curves.easeInOut);
              },
              decorator: DotsDecorator(
                activeSize: const Size(6, 6),
                size: const Size(6, 6),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
                activeColor: Theme.of(context).primaryColor,
                color: Colors.grey,
              ),
            )
                : SizedBox(),

            // profileListData != null ? SizedBox(height: 10,) : SizedBox.shrink(),
            //
            // profileListData != null ? Container(
            //   padding: EdgeInsets.only(left: 10, right: 10),
            //   width: MediaQuery.of(context).size.width,
            //   child: ElevatedButton(
            //     onPressed: (){
            //       if(profileListData["uers"]["is_approved"] == null) {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => KYCEditScreen(),
            //           ),
            //         ).then((value) => getSharedPref());
            //       }
            //     },
            //
            //     style: ElevatedButton.styleFrom(
            //         primary: profileListData["uers"]["is_approved"] == null ? Colors.red : profileListData["uers"]["is_approved"] == "0" ? Colors.orange : Colors.green,
            //         textStyle: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white)),
            //
            //     child:  Text(profileListData["uers"]["is_approved"] == null ? "Update KYC Documents" : profileListData["uers"]["is_approved"] == "0" ? "Waiting for KYC Verification" : "KYC Verified"),
            //   ),)  : SizedBox.shrink(),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 6.0,right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // InkWell(
                  //   onTap: () async {
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.width / 4.5,
                  //     width: MediaQuery.of(context).size.width / 4.5,
                  //     color: Colors.red[200],
                  //     child: Column(
                  //       children: [
                  //         SizedBox(height: 8,),
                  //         Text(" Total\nOrders",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                  //         SizedBox(height: 8,),
                  //         Text(totOrder, style: TextStyle(fontSize: 20),),
                  //         SizedBox(height: 8,),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () async {
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.5,
                      width: MediaQuery.of(context).size.width / 4.5,
                      color: Colors.blue[200],
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          Text("   Total\nVendors",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(totProducts, style: TextStyle(fontSize: 20),),
                          SizedBox(height: 8,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () async {
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.5,
                      width: MediaQuery.of(context).size.width / 4.5,
                      color: Colors.green[200],
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          Text(" Active\nVendors",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(totActiveProducts, style: TextStyle(fontSize: 20),),
                          SizedBox(height: 8,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () async {
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.5,
                      width: MediaQuery.of(context).size.width / 4.5,
                      color: Colors.orange[200],
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          Text("Inactive\nVendors",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(totInActiveProducts, style: TextStyle(fontSize: 20),),
                          SizedBox(height: 8,),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text("Gallery Event:", style: TextStyle(fontSize: 18),),
                ),
              ],
            ),

            SizedBox(height: 0,),
            _myCatList == null ?
            Center(child: CircularProgressIndicator()) :
            _myCatList.length == 0 ? Center(child: Text("No data found!"))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _myCatList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:(MediaQuery.of(context).size.width / 1) / 105.0,
                    crossAxisCount: 1),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: new Card(
                      color: Colors.red[50],
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GalleryImages(name: _myCatList[index]["name"],id: _myCatList[index]["id"].toString()),
                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_myCatList[index]["name"]}',
                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                maxLines: 2,
                              ),
                              SizedBox(width: 10,),
                              Container(
                                height: 140,
                                width: 140,
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: CachedNetworkImage(
                                  imageUrl: apiImageBaseURL + _myCatList[index]["image"],
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text("Achievers:", style: TextStyle(fontSize: 18),),
                ),
              ],
            ),
            SizedBox(height: 0,),
            _myList == null ? Center(child: Text("")) : _myList.length == 0 ? Center(child: Text("No data found!"))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _myList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:(MediaQuery.of(context).size.width / 3) / 125.0,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: new Card(
                      color: Colors.red[50],
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => BlogViewScreen(title: _myList[index]["title"],image: _myList[index]["blog_image"],desc: _myList[index]["description"],tags: _myList[index]["tags"],),
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
                                imageUrl: apiImageBaseURL + _myList[index]["image"],
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
                                '${_myList[index]["name"]}',
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
            ),
            SizedBox(height: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text("Promotion Videos:", style: TextStyle(fontSize: 18),),
                ),
              ],
            ),

            _myVideoList == null
                ? Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
                : _myVideoList.length == 0
                ? Center(
              child: Container(
                child: Text("Data Not Found!"),
              ),
            )
                : Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _myVideoList.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(8),
                    child: YoutubePlayerControllerProvider(
                      controller:
                      _controller = YoutubePlayerController(
                        initialVideoId: YoutubePlayerController
                            .convertUrlToId(_myVideoList[index]
                        ["video"]), // livestream example
                        params: YoutubePlayerParams(
                          //startAt: Duration(minutes: 1, seconds: 5),
                          showControls: true,
                          showFullscreenButton: true,
                          desktopMode:
                          false, // false for platform design
                          autoPlay: false,
                          enableCaption: false,
                          showVideoAnnotations: false,
                          enableJavaScript: false,
                          privacyEnhanced: false,
                          strictRelatedVideos: true,
                          loop: false,
                          playsInline:
                          false, // iOS only - Auto fullscreen or not
                        ),
                      )..listen((value) {
                        if (value.isReady && !value.hasPlayed) {
                          _controller
                            ..hidePauseOverlay()
                          // Uncomment below to start autoplay on iOS
                          //..play()
                            ..hideTopMenu();
                        }
                      }),
                      child: YoutubePlayerIFrame(
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  )),
            )


          ],
        ),
      ),
    );
  }

  List<Widget> _bannerItems() {
    List<Widget> list = [];
    for (int i = 0; i < _bannerData.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Schems(),
            ),
          );
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => ProductListScreen(
          //       1,
          //       _bannerData[i].title,
          //       "",
          //       subcategoryId: _bannerData[i].catId,
          //       a: widget.analytics,
          //       o: widget.observer,
          //     ),
          //   ),
          // );

        },
        child: CachedNetworkImage(
          imageUrl: apiImageBaseURL + _bannerData[i]["imgname"],
          imageBuilder: (context, imageProvider) => Container(
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
      ));
    }
    return list;
  }

  Widget _bannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Card(),
          ),
        ],
      ),
    );
  }

}
