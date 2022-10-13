import 'dart:convert';
import 'dart:io';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:allycart_manager/Distributer/Vendor/category_model.dart';
import 'package:allycart_manager/Distributer/Vendor/pincode_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class AddVendor extends StatefulWidget {
  final String idd;
  const AddVendor({Key key, this.idd}) : super(key: key);

  @override
  State<AddVendor> createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {

  TextEditingController _vendorName = TextEditingController();
  TextEditingController _vendorEmail = TextEditingController();
  TextEditingController _vendorMob = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _referal = TextEditingController();
  TextEditingController _shopName = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _county = TextEditingController();
  TextEditingController _area = TextEditingController();
  TextEditingController _proofNumber = TextEditingController();

  TextEditingController _bankname = TextEditingController();
  TextEditingController _account_number = TextEditingController();
  TextEditingController _accountholder_name = TextEditingController();
  TextEditingController _ifsc = TextEditingController();

  ProgressDialog pr;
  var _pincode, _star, _shoptype;

  File _imageFileLogo;
  File _imageFileKyc;
  final picker = ImagePicker();
  String ImggLogo = "";
  String ImggKyc = "";

  FilePickerResult result;

  final _multiSelectKeyVertical = GlobalKey<FormFieldState>();
  final _multiSelectKeyCategory = GlobalKey<FormFieldState>();
  final _multiSelectKeySubCategory = GlobalKey<FormFieldState>();

  List myVertical, myCat, mySubCat;

  static List<CategoryModel> _myVerticals = [];
  var _verticalItems = _myVerticals
      .map((animal) => MultiSelectItem<CategoryModel>(animal, animal.name))
      .toList();
  List<CategoryModel> _selectedVerticals = [];

  static List<CategoryModel> _myCategory = [];
  var _categoryItems = _myCategory
      .map((animal) => MultiSelectItem<CategoryModel>(animal, animal.name))
      .toList();
  List<CategoryModel> _selectedCategory = [];

  static List<CategoryModel> _mySubCategory = [];
  var _subCategoryItems = _mySubCategory
      .map((animal) => MultiSelectItem<CategoryModel>(animal, animal.name))
      .toList();
  List<CategoryModel> _selectedSubCategory = [];


  @override
  void initState() {
    // _selectedVerticals = _myVerticals;
    getVerticalData();
    super.initState();
  }

  Future<String> getVerticalData() async {
    var response = await http.get(Uri.parse(API_VERTICAL_LIST));

        var dataConvertedToJSON = json.decode(response.body);

        var models = CategoryModel.fromJsonList(
            dataConvertedToJSON);

    setState(() {
      _myVerticals = models;
      _verticalItems = _myVerticals
          .map((animal) => MultiSelectItem<CategoryModel>(animal, animal.name))
          .toList();
    });

        return "";
  }

  Future<String> getCategoryData(String values) async {

    // var map = new Map<String, dynamic>();
    // map['vid'] = values.toString();

    Map data = {
      'vid': values,
    };

    http.Response response = await http.post(Uri.parse(API_CATEGORY_LIST),
        headers: {
          'content-type': 'application/json' // don't forget this one
        },
        body: json.encode(data));

    print("aaaaaaaaaaaaaaaaaaaa : "+data.toString());
    print("aaaaaaaaaaaaaaaaaaaa : "+response.body.toString());

        var dataConvertedToJSON = json.decode(response.body)["data"];
        var models = CategoryModel.fromJsonList(
            dataConvertedToJSON);

    setState(() {
      _myCategory = models;
      _categoryItems = _myCategory
          .map((animal) => MultiSelectItem<CategoryModel>(animal, animal.name))
          .toList();
    });

        return "";
  }


  Future<String> getSubCategoryData(String values) async {

    var map = new Map<String, dynamic>();
    map['vid'] = values.toString();

    http.Response response = await http.post(Uri.parse(API_CATEGORY_LIST),
        body: map);

        var dataConvertedToJSON = json.decode(response.body)["data"];
        var models = CategoryModel.fromJsonList(
            dataConvertedToJSON);

    setState(() {
      _mySubCategory = models;
      _subCategoryItems = _mySubCategory
          .map((animal) => MultiSelectItem<CategoryModel>(animal, animal.name))
          .toList();
    });

        return "";
  }


  void _onAlertPress( BuildContext context, String positionType) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    // Image.asset(
                    //   'assets/IMGG.png',
                    //   width: 50,
                    // ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: () async {
                  if (positionType == 'image1') {
                    _imageFileLogo = await getGalleryImage("1");
                  } else if (positionType == 'image2') {
                    _imageFileKyc = await getGalleryImage("2");
                  }
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    // Image.asset(
                    //   'assets/camicon.png',
                    //   width: 50,
                    // ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: () async {
                  if (positionType == 'image1') {
                    _imageFileLogo= await getTakeImage("1");
                  } else if (positionType == 'image2') {
                    _imageFileKyc = await getTakeImage("2");
                  }
                },
              ),
            ],
          );
        });
  }


  getGalleryImage(String imgPos) async {
    File _image;
    final pickedFile = await picker.getImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 100,
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
    if (_image != null) {
      final bytes = File(pickedFile.path).readAsBytesSync();

      if(imgPos == "1") {
        ImggLogo = base64Encode(bytes);
      } else if(imgPos == "2") {
        ImggKyc = base64Encode(bytes);
      }
      // compressImage(_image, imgPos);
    }
    return _image;
  }

  getTakeImage(String imgPos) async {
    File _image;
    final pickedFile = await picker.getImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 80,
        source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        final bytes = File(pickedFile.path).readAsBytesSync();
        Navigator.pop(context);
        if(imgPos == "1") {
          ImggLogo = base64Encode(bytes);
        } else if(imgPos == "2") {
          ImggKyc = base64Encode(bytes);
        }

      } else {
        print('No image selected.');
      }
    });

    if (_image != null) {
      // compressImage(_image, imgPos);
    }
    return _image;
  }


  Future submitCheck() async {
    pr.show();
    Uri uri = Uri.parse(API_ADD_VENDORS);

    var map = new Map<String, dynamic>();
    map['dis_id'] = widget.idd;
    map['name'] = _vendorName.text.toString();
    map['email'] = _vendorEmail.text.toString();
    map['mobile'] = _vendorMob.text.toString();
    map['password'] = _password.text.toString();
    map['pincode'] = _pincode.toString();
    map['shop_name'] = _shopName.text.toString();

    // map['admin_image'] = _imageFileLogo;
    // map['referral_code'] = _referal.text.toString();
    // map['shop_type'] = _shoptype.text.toString();
    // map['vertical_category'] = myVertical.toString();
    // map['shop_category'] = myCat.toString();
    // map['sub_category'] = mySubCat.toString();
    // map['city'] = _city.text.toString();
    // map['country'] = _county.text.toString();
    // map['gpin_location'] = "";
    // map['star_rating'] = _star.toString();
    // map['shop_area'] = _area.text.toString();
    // map['kyc_pan'] = _imageFileKyc.toString();
    // map['kyc_tan'] = _imageFileKyc.toString();
    // map['kyc_gst'] = _imageFileKyc.toString();
    // map['kyc_adhar'] = _imageFileKyc.toString();
    // map['kyc_deed'] = _imageFileKyc.toString();
    // map['kyc_letter_head'] = _imageFileKyc.toString();
    // map['kyc_bizcard'] = _proofNumber.text.toString();
    // map['kyc_fsfi'] = _proofNumber.text.toString();
    // map['bankname'] = _proofNumber.text.toString();
    // map['account_number'] = _proofNumber.text.toString();
    // map['accountholder_name'] = _proofNumber.text.toString();
    // map['ifsc'] = _proofNumber.text.toString();

    http.Response response = await http.post(uri,
        body: map);

    print("aaaaaaaaaaaaaaaaaaaa : "+map.toString());
    print("aaaaaaaaaaaaaaaaaaaa : "+response.body.toString());

    var jsonData = jsonDecode(response.body);

    String status = jsonData['status'].toString();
    String msg = jsonData['message'];

    if (status == "200") {
      pr.hide();
      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
      Navigator.pop(context);
    } else {
      pr.hide();
      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Vendor",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(2),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _vendorName,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey[400],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          )),
                      hintText: 'Vendor Name',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _vendorMob,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey[400],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          )),
                      hintText: 'Vendor Mobile',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _vendorEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey[400],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          )),
                      hintText: 'Vendor Email',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),

              SizedBox(
                height: 10,
              ),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _shopName,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey[400],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          )),
                      hintText: 'Shop Name',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _password,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey[400],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          )),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),



