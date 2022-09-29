import 'dart:io';

import 'package:allycart_manager/Const/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileEditScreen extends StatefulWidget {
  final String namee;
  final String maill;
  final String mobb;
  final String shopp;
  final String pass;
  final String imgg;
  const ProfileEditScreen({Key key, this.namee, this.maill, this.mobb, this.shopp, this.pass, this.imgg}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {


  var _cName = new TextEditingController();
  var _cPhone = new TextEditingController();
  var _cEmail = new TextEditingController();
  var _cPass = new TextEditingController();
  var _cShop = new TextEditingController();
  var _fName = new FocusNode();
  var _fPass = new FocusNode();
  var _fPhone = new FocusNode();
  var _fEmail = new FocusNode();
  var _fShop = new FocusNode();

  GlobalKey<ScaffoldState> _scaffoldKey;

  bool _isDataLoaded = false;
  File _tImage;

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
      _cName.text = widget.namee;
      _cEmail.text = widget.maill;
      _cPhone.text = widget.mobb;
      _cShop.text = widget.shopp;
      _isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile Edit",
        ),
      ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _isDataLoaded
                ? Container(
              height: 170,
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 170,
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/profile_edit.png'),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: _tImage != null
                              ? CircleAvatar(
                            radius: 53,
                            backgroundImage: FileImage(File(_tImage.path)),
                          )
                              : widget.imgg != null
                              ? CachedNetworkImage(
                            imageUrl: apiImageBaseURL + widget.imgg,
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
                    bottom: 25,
                    child: TextButton(
                      onPressed: () async {
                        await _showCupertinoModalSheet();
                      },
                      child: Text(
                        'Update Image',
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
                    height: 200,
                    width: MediaQuery.of(context).size.width - 16,
                    child: Card(),
                  ),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 16,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isDataLoaded
                  ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: EdgeInsets.only(top: 5, bottom: 15),
                        padding: EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cName,
                          focusNode: _fName,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'name',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),

                      Text(
                        "Shop Name",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: EdgeInsets.only(top: 5, bottom: 15),
                        padding: EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cShop,
                          focusNode: _fShop,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Shop Name',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),

                      Text(
                        "Mobile",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: EdgeInsets.only(top: 5, bottom: 15),
                        padding: EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cPhone,
                          focusNode: _fPhone,
                          readOnly: true,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Mobile',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),

                      Text(
                        "Email",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: EdgeInsets.only(top: 5, bottom: 15),
                        padding: EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cEmail,
                          focusNode: _fEmail,
                          // readOnly: true,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'd.escober@gmail.com',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Password",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: EdgeInsets.only(top: 5, bottom: 15),
                        padding: EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cPass,
                          focusNode: _fPass,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'password',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : _shimmerList(),
            ),
          ],
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
                    onPressed: () async {
                      await _update();
                    },
                    child: Text('Update',style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        )
    );
  }

  _update() async {
    try {
      showOnlyLoaderDialog();
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'name': _cName.text.toString(),
        'email': _cEmail.text.toString(),
        'shop_name': _cShop.text.toString(),
        'password': _cPass.text.toString(),
        'user_image': _tImage != null ? await MultipartFile.fromFile(_tImage.path.toString()) : null,
        'user_id': myidd,
      });

      response = await dio.post(API_VENDOR_PROFILE_EDIT,
          data: formData,
          options: Options(
            headers:{
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
          ));

      print("aaaaaaaaaaaaaaaaaaa : "+response.data.toString());

      if (response.statusCode == 200 && response.data['status'].toString() == '200') {
        hideLoader();
        Navigator.pop(context);
        showSnackBar(key: _scaffoldKey, snackBarMessage: "Profile details updated.");
      } else {
        hideLoader();
        showSnackBar(key: _scaffoldKey, snackBarMessage: "Connection failed!");
      }
    } catch (e) {
      print("Exception - updateProfile(): " + e.toString());
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


  _showCupertinoModalSheet() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text("Actions"),
          actions: [
            CupertinoActionSheetAction(
              child: Text('Take Picture', style: TextStyle(color: Color(0xFF171D2C))),
              onPressed: () async {
                Navigator.pop(context);
                showOnlyLoaderDialog();
                _tImage = await openCamera();
                hideLoader();

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text("Choose from Gallery", style: TextStyle(color: Color(0xFF171D2C))),
              onPressed: () async {
                Navigator.pop(context);
                showOnlyLoaderDialog();
                _tImage = await selectImageFromGallery();
                print("aaaa00 : "+_tImage.toString());
                hideLoader();

                setState(() {});
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel", style: TextStyle(color: Colors.green)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print("Exception - profileEditScreen.dart - _showCupertinoModalSheet():" + e.toString());
    }
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

  Future<File> openCamera() async {
    try {
      PermissionStatus permissionStatus = await Permission.camera.status;
      if (permissionStatus.isLimited || permissionStatus.isDenied) {
        permissionStatus = await Permission.camera.request();
      }
      //File imageFile;
      XFile _selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      File imageFile = File(_selectedImage.path);
      if (imageFile != null) {
        File _finalImage = await _cropImage(imageFile.path);

        _finalImage = await _imageCompress(_finalImage, imageFile.path);

        print("_byteData path ${_finalImage.path}");
        return _finalImage;
      }
    } catch (e) {
      print("Exception - businessRule.dart - openCamera():" + e.toString());
    }
    return null;
  }

  Future<File> selectImageFromGallery() async {
    try {
      PermissionStatus permissionStatus = await Permission.photos.status;
      if (permissionStatus.isLimited || permissionStatus.isDenied) {
        permissionStatus = await Permission.photos.request();
      }
      File imageFile;
      XFile _selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      imageFile = File(_selectedImage.path);
      print("aaaa : "+imageFile.toString());
      if (imageFile != null) {
        File _byteData = await _cropImage(imageFile.path);
        print("aaaa111 : "+imageFile.toString());
        _byteData = await _imageCompress(_byteData, imageFile.path);
        return _byteData;
      }
    } catch (e) {
      print("Exception - businessRule.dart - selectImageFromGallery()" + e.toString());
    }
    return null;
  }

  Future<File> _cropImage(String sourcePath) async {
    try {
      File _croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          backgroundColor: Colors.white,
          toolbarColor: Colors.black,
          dimmedLayerColor: Colors.white,
          toolbarWidgetColor: Colors.white,
          cropGridColor: Colors.white,
          activeControlsWidgetColor: Color(0xFF46A9FC),
          cropFrameColor: Color(0xFF46A9FC),
          lockAspectRatio: true,
        ),
      );
      if (_croppedFile != null) {
        return _croppedFile;
      }
    } catch (e) {
      print("Exception - businessRule.dart - _cropImage():" + e.toString());
    }
    return null;
  }

  Future<File> _imageCompress(File file, String targetPath) async {
    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        minHeight: 500,
        minWidth: 500,
        quality: 60,
      );
      print('file ${file.lengthSync()}');
      print(result.lengthSync());

      return result;
    } catch (e) {
      print("Exception - businessRule.dart - _cropImage():" + e.toString());
      return null;
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - profileEdiScreen.dart - _shimmerList():" + e.toString());
      return SizedBox();
    }
  }

}
