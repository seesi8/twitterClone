import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:spark/services/models.dart';

import '../../shared/ProfileImg.dart';
import '../username/username.dart';

class ProfilePic extends StatefulWidget {
  final String name;

  final String phoneOrEmail;

  final DateTime dob;
  final String password;

  const ProfilePic({
    super.key,
    required this.name,
    required this.phoneOrEmail,
    required this.password,
    required this.dob,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: 380,
            child: FloatingActionButton(
              mini: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              onPressed: () {
                goToNext(context);
              },
              backgroundColor: image != null ? Colors.white : Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text("Next"),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              goToNext(context);
            },
            child: Text(
              "Skip for now",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Icon(
            FontAwesomeIcons.boltLightning,
            color: Colors.lightBlue,
          ),
        )),
        leading: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pick a profile picture",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Have a favorite selfie? Upload it now",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0, top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () async {
                        await chooseProfileImage();
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(300.0)),
                              child: image == null
                                  ? Image.network(
                                      fit: BoxFit.fill,
                                      defaultImageURL,
                                      width: 120,
                                      height: 120,
                                    )
                                  : Image.file(image!),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await chooseProfileImage();
                            },
                            color: Colors.black,
                            icon: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Icon(
                                    size: 15,
                                    FontAwesomeIcons.plus,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToNext(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsernameCreate(
          dob: widget.dob,
          name: widget.name,
          phoneOrEmail: widget.phoneOrEmail,
          password: widget.password,
          profileIMG: image,
        ),
      ),
    );
  }

  Future<void> chooseProfileImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    XFile? _image = await picker.pickImage(source: ImageSource.gallery);
    File fileImage = File(_image!.path);
    setState(() {
      image = fileImage;
    });
  }
}