//               Container(
//                 height: 45,
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: DropdownSearch<PincodeModel>(
//                   mode: Mode.BOTTOM_SHEET,
// //              maxHeight: 300,
//                   hint: "Select Shop Type",
//                   onFind: (String filter) async {
//                     var response = await http.get(
//                       Uri.parse(API_SHOP_TYPE),
//                     );
//                     var dataConvertedToJSON = json.decode(response.body)["data"];
//                     var models = PincodeModel.fromJsonList(
//                         dataConvertedToJSON);
//                     return models;
//                   },
//                   onChanged: (PincodeModel data) {
//                     setState(() {
//                       _shoptype = data.id;
//                     });
//                   },
//                   dropdownSearchDecoration: InputDecoration(
//                     contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(
//                         color: Colors.grey[400],
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[500],
//                         )),
//                     hintStyle: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black38,
//                     ),
//                   ),
//                   showSearchBox: true,
//                   searchBoxDecoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
//                     labelText: "Search here...",
//                   ),
//                   popupTitle: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColorDark,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Select Shop Type',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   popupShape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Text("Shop Image :",style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 22.0,right: 16),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: () async {
//                         _onAlertPress(context,'image1');
//                         // _imageFilePermit = await getGalleryImage("3");
//                       },
//                       child: Container(
//                         height: MediaQuery.of(context).size.width / 4.7,
//                         width: MediaQuery.of(context).size.width / 4.7,
//                         color: Colors.grey[200],
//                         child: _imageFileLogo != null
//                             ? Image.file(_imageFileLogo)
//                             : Center(
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             child: Image.asset(
//                               "images/camicon.png",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 0,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: MultiSelectBottomSheetField<CategoryModel>(
//                   key: _multiSelectKeyVertical,
//                   initialChildSize: 0.7,
//                   maxChildSize: 0.95,
//                   title: Text("Verticals"),
//                   buttonText: Text("Select Verticals", style: TextStyle(color: Colors.black54),),
//                   items: _verticalItems,
//                   searchable: true,
//                   onSelectionChanged: (values) {
//                     // print("aaaaaaaaaaaa2 : "+values.toString());
//                   },
//                   validator: (values) {
//                     // print("aaaaaaaaaaaa0 : "+values.toString());
//                     setState(() {
//                       myVertical = values;
//                     });
//                     if (values == null || values.isEmpty) {
//                       return "Required";
//                     } else {
//                       String catIds = values.join(', ');
//                       getCategoryData(catIds);
//                     }
//                     return null;
//                   },
//                   onConfirm: (values) {
//                     // print("aaaaaaaaaaaa1 : "+_myVerticals.toString());
//                     setState(() {
//                       _selectedVerticals = values;
//                     });
//                     _multiSelectKeyVertical.currentState.validate();
//                   },
//                   chipDisplay: MultiSelectChipDisplay(
//                     onTap: (item) {
//                       setState(() {
//                         _selectedVerticals.remove(item);
//                       });
//                       _multiSelectKeyVertical.currentState.validate();
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: MultiSelectBottomSheetField<CategoryModel>(
//                   key: _multiSelectKeyCategory,
//                   initialChildSize: 0.7,
//                   maxChildSize: 0.95,
//                   title: Text("Categories"),
//                   buttonText: Text("Select Categories", style: TextStyle(color: Colors.black54),),
//                   items: _categoryItems,
//                   searchable: true,
//                   validator: (values) {
//                     if (values == null || values.isEmpty) {
//                       return "Required";
//                     } else {
//                       String catIds = values.join(', ');
//                       setState(() {
//                         myCat = values;
//                       });
//                       getSubCategoryData(catIds);
//                     }
//                     // List<String> names = values.map((e) => e.name).toList();
//                     // if (names.contains("Frog")) {
//                     //   return "Frogs are weird!";
//                     // }
//                     return null;
//                   },
//                   onConfirm: (values) {
//                     setState(() {
//                       _selectedCategory = values;
//                     });
//                     _multiSelectKeyCategory.currentState.validate();
//                   },
//                   chipDisplay: MultiSelectChipDisplay(
//                     onTap: (item) {
//                       setState(() {
//                         _selectedCategory.remove(item);
//                       });
//                       _multiSelectKeyCategory.currentState.validate();
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: MultiSelectBottomSheetField<CategoryModel>(
//                   key: _multiSelectKeySubCategory,
//                   initialChildSize: 0.7,
//                   maxChildSize: 0.95,
//                   title: Text("Sub Categories"),
//                   buttonText: Text("Select Sub Categories", style: TextStyle(color: Colors.black54),),
//                   items: _subCategoryItems,
//                   searchable: true,
//                   validator: (values) {
//                     if (values == null || values.isEmpty) {
//                       return "Required";
//                     } else {
//                       String catIds = values.join(', ');
//                       setState(() {
//                         mySubCat = values;
//                       });
//                     }
//                     // List<String> names = values.map((e) => e.name).toList();
//                     // if (names.contains("Frog")) {
//                     //   return "Frogs are weird!";
//                     // }
//                     return null;
//                   },
//                   onConfirm: (values) {
//                     setState(() {
//                       _selectedSubCategory = values;
//                     });
//                     _multiSelectKeySubCategory.currentState.validate();
//                   },
//                   chipDisplay: MultiSelectChipDisplay(
//                     onTap: (item) {
//                       setState(() {
//                         _selectedSubCategory.remove(item);
//                       });
//                       _multiSelectKeySubCategory.currentState.validate();
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _area,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'Area',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _city,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'City',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _county,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'Country',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),



              Container(
                height: 45,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: DropdownSearch<PincodeModel>(
                  mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                  hint: "Select Pincode",
                  onFind: (String filter) async {
                    var response = await http.get(
                      Uri.parse(API_PINCODE_LIST+widget.idd),
                    );
                    var dataConvertedToJSON = json.decode(response.body)["data"];
                    var models = PincodeModel.fromJsonList(
                        dataConvertedToJSON);
                    return models;
                  },
                  onChanged: (PincodeModel data) {
                    setState(() {
                      _pincode = data.id;
                    });
                  },
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.grey[400],
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey[500],
                        )),
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black38,
                    ),
                  ),
                  showSearchBox: true,
                  searchBoxDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    labelText: "Search here...",
                  ),
                  popupTitle: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Select Pincode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  popupShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
              ),




