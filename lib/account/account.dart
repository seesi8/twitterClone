import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'confirm/confirm.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String name = "";
  String emailOrPhone = "";
  DateTime? dob;
  TextEditingController dobController = TextEditingController();
  bool? isPhone;
  bool phoneFocused = false;
  bool validEmailOrPhone = false;
  final RegExp regex = RegExp(
      r"^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$|^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  FocusNode phoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    phoneFocus.addListener(() {
      setState(() {
        phoneFocused = phoneFocus.hasFocus;
      });
    });
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 380,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            phoneFocused
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isPhone = !(isPhone ?? true);
                      });
                    },
                    child: Text(
                      "Use ${isPhone! ? "email" : "phone"} instead",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ))
                : Text(""),
            SizedBox(
              height: 25,
              child: FloatingActionButton(
                mini: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (name.length > 0 &&
                      dob != null &&
                      regex.hasMatch(emailOrPhone)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ConfirmAccount(
                          dob: dob ?? DateTime.now(),
                          name: name,
                          phoneOrEmail: emailOrPhone,
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: name.length > 0 &&
                        dob != null &&
                        regex.hasMatch(emailOrPhone)
                    ? Colors.white
                    : Colors.grey,
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
              "Create your account",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: TextField(
                onChanged: (String value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Name",
                  suffix: name.length > 0
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : SizedBox(
                          width: 10,
                          height: 10,
                        ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0, top: 16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    emailOrPhone = value;
                    validEmailOrPhone = regex.hasMatch(value);
                  });
                },
                focusNode: phoneFocus,
                onTap: () {
                  setState(() {
                    if (isPhone == null) {
                      isPhone = true;
                    }
                  });
                },
                decoration: InputDecoration(
                    suffix: validEmailOrPhone
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : SizedBox(
                            width: 10,
                            height: 10,
                          ),
                    hintText: isPhone == null
                        ? "Phone number or email address"
                        : isPhone!
                            ? "Phone"
                            : "Email"),
                keyboardType: isPhone == null || isPhone!
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0, top: 16),
              child: TextField(
                controller: dobController,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dob ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  dobController.value = TextEditingValue(
                      text: DateFormat.yMMMMd()
                              .format(picked?.toLocal() ?? DateTime.now())
                              .toString() ??
                          "");
                  if (picked != null && picked != dob)
                    setState(() {
                      dob = picked;
                    });
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  suffix: dob != null
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : SizedBox(
                          width: 10,
                          height: 10,
                        ),
                  hintText: "Date of birth",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
