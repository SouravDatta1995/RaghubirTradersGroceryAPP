import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/NavigationPages/AdminHomePage.dart';
import 'package:raghuvir_traders/Services/ProductManagementService.dart';

class AdminUpdateProductWidget extends StatefulWidget {
  final Product product;

  const AdminUpdateProductWidget({Key key, this.product}) : super(key: key);

  @override
  _AdminUpdateProductWidgetState createState() =>
      _AdminUpdateProductWidgetState();
}

class _AdminUpdateProductWidgetState extends State<AdminUpdateProductWidget> {
  File _image;
  final picker = ImagePicker();
  String _productName, _productPrice;
  bool _saveButtonState = false;
  int _categoryVal;
  List<String> _categoryList;
  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    _image = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 256,
      maxWidth: 256,
      compressQuality: 60,
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.blueAccent,
        toolbarColor: Colors.blueAccent,
        activeControlsWidgetColor: Colors.blueAccent,
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    _productName = widget.product.name;
    _productPrice = widget.product.price.toString();
    _categoryList = AppDataBLoC.categoryList.sublist(1);
    _categoryVal = int.parse(widget.product.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: _image == null
                              ? Stack(
                                  children: [
                                    widget.product.logo.startsWith("http")
                                        ? CachedNetworkImage(
                                            imageUrl: widget.product.logo,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.memory(
                                            base64Decode(widget.product.logo),
                                            height: 80,
                                            width: 80,
                                          ),
                                    Icon(
                                      MdiIcons.camera,
                                      color: Colors.black12,
                                    ),
                                  ],
                                )
                              : Image.file(_image),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) => _productName = value,
                          decoration:
                              InputDecoration(labelText: "Enter Product Name"),
                          enabled: false,
                          initialValue: widget.product.name,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    onChanged: (value) => _productPrice = value,
                    decoration: InputDecoration(
                      labelText: "Price",
                      prefix: Text("Rs. "),
                    ),
                    initialValue: widget.product.price.toString(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a Product Name';
                      }
                      return null;
                    },
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        onChanged: (value) {
                          setState(() {
                            _categoryVal = value;
                          });
                        },
                        value: _categoryVal,
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                        isExpanded: true,
                        items: List.generate(
                          _categoryList.length,
                          (index) => DropdownMenuItem(
                            child: Text(_categoryList[index]),
                            value: index + 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          _formKey.currentState.reset();
                        },
                        child: Center(
                          child: Text(
                            "RESET",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate())
                              _saveButtonState = true;
                          });
                        },
                        child: Center(
                          child: _saveButtonState == false
                              ? Text(
                                  "SAVE",
                                  style: TextStyle(color: Colors.white),
                                )
                              : FutureBuilder(
                                  future:
                                      ProductManagementService.updateProduct(
                                    _productName,
                                    _productPrice,
                                    _image != null ? _image.path : "",
                                    _categoryVal.toString(),
                                  ).then((value) {
                                    Navigator.popUntil(context,
                                        ModalRoute.withName(AdminHomePage.id));
                                  }),
                                  builder: (context, snapshot) => Container(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