//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 height: 45,
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: DropdownSearch<PincodeModel>(
//                   mode: Mode.BOTTOM_SHEET,
// //              maxHeight: 300,
//                   hint: "Select Star Rating",
//                   onFind: (String filter) async {
//                     var response = await http.get(
//                       Uri.parse(API_STAR_LIST),
//                     );
//                     var dataConvertedToJSON = json.decode(response.body)["data"];
//                     var models = PincodeModel.fromJsonList(
//                         dataConvertedToJSON);
//                     return models;
//                   },
//                   onChanged: (PincodeModel data) {
//                     setState(() {
//                       _star = data.id;
//                     });
//                   },
//                   dropdownSearchDecoration: InputDecoration(
//                     contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(
//                         color: Colors.grey[400],
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[500],
//                         )),
//                     hintStyle: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black38,
//                     ),
//                   ),
//                   showSearchBox: true,
//                   searchBoxDecoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
//                     labelText: "Search here...",
//                   ),
//                   popupTitle: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColorDark,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Select Star Rating',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   popupShape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Text("KYC : (PAN Card) :",style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//           Center(
//             child: ElevatedButton(
//               onPressed: () async{
//                 result = await FilePicker.platform.pickFiles(allowMultiple: true );
//                 if (result == null) {
//                   print("No file selected");
//                 } else {
//                   setState(() {
//                   });
//                   // final bytes = File(result).readAsBytesSync();
//                   // ImggKyc = base64Encode(bytes);
//                   result?.files.forEach((element) {
//                     print(element.name);
//                   });
//                 }
//               },
//               child: const Text("File Picker"),
//             ),),
//               Padding(
//                 padding: const EdgeInsets.only(left: 22.0,right: 16),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: () async {
//                         _onAlertPress(context,'image2');
//                         // _imageFilePermit = await getGalleryImage("3");
//                       },
//                       child: Container(
//                         height: MediaQuery.of(context).size.width / 4.7,
//                         width: MediaQuery.of(context).size.width / 4.7,
//                         color: Colors.grey[200],
//                         child: _imageFileKyc != null
//                             ? Image.file(_imageFileKyc)
//                             : Center(
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             child: Image.asset(
//                               "images/camicon.png",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _bankname,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'Bank Name',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _account_number,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'Account Number',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _accountholder_name,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'Account Holder Name',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _ifsc,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'IFSC',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                   height: 45,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: _referal,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding:
//                       EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                             color: Colors.grey[500],
//                           )),
//                       hintText: 'Referal Code',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black38,
//                       ),
//                     ),
//                   )),



              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                child: ElevatedButton(
                  child: Text('SUBMIT'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(
                            color: Colors.white)),
                  onPressed: () {
                    if(_vendorName.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter vendor name" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_vendorMob.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter vendor mobile" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_vendorEmail.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter vendor email" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_shopName.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter shop name" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_password.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter password" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    // else if(_shoptype == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please select shop type" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_imageFileLogo == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please choose shop image" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(myVertical == null) {
                    //   Fluttertoast.showToast(
                    //       msg: "Please select vertical" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(myCat == null) {
                    //   Fluttertoast.showToast(
                    //       msg: "Please select category" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(mySubCat == null) {
                    //   Fluttertoast.showToast(
                    //       msg: "Please select sub category" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_area.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter area" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_city.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter city" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_county.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter country" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    else if(_pincode == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter pincode" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    // else if(_star == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter star rating" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_imageFileKyc == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please choose kyc" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_bankname.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter bank name" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_account_number.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter account number" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_accountholder_name.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter account holder name" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_ifsc.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter IFSC" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    // else if(_referal.text == "") {
                    //   Fluttertoast.showToast(
                    //       msg: "Please enter referal" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    // }
                    else {
                      submitCheck();
                    }
                  },
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

