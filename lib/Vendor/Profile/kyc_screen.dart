import 'dart:convert';
import 'dart:io';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KYCEditScreen extends StatefulWidget {
  const KYCEditScreen({Key key}) : super(key: key);

  @override
  State<KYCEditScreen> createState() => _KYCEditScreenState();
}

class _KYCEditScreenState extends State<KYCEditScreen> {

  File _imageFilePan;
  File _imageFileTan;
  File _imageFileAdhar;
  File _imageFileGst;
  File _imageFileFsfi;
  File _imageFileDeed;
  File _imageFileLetter;
  File _imageFileBiz;
  final picker = ImagePicker();
  String Imggpan = "";
  String Imggtan = "";
  String Imggadhar = "";
  String Imggagst = "";
  String Imggafsfi = "";
  String Imggadeed = "";
  String Imggaletter = "";
  String Imggabiz = "";
  TextEditingController _panController = TextEditingController();
  TextEditingController _tanController = TextEditingController();
  TextEditingController _adharController = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  TextEditingController _fsfiController = TextEditingController();
  ProgressDialog pr;

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
                    _imageFilePan = await getGalleryImage("1");
                  } else if (positionType == 'image2') {
                    _imageFileTan = await getGalleryImage("2");
                  } else if (positionType == 'image3') {
                    _imageFileAdhar = await getGalleryImage("3");
                  } else if (positionType == 'image4') {
                    _imageFileGst = await getGalleryImage("4");
                  } else if (positionType == 'image5') {
                    _imageFileFsfi = await getGalleryImage("5");
                  } else if (positionType == 'image6') {
                    _imageFileDeed = await getGalleryImage("6");
                  } else if (positionType == 'image7') {
                    _imageFileLetter = await getGalleryImage("7");
                  } else if (positionType == 'image8') {
                    _imageFileBiz = await getGalleryImage("8");
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
                    _imageFilePan= await getTakeImage("1");
                  } else if (positionType == 'image2') {
                    _imageFileTan = await getTakeImage("2");
                  } else if (positionType == 'image3') {
                    _imageFileAdhar = await getTakeImage("3");
                  } else if (positionType == 'image4') {
                    _imageFileGst = await getTakeImage("4");
                  } else if (positionType == 'image5') {
                    _imageFileFsfi = await getTakeImage("5");
                  } else if (positionType == 'image6') {
                    _imageFileDeed = await getTakeImage("6");
                  } else if (positionType == 'image7') {
                    _imageFileLetter = await getTakeImage("7");
                  } else if (positionType == 'image8') {
                    _imageFileBiz = await getTakeImage("8");
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
        Imggpan = base64Encode(bytes);
      } else if(imgPos == "2") {
        Imggtan = base64Encode(bytes);
      } else if(imgPos == "3") {
        Imggadhar = base64Encode(bytes);
      } else if(imgPos == "4") {
        Imggagst = base64Encode(bytes);
      } else if(imgPos == "5") {
        Imggafsfi = base64Encode(bytes);
      } else if(imgPos == "6") {
        Imggadeed = base64Encode(bytes);
      } else if(imgPos == "7") {
        Imggaletter = base64Encode(bytes);
      } else if(imgPos == "8") {
        Imggabiz = base64Encode(bytes);
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
          Imggpan = base64Encode(bytes);
        } else if(imgPos == "2") {
          Imggtan = base64Encode(bytes);
        } else if(imgPos == "3") {
          Imggadhar = base64Encode(bytes);
        } else if(imgPos == "4") {
          Imggagst = base64Encode(bytes);
        } else if(imgPos == "5") {
          Imggafsfi = base64Encode(bytes);
        } else if(imgPos == "6") {
          Imggadeed = base64Encode(bytes);
        } else if(imgPos == "7") {
          Imggaletter = base64Encode(bytes);
        } else if(imgPos == "8") {
          Imggabiz = base64Encode(bytes);
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
        title: Text(
          "KYC Verification",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("Pan Image :", style: TextStyle(fontSize: 17),),
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
                      child: _imageFilePan != null
                          ? Image.file(_imageFilePan)
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

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 0, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _panController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Pan Number',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("Tan Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image2');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileTan != null
                          ? Image.file(_imageFileTan)
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

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 0, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _tanController,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Tan Number',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("Aadhar Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image3');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileAdhar != null
                          ? Image.file(_imageFileAdhar)
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

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 0, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _adharController,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Aadhar Number',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("GST Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image4');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileGst != null
                          ? Image.file(_imageFileGst)
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

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 0, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _gstController,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'GST Number',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("FSFI Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image5');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileFsfi != null
                          ? Image.file(_imageFileFsfi)
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

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: EdgeInsets.only(top: 0, left: 16, right: 16),
              padding: EdgeInsets.only(),
              child: TextFormField(
                controller: _fsfiController,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'FSFI Number',
                  contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("Deed Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image6');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileDeed != null
                          ? Image.file(_imageFileDeed)
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

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("Letter Head Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image7');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileLetter != null
                          ? Image.file(_imageFileLetter)
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

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16, top: 10, bottom: 10),
              child: Text("Biz Card Image :", style: TextStyle(fontSize: 17),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _onAlertPress(context,'image8');
                      // _imageFilePermit = await getGalleryImage("3");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4.7,
                      width: MediaQuery.of(context).size.width / 4.7,
                      color: Colors.grey[200],
                      child: _imageFileBiz != null
                          ? Image.file(_imageFileBiz)
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
                  child: Text('Update KYC',style: TextStyle(color: Colors.white),)),
            ),
          ),
        ],
      ),
    );
  }

  Future _save() async {
    pr.show();
    Uri uri = Uri.parse(API_VENDOR_KYC_EDIT);

    // var map = new Map<String, dynamic>();
    // map['user_id'] = widget.idd;
    // map['vertical_id'] = _verticalId.toString();
    // map['cat_id'] = _catId.toString();
    // map['subcat_id'] = _subcatId.toString();
    // map['product_name'] = _productName.text.toString();
    // map['quantity'] = _productQnty.text.toString();
    // map['unit'] = _productUnit.text.toString();
    // map['part_no'] = "123";
    // map['purchase_price'] = _purchasePrice.text.toString();
    // map['mrp'] = _mrpPrice.text.toString();
    // map['price'] = _sellPrice.text.toString();
    // map['description'] = _desc.text.toString();
    // map['ean'] = "123";
    // map['type'] = "regular";
    // map['tags'] = _tags.text.toString();
    // map['images'] = ImagesItems.toString();
    // map['product_image'] = _imageFileLogo.toString();

    Map<String, dynamic> map = <String, dynamic> {
      'user_id': myidd,
      'kyc_pan': Imggpan.toString(),
      'kyc_tan': Imggtan.toString(),
      'kyc_gst': Imggagst.toString(),
      'kyc_adhar': Imggadhar.toString(),
      'kyc_deed': Imggadeed.toString(),
      'kyc_letter_head': Imggaletter.toString(),
      'kyc_bizcard': Imggabiz.toString(),
      'kyc_fsfi': Imggafsfi.toString(),
      'kyc_pan_number': _panController.text.toString(),
      'kyc_tan_number': _tanController.text.toString(),
      'kyc_gst_number': _gstController.text.toString(),
      'kyc_adhar_number': _adharController.text.toString(),
      'kyc_fsfi_number': _fsfiController.text.toString(),
    };

    http.Response response = await http.post(uri,
      body: map,
    );

    print("aaaaaaaaaaaaaaaaaaaa2 : "+jsonEncode(map).toString());
    print("aaaaaaaaaaaaaaaaaaaa3 : "+response.body.toString());
    print("aaaaaaaaaaaaaaaaaaaa4 : ");

    var jsonData = jsonDecode(response.body);

    String status = jsonData['status'].toString();
    String msg = jsonData['data'];

    if (status == "200") {
      print("aaaaaaaaaaaaaaaaaaaa5 : ");
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

}
