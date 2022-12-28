import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/auth.dart';
import 'package:spark/services/firestore.dart';

import '../../../services/models.dart';
import '../../Settings.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool valid = false;

  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserData report = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        actions: valid
            ? [
                TextButton(
                  onPressed: () async {
                    if (newController.text == confirmController.text) {
                      print("object");
                      // AuthService().updatePassword(
                      //     newController.text, currentController.text);
                      dynamic provider = GoogleAuthProvider();

                      var user = AuthService().user;

                      print((user?.providerData.length ?? 0) <= 1);

                      if ((user?.providerData.length ?? 0) < 1) {
                        print("ohhh");
                        return;
                      } else {
                        if (user?.providerData[0] == "google.com") {
                          provider = GoogleAuthProvider();
                        } else if (user?.providerData[0] == "apple.com") {
                          provider = AppleAuthProvider();
                        }
                      }

                      UserCredential? userCredential =
                          await user?.reauthenticateWithProvider(provider);
                      print('h ${userCredential?.user?.phoneNumber}');
                    }
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
            : [],
        elevation: 0,
        title: Center(
          child: Column(
            children: [
              Text(
                "YourAccont",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@${report.username}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Column(
            children: [
              Container(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    if (currentController.text != "" &&
                                        newController.text != "" &&
                                        confirmController.text != "") {
                                      valid = true;
                                    }
                                  });
                                },
                                controller: currentController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Current Password"),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "New password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    if (currentController.text != "" &&
                                        newController.text != "" &&
                                        confirmController.text != "") {
                                      valid = true;
                                    }
                                  });
                                },
                                controller: newController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "At least 8 characters"),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Confirm password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    if (currentController.text != "" &&
                                        newController.text != "" &&
                                        confirmController.text != "") {
                                      valid = true;
                                    }
                                  });
                                },
                                controller: confirmController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "At least 8 characters"),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
