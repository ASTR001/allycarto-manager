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

class AddProduct extends StatefulWidget {
  final String idd;
  const AddProduct({Key key, this.idd}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddVendorState();
}

class _AddVendorState extends State<AddProduct> {

  TextEditingController _productName = TextEditingController();
  TextEditingController _productQnty = TextEditingController();
  TextEditingController _productUnit = TextEditingController();
  TextEditingController _purchasePrice = TextEditingController();
  TextEditingController _mrpPrice = TextEditingController();
  TextEditingController _sellPrice = TextEditingController();
  TextEditingController _tags = TextEditingController();
  TextEditingController _desc = TextEditingController();

  ProgressDialog pr;
  var _verticalId, _catId, _subcatId;
  var _pincode, _shoptype, _star;

  File _imageFileLogo;
  File _imageFileKyc;
  final picker = ImagePicker();
  String ImggLogo = "";
  String multiImagess = "";

  FilePickerResult result;

  final _multiSelectKeyVertical = GlobalKey<FormFieldState>();
  final _multiSelectKeyCategory = GlobalKey<FormFieldState>();
  final _multiSelectKeySubCategory = GlobalKey<FormFieldState>();

  List myVertical, myCat, mySubCat;

  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles;
  List<File> ImagesItems = [];


  @override
  void initState() {;
    super.initState();
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
        // ImggKyc = base64Encode(bytes);
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
          // ImggKyc = base64Encode(bytes);
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
    Uri uri = Uri.parse(API_ADD_PRODUCT);

    var map = new Map<String, dynamic>();
    map['user_id'] = widget.idd;
    map['vertical_id'] = _verticalId.toString();
    map['cat_id'] = _catId.toString();
    map['subcat_id'] = _subcatId.toString();
    map['product_name'] = _productName.text.toString();
    map['quantity'] = _productQnty.text.toString();
    map['unit'] = _productUnit.text.toString();
    map['part_no'] = "123";
    map['purchase_price'] = _purchasePrice.text.toString();
    map['mrp'] = _mrpPrice.text.toString();
    map['price'] = _sellPrice.text.toString();
    map['description'] = _desc.text.toString();
    map['ean'] = "123";
    map['type'] = "regular";
    map['tags'] = _tags.text.toString();
    // map['images'] = imagefiles.toString();
    map['images'] = ImagesItems.toString();
    map['product_image'] = _imageFileLogo.toString();

    http.Response response = await http.post(uri,
        body: map);

    print("aaaaaaaaaaaaaaaaaaaa : "+API_ADD_PRODUCT.toString());
    print("aaaaaaaaaaaaaaaaaaaa : "+map.toString());
    print("aaaaaaaaaaaaaaaaaaaa : "+response.body.toString());

    var jsonData = jsonDecode(response.body)["reg"];

    String status = jsonData['sts'].toString();
    String msg = jsonData['msg'];

    if (status == "1") {
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
          "Add Product",
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
                child: DropdownSearch<PincodeModel>(
                  mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                  hint: "Select Vertical",
                  onFind: (String filter) async {
                    var response = await http.get(
                      Uri.parse(API_VERTICAL_LIST),
                    );
                    var dataConvertedToJSON = json.decode(response.body);
                    var models = PincodeModel.fromJsonList(
                        dataConvertedToJSON);
                    return models;
                  },
                  onChanged: (PincodeModel data) {
                    setState(() {
                      _verticalId = data.id;
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
                        'Select Vertical',
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
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: DropdownSearch<PincodeModel>(
                  mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                  hint: "Select Category",
                  onFind: (String filter) async {
                    Map data = {
                      'vid': _verticalId,
                    };
                    http.Response response = await http.post(Uri.parse(API_CATEGORY_LIST),
                        headers: {
                          'content-type': 'application/json' // don't forget this one
                        },
                        body: json.encode(data));
                    var dataConvertedToJSON = json.decode(response.body)["data"];
                    var models = PincodeModel.fromJsonList(
                        dataConvertedToJSON);
                    return models;
                  },
                  onChanged: (PincodeModel data) {
                    setState(() {
                      _catId = data.id;
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
                        'Select Category',
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
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: DropdownSearch<PincodeModel>(
                  mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                  hint: "Select Child Category",
                  onFind: (String filter) async {
                    var map = new Map<String, dynamic>();
                    map['vid'] = _catId.toString();

                    http.Response response = await http.post(Uri.parse(API_CATEGORY_LIST),
                        body: map);
                    var dataConvertedToJSON = json.decode(response.body)["data"];
                    var models = PincodeModel.fromJsonList(
                        dataConvertedToJSON);
                    return models;
                  },
                  onChanged: (PincodeModel data) {
                    setState(() {
                      _subcatId = data.id;
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
                        'Select Child Category',
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
              SizedBox(
                height: 10,
              ),

              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _productName,
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
                      hintText: 'Product Name',
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
                    controller: _productQnty,
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
                      hintText: 'Quantity',
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
                    controller: _productUnit,
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
                      hintText: 'Unit (G/KG/Ltrs/Ml)',
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
                    controller: _purchasePrice,
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
                      hintText: 'Purchase Price',
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
                    controller: _mrpPrice,
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
                      hintText: 'MRP Price',
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
                    controller: _sellPrice,
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
                      hintText: 'Sell Price',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Product Image :",style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0,right: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        _onAlertPress(context,'image1');
                        // _imageFilePermit = await getGalleryImage("3");
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width / 4.7,
                        width: MediaQuery.of(context).size.width / 4.7,
                        color: Colors.grey[200],
                        child: _imageFileLogo != null
                            ? Image.file(_imageFileLogo)
                            : Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              "images/camicon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: _tags,
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
                      hintText: 'Tags',
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
                  // height: 5,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    maxLines: 8,
                    controller: _desc,
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
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Product Images :",style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    try {
                      var pickedfiles = await imgpicker.pickMultiImage();
                      //you can use ImageCourse.camera for Camera capture
                      if(pickedfiles != null){
                        imagefiles = pickedfiles;
                        setState(() {
                          imagefiles.map((imageone){

                            setState(() {
                              ImagesItems.add(File(imageone.path));
                            });

                            // final bytes = File(imageone.path).readAsBytesSync();
                            // multiImagess = base64Encode(bytes);
                          }).toList();
                        });
                      }else{
                        print("No image is selected.");
                      }
                    }catch (e) {
                      print("error while picking file.");
                    }
                  },
                  child: const Text("Select Images"),
                ),),

              Divider(),
              Text("Picked Files:"),
              Divider(),

              imagefiles != null ? Wrap(
                children: imagefiles.map((imageone){
                  return Container(
                      child:Card(
                        child: Container(
                          height: 100, width:100,
                          child: Image.file(File(imageone.path)),
                        ),
                      )
                  );
                }).toList(),
              ):Container(),

              // Padding(
              //   padding: const EdgeInsets.only(left: 22.0,right: 16),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () async {
              //           _onAlertPress(context,'image2');
              //           // _imageFilePermit = await getGalleryImage("3");
              //         },
              //         child: Container(
              //           height: MediaQuery.of(context).size.width / 4.7,
              //           width: MediaQuery.of(context).size.width / 4.7,
              //           color: Colors.grey[200],
              //           child: _imageFileKyc != null
              //               ? Image.file(_imageFileKyc)
              //               : Center(
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               child: Image.asset(
              //                 "images/camicon.png",
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                child: FlatButton(
                  child: Text('SUBMIT'),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    if(_verticalId == "") {
                      Fluttertoast.showToast(
                          msg: "Please select vertical" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    } else if(_catId == "") {
                      Fluttertoast.showToast(
                          msg: "Please select category" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    } else if(_subcatId == "") {
                      Fluttertoast.showToast(
                          msg: "Please select child category" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    } else if(_productName.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter product name" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_productQnty.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter quantity" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_productUnit.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enterunit" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_purchasePrice.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter purchase price" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_mrpPrice.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter mrp price" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_sellPrice.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter sell price" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_imageFileLogo == "") {
                      Fluttertoast.showToast(
                          msg: "Please choose product image" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_tags.text == null) {
                      Fluttertoast.showToast(
                          msg: "Please enter tag" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
                    else if(_desc == null) {
                      Fluttertoast.showToast(
                          msg: "Please enter description" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                    }
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

