import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spark/services/auth.dart';
import 'package:spark/services/firestore.dart';

import '../../services/models.dart';
import '../Settings.dart';

class YourAccont extends StatelessWidget {
  const YourAccont({super.key});

  @override
  Widget build(BuildContext context) {
    UserData report = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Column(
            children: [
              Text(
                "Account",
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
              Column(
                children: [
                  SettingIcon(
                    title: "Account Information",
                    icon: FontAwesomeIcons.user,
                    body:
                        "See your account information like your phone number and email adress.",
                    function: () {
                      Navigator.pushNamed(
                          context, "/settings/yourAccont/account");
                    },
                  ),
                  SettingIcon(
                    title: "Change your password",
                    icon: FontAwesomeIcons.key,
                    body: "Change your password at any time.",
                    function: () {
                      Navigator.pushNamed(
                          context, '/settings/yourAccont/changePassword');
                    },
                  ),
                  SettingIcon(
                    title: "Download an archive of your data",
                    icon: FontAwesomeIcons.download,
                    body:
                        "Get insights into the type of information stored for your account.",
                    function: () {
                      Share.share(report.toJson().toString(),
                          subject: 'Your Data');
                    },
                  ),
                  SettingIcon(
                    title: "Deactivate your account",
                    icon: FontAwesomeIcons.heartCrack,
                    body: "Find out how you can deactivate your account.",
                    function: () {
                      // set up the button
                      Widget okButton = MaterialButton(
                        child: Text(
                          "Deleate",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
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
                          AuthService().user?.delete();
                        },
                      );
                      Widget cancelButton = MaterialButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      );
                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text("Are you sure?"),
                        content: Text(
                            "This will perminatly deleate your account and it will be unrecoverable are you sure you want to continue?"),
                        actions: [okButton, cancelButton],
                      );
                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
