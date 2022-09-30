import 'package:allycart_manager/Const/Constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BankDetailsScreen extends StatefulWidget {
  final String bankk;
  final String accc;
  final String ifscc;
  final String namee;
  final String myidd;
  const BankDetailsScreen({Key key, this.bankk, this.accc, this.ifscc, this.namee, this.myidd}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {

  var _cName = new TextEditingController();
  var _cBank= new TextEditingController();
  var _cAcc = new TextEditingController();
  var _cIfsc = new TextEditingController();

  var _fName = new FocusNode();
  var _fBank = new FocusNode();
  var _fAcc = new FocusNode();
  var _fIfsc = new FocusNode();

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
      _cName.text = widget.namee;
      _cBank.text = widget.bankk;
      _cAcc.text = widget.accc;
      _cIfsc.text = widget.ifscc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Bank Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 15, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _cBank,
                focusNode: _fBank,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Bank Name',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fAcc);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 15, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _cAcc,
                focusNode: _fAcc,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Account Number',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fIfsc);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 15, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _cIfsc,
                focusNode: _fIfsc,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'IFSC',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_fName);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 15, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _cName,
                focusNode: _fName,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Account Holder Name',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
                // onFieldSubmitted: (val) {
                //   FocusScope.of(context).requestFocus(_fPincode);
                // },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
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
                  onPressed: () {
                    _save();
                  },
                  child: Text('Save Bank Details',style: TextStyle(color: Colors.white),)),
            ),
          ),
        ],
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

  _save() async {
    try {
      if (_cName != null &&
          _cName.text.isNotEmpty &&
          _cAcc.text != null &&
          _cAcc.text.isNotEmpty &&
          _cBank != null &&
          _cBank.text.isNotEmpty &&
          _cIfsc.text != null &&
          _cIfsc.text.isNotEmpty) {

          showOnlyLoaderDialog();
          try {
            Response response;
            var dio = Dio();
            var formData = FormData.fromMap({
              'user_id': widget.myidd,
              'account_holder': _cName.text.toString(),
              'bank_name': _cBank.text.toString(),
              'bank_account': _cAcc.text.toString(),
              'bank_ifsc': _cIfsc.text.toString(),
            });

            response = await dio.post(API_VENDOR_BANK_EDIT,
                data: formData,
                options: Options(
                  headers:{
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                  },
                ));
            print("aaaaaaaaaaaaaaaaaaaaaaaa : "+response.data.toString());
            if (response.statusCode == 200 && response.data['status'].toString() == '200') {
              hideLoader();
              Navigator.pop(context);
              showSnackBar(key: _scaffoldKey, snackBarMessage: "Bank details updated.");
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: "Connection failed!");
            }
          } catch (e) {
            print("Exception - updatebank(): " + e.toString());
          }

      } else if (_cName.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: "Please enter name");
      } else if (_cBank.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: "Please enter bank name");
      } else if (_cAcc.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enter account number');
      } else if (_cIfsc.text.trim().isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enter ifsc');
      }
    } catch (e) {
      print("Excetion - addAddessScreen.dart - _save():" + e.toString());
    }
  }

  void showSnackBar({String snackBarMessage, Key key}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryTextTheme.headline5.color,
      key: key,
      content: Text(
        snackBarMessage,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
  }

}
