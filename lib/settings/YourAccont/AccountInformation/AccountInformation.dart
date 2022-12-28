import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/auth.dart';

import '../../../services/models.dart';
import '../../Settings.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

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
                          "Username",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '@${report.username}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${report.email}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${report.phone}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        AuthService().signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/", (route) => false);
                      },
                      child: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
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
