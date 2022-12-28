import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../profilePic/profilePic.dart';

class PasswordCreate extends StatefulWidget {
  final String name;

  final String phoneOrEmail;

  final DateTime dob;

  const PasswordCreate(
      {super.key,
      required this.name,
      required this.phoneOrEmail,
      required this.dob});

  @override
  State<PasswordCreate> createState() => _PasswordCreateState();
}

class _PasswordCreateState extends State<PasswordCreate> {
  String password = '';
  bool visable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProfilePic(
                        dob: widget.dob,
                        name: widget.name,
                        phoneOrEmail: widget.phoneOrEmail,
                        password: password,
                      ),
                    ),
                  );
                },
                backgroundColor:
                    password.length > 7 ? Colors.white : Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text("Next"),
                ),
              ),
            ),
          ],
        ),
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
              "You'll need a password",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Make sure it's 8 characters or more",
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
              child: TextField(
                onTap: () {},
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: !visable,
                decoration: InputDecoration(
                  suffix: SizedBox(
                    width: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        password.length > 7
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : password.length > 0
                                ? Icon(
                                    FontAwesomeIcons.circleExclamation,
                                    color: Colors.red,
                                  )
                                : SizedBox(
                                    width: 1,
                                    height: 1,
                                  ),
                        IconButton(
                          icon: visable
                              ? Icon(FontAwesomeIcons.eyeSlash)
                              : Icon(FontAwesomeIcons.eye),
                          onPressed: () {
                            setState(() {
                              visable = !visable;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  hintText: "Password",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
