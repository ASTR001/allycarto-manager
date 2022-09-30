import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:allycart_manager/Const/Constants.dart';
import 'package:allycart_manager/Vendor/Profile/walletModel.dart';
import 'package:allycart_manager/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ARXWalletScreen extends StatefulWidget {
  const ARXWalletScreen({Key key}) : super(key: key);

  @override
  State<ARXWalletScreen> createState() => _ARXWalletScreenState();
}

class _ARXWalletScreenState extends State<ARXWalletScreen> {

  ScrollController _rechargeHistoryScrollController = ScrollController();
  ScrollController _walletSpentScrollController = ScrollController();
  TextEditingController _cAmount = new TextEditingController();
  int rechargeHistoryPage = 1;
  int walletSpentPage = 1;
  bool _isDataLoaded = false;
  bool _isRechargeHistoryPending = true;
  bool _isSpentHistoryPending = true;
  bool _isRechargeHistoryMoreDataLoaded = false;
  bool _isSpentHistoryMoreDataLoaded = false;
  List _walletRechargeHistoryList = [];
  List _walletSpentHistoryList = [];
  GlobalKey<ScaffoldState> _scaffoldKey;
  var total_incentive = "0";
  var myidd ="";

  APIHelper apiHelper;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.center,
                child: Icon(MdiIcons.arrowLeft),
              ),
            ),
            centerTitle: true,
            title: Text("Incentive Wallet"),
          ),
          body: _isDataLoaded
              ? Column(
            children: [
              SizedBox(height: 12,),
              Text(
                "Incentive ARX",
                style: TextStyle(color: Colors.black87),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.currency_bitcoin_rounded),
                    Image.asset("images/token.png",height: 25,width: 25,),
                    Text(total_incentive, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 16)),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 85,
                    child: AppBar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      backgroundColor: Colors.red[400],
                      bottom: TabBar(
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 3.0,
                            color:  Colors.red
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        labelColor: Colors.white,
                        indicatorWeight: 4,
                        unselectedLabelStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
                        labelStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(
                              icon: Icon(
                                MdiIcons.wallet,
                                size: 18,
                              ),
                              child: Text(
                                'Incentive History',
                                textAlign: TextAlign.center,
                              )),
                          Tab(
                              icon: Icon(
                                MdiIcons.walletPlus,
                                size: 18,
                              ),
                              child: Text(
                                'ARX to INR',
                                textAlign: TextAlign.center,
                              )),
                          Tab(
                              icon: Icon(
                                MdiIcons.currencyInr,
                                size: 18,
                              ),
                              child: Text(
                                'INR History',
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TabBarView(
                    children: [
                      _rechargeHistoryWidget(),
                      _rechargeWallet(),
                      _spentAnalysis(),
                    ],
                  ),
                ),
              ),
            ],
          )
              : _shimmerWidget(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myidd = prefs.getString("myidd") ?? "";
    });
    _init();
  }

  _getWalletRechargeHistory() async {


    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "id": myidd,
      });
      response = await dio.post('${apiBaseURL}/vendor_incentive_list?page=$rechargeHistoryPage',
          data: formData,
          options: Options(
            headers:{
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
          ));

      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbb  : "+response.data.toString());

      if (response.statusCode == 200 && response.data["status"].toString() == '1') {
        _walletRechargeHistoryList = response.data["data"];
      } else {
        _walletRechargeHistoryList = [];
      }
    } catch (e) {
      print("Exception - getWalletRechargeHistory(): " + e.toString());
    }

  }

  _getWalletSpentHistory() async {

    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": myidd,
      });
      response = await dio.post('${apiBaseURL}/vendor_arx_history?page=$walletSpentPage',
          data: formData,
          options: Options(
            headers:{
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
          ));

      if (response.statusCode == 200 && response.data["status"].toString() == "200") {
        _walletSpentHistoryList = response.data["data"];
      } else {
        _walletSpentHistoryList = [];
      }
    } catch (e) {
      print("Exception - getWalletSpentHistory(): " + e.toString());
    }

  }

  _init() async {
    try {
      await getData();
      await _getWalletSpentHistory();
      await _getWalletRechargeHistory();

      _rechargeHistoryScrollController.addListener(() async {
        if (_rechargeHistoryScrollController.position.pixels == _rechargeHistoryScrollController.position.maxScrollExtent && !_isRechargeHistoryMoreDataLoaded) {
          setState(() {
            _isRechargeHistoryMoreDataLoaded = true;
          });
          await _getWalletRechargeHistory();
          setState(() {
            _isRechargeHistoryMoreDataLoaded = false;
          });
        }
      });

      _walletSpentScrollController.addListener(() async {
        if (_walletSpentScrollController.position.pixels == _walletSpentScrollController.position.maxScrollExtent && !_isSpentHistoryMoreDataLoaded) {
          setState(() {
            _isSpentHistoryMoreDataLoaded = true;
          });
          await _getWalletSpentHistory();
          setState(() {
            _isSpentHistoryMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - walletScreen.dart - _init():" + e.toString());
    }
  }

  Future<String> getData() async {
    try {

      final data = {
        "user_id": myidd,
      };
      final headers = {
        'content-type': 'application/json',// 'key=YOUR_SERVER_KEY'
      };
      final response = await http.post(Uri.parse(apiBaseURL+"/vendor_arx_info"),
          body: json.encode(data),
          headers: headers);

      var dataConvertedToJSON = json.decode(response.body);

      if(dataConvertedToJSON["status"] == 1)
      {
        setState(() {
          total_incentive = dataConvertedToJSON['incentive_wallet'].toString() ?? "0";
        });
      }
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  Future<String> sendArx(String arx) async {
    showOnlyLoaderDialog();
    try {;

      final data = {
        "user_id": myidd,
        "token_amount": arx,
      };
      final headers = {
        'content-type': 'application/json',// 'key=YOUR_SERVER_KEY'
      };
      final response = await http.post(Uri.parse(apiBaseURL+"/vendor_send_arx"),
          body: json.encode(data),
          headers: headers);

      var dataConvertedToJSON = json.decode(response.body);

      if(dataConvertedToJSON["status"] == "200")
      {
        hideLoader();
        _getWalletSpentHistory();
      }
      hideLoader();
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  Widget _rechargeHistoryWidget() {
    return _walletRechargeHistoryList.length > 0
        ? SingleChildScrollView(
      controller: _rechargeHistoryScrollController,
      child: Column(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _walletRechargeHistoryList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Color(0xFF373C58),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text(
                                '${_walletRechargeHistoryList[index]["name"]}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            // Icon(
                            //   MdiIcons.checkDecagram,
                            //   size: 20,
                            //   color: _walletRechargeHistoryList[index].rechargeStatus == 'success' ? Colors.greenAccent : Colors.red,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Order Id : ${_walletRechargeHistoryList[index]["Order id"].toString()}',
                              ),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        contentPadding: EdgeInsets.all(0),
                        minLeadingWidth: 0,
                        title: Text(
                          '${_walletRechargeHistoryList[index]["Date"]}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        trailing: Text(
                          " ${_walletRechargeHistoryList[index]["Amount"]}",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }),
          _isRechargeHistoryMoreDataLoaded
              ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2,
            ),
          )
              : SizedBox()
        ],
      ),
    )
        : Center(
      child: Text(
        "Nothing to show",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _rechargeWallet() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _cAmount,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Enter ARX',
                  prefixIcon: Icon(
                    MdiIcons.currencyInr,
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.only(top: 15),
                ),
              ),
            ),
          ),
          // Divider(
          //   color: Colors.grey,
          // ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                stops: [0, .90],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFe03337), Color(0xFFb73537)],
              ),
            ),
            margin: EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: () async {
                  if (int.parse(_cAmount.text.trim()) <= int.parse(total_incentive)) {
                    sendArx(_cAmount.text.trim());
                  }
                  else {
                    Fluttertoast.showToast(
                        msg: "Please enter correct ARX value", toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                  }
                },
                child: Text('Make Payment', style: TextStyle(color: Colors.white, fontSize: 18),)),
          )
        ],
      ),
    );
  }

  Widget _shimmerWidget() {
    try {
      return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Card(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Card(),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ));
    } catch (e) {
      print("Exception - walletScreen.dart - _shimmerWidget():" + e.toString());
      return SizedBox();
    }
  }

  Widget _spentAnalysis() {
    return _walletSpentHistoryList.length > 0
        ? SingleChildScrollView(
      controller: _walletSpentScrollController,
      child: Column(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _walletSpentHistoryList.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Color(0xFF373C58),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            '${_walletSpentHistoryList[index]["updated_at"]}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Column(
                          children: [
                            Text(
                              "${_walletSpentHistoryList[index]["status"]}".toUpperCase(),
                              style: TextStyle(color: Colors.black87),
                            ),
                            Text(
                              "${_walletSpentHistoryList[index]["token_amount"]}",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                  ],
                );
              }),
          _isRechargeHistoryMoreDataLoaded
              ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2,
            ),
          )
              : SizedBox()
        ],
      ),
    )
        : Center(
      child: Text(
        "Nothing to show",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }


  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  void hideLoader() {
    Navigator.pop(context);
  }

}
