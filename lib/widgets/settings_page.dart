import 'package:fluttertoast/fluttertoast.dart';

import '/helpers/user_preferences.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: getBody(context),
    );
  }

  late File _image = new File("assets/images/Investment.jpg");
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String currency = "\$";

  void _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? ximage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    //save the path of the image to simple use preferences
    final image = File(ximage!.path);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = dir.path;
    final fileName = basename(image.path);
    final File newImage = await image.copy('$path/$fileName');
    UserSimplePreferences.saveImage(newImage.path);
    print("$path/$fileName");

    setState(() {
      _image = image;
    });
  }

  void updateInfo() async {
    String username = _nameController.text;
    String email = _emailController.text;
    await UserSimplePreferences.setUserInfo(username, email, currency);

    setState(() {});
    _emailController.clear();
    _nameController.clear();

    Fluttertoast.showToast(
      msg: "Information Successfully Updated",
      backgroundColor: Colors.blue,
      fontSize: 16,
      textColor: Colors.black,
    );
  }

  Widget getBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 25,
        left: 16,
        right: 16,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                        color: Colors.blue,
                      ),
                      child: InkWell(
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onTap: () => _imgFromGallery(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Enter your name",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            DropdownButton(
              hint: Text("Choose your preferred Currency"),
              items: <String>[
                "\$",
                "XAF",
                "Rupees",
                "Yen",
                "Yuan",
              ].map((value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              value: currency,
              onChanged: (newValue) {
                setState(() {
                  currency = newValue as String;
                });
              },
              underline: SizedBox(),
              isExpanded: true,
            ),
            SizedBox(
              height: 35,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                elevation: 2,
              ),
              onPressed: () => updateInfo(),
              child: Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
