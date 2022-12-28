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

class SecuirtyAA extends StatelessWidget {
  const SecuirtyAA({super.key});

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
                "Security and account access",
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
                    title: "Security",
                    icon: FontAwesomeIcons.lock,
                    body: "Manage your account's security.",
                    function: () {
                      Navigator.pushNamed(context, "/settings/secuirtyAA/tfa");
                    },
                  ),
                  SettingIcon(
                    title: "Connected accounts",
                    icon: FontAwesomeIcons.arrowRightArrowLeft,
                    body:
                        "Manage Google or apple accounts connected to spark social to log in.",
                    function: () {
                      Share.share(report.toJson().toString(),
                          subject: 'Your Data');
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
