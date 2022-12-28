import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spark/services/firestore.dart';

import '../profilePic/profilePic.dart';
import '../topics/topics.dart';

class UsernameCreate extends StatefulWidget {
  final String name;

  final String phoneOrEmail;

  final DateTime dob;

  final File? profileIMG;

  final String password;

  const UsernameCreate(
      {super.key,
      required this.name,
      required this.phoneOrEmail,
      required this.profileIMG,
      required this.password,
      required this.dob});

  @override
  State<UsernameCreate> createState() => _UsernameCreateState();
}

class _UsernameCreateState extends State<UsernameCreate> {
  String username = '';
  TextEditingController controller = TextEditingController();
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 380,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (valid) {
                        print(username);
                        goToNext(context, username);
                      }
                    },
                    backgroundColor: valid ? Colors.white : Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text("Next"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                goToNext(context, null);
              },
              child: Text(
                "Skip for now",
                style: TextStyle(color: Colors.white),
              ))
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
        leadingWidth: 75,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What should we call you?",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Your @username is unique. You can always change it later.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
            FutureBuilder<List<String>>(
              future: FirestoreService().getSuggestedUsernames(
                email: widget.phoneOrEmail,
                name: widget.name,
              ),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  if (controller.text == '') {
                    controller.value =
                        TextEditingValue(text: "@${snapshot.data?.first}");
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: 16.0, top: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(fontSize: 11),
                        ),
                        TextFormField(
                          controller: controller,
                          onTap: () {
                            FirestoreService().getSuggestedUsernames(
                                email: widget.phoneOrEmail, name: widget.name);
                          },
                          onChanged: (value) async {
                            bool localValid = await FirestoreService()
                                .checkUniqueUsername(
                                    username: value.substring(1));
                            if (value[0] != "@") {
                              controller.value =
                                  TextEditingValue(text: '@$value');
                            }

                            setState(() {
                              username = value;
                              valid = localValid;
                            });
                          },
                          style: TextStyle(color: Colors.blue),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffix: valid
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    FontAwesomeIcons.circleExclamation,
                                    color: Colors.red,
                                  ),
                            hintText: "Username",
                          ),
                        ),
                        Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 0.0, // gap between lines
                            children: snapshot.data!.reversed
                                .take(5)
                                .map((e) {
                                  return TextButton(
                                    onPressed: () async {
                                      controller.value =
                                          TextEditingValue(text: '@$e');
                                      username = '@$e';
                                      bool localValid = await FirestoreService()
                                          .checkUniqueUsername(username: e);
                                      setState(() {
                                        valid = localValid;
                                      });
                                    },
                                    child: Text('@$e'),
                                  );
                                })
                                .toList()
                                .reversed
                                .toList()),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void goToNext(BuildContext context, String? usernameParam) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => TopicsCreate(
          dob: widget.dob,
          name: widget.name,
          phoneOrEmail: widget.phoneOrEmail,
          password: widget.password,
          profileIMG: widget.profileIMG,
          username: usernameParam?.substring(1),
        ),
      ),
    );
  }
}
