import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../password/password.dart';

class ConfirmAccount extends StatefulWidget {
  final DateTime dob;

  final String name;

  final String phoneOrEmail;

  const ConfirmAccount(
      {super.key,
      required this.name,
      required this.phoneOrEmail,
      required this.dob});

  @override
  State<ConfirmAccount> createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {
  bool? isPhone(String input) {
    // Regular expression for a phone number
    final phoneRegex = RegExp(
        r'^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$');

    // Regular expression for an email
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

    if (phoneRegex.matchAsPrefix(input) != null) {
      return true;
    } else if (emailRegex.matchAsPrefix(input) != null) {
      return false;
    } else {
      return null;
    }
  }

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
                    Radius.circular(100),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PasswordCreate(
                        dob: widget.dob,
                        name: widget.name,
                        phoneOrEmail: widget.phoneOrEmail,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create your account",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0, top: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: 500,
                    child: Text(
                      "Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                          alignment: Alignment.bottomLeft,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0, top: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: 500,
                    child: Text(
                      isPhone(widget.phoneOrEmail) == true
                          ? "Phone"
                          : isPhone(widget.phoneOrEmail) == false
                              ? "Email"
                              : "?",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                          alignment: Alignment.bottomLeft,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          widget.phoneOrEmail,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0, top: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: 500,
                    child: Text(
                      "Date of birth",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                          alignment: Alignment.bottomLeft,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          DateFormat.yMMMMd()
                              .format(widget.dob.toLocal())
                              .toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Text("By signing up, you agree to the tos and privacy policy")
          ],
        ),
      ),
    );
  }
}
