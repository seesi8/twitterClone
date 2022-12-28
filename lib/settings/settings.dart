import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/models.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
                "Settings",
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
              Center(
                child: Container(
                  height: 30,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color.fromARGB(61, 158, 158, 158),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 20,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 1),
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              height: 30,
                              child: Center(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search Settings",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              Column(
                children: [
                  SettingIcon(
                    function: () {
                      Navigator.pushNamed(context, "/settings/yourAccont");
                    },
                  ),
                  // SettingIcon(
                  //   title: "Security and account access",
                  //   icon: Icons.lock,
                  //   body:
                  //       "Manage you account's security and keep track of you account's usage including apps that you have connected to your account.",
                  //   function: () {
                  //     Navigator.pushNamed(context, "/settings/secuirtyAA");
                  //   },
                  // ),
                  // SettingIcon(
                  //   title: "Privacy and safety",
                  //   icon: FontAwesomeIcons.circleCheck,
                  //   body:
                  //       "Manage what information you see and share on spark social.",
                  //   function: () {},
                  // ),
                  // SettingIcon(
                  //   title: "Notifications",
                  //   icon: FontAwesomeIcons.bell,
                  //   body:
                  //       "Select the kings of notification you get about your activies, intrests, and recomendations.",
                  //   function: () {},
                  // ),
                  // SettingIcon(
                  //   title: "Accessibility, display, and language",
                  //   icon: FontAwesomeIcons.accessibleIcon,
                  //   body: "Manage how Twitter content is displayed to you.",
                  //   function: () {},
                  // ),
                  // SettingIcon(
                  //   title: "Additional resources",
                  //   icon: Icons.more_horiz_outlined,
                  //   body: "Manage how Twitter content is displayed to you.",
                  //   function: () {},
                  // ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SettingIcon extends StatelessWidget {
  final String title;
  final Function function;
  final IconData icon;
  final String body;

  const SettingIcon({
    Key? key,
    this.title = "Your account",
    required this.function,
    this.icon = FontAwesomeIcons.user,
    this.body =
        "See infomration about your account, download an archive of your data, or learn about your account deactivation options.",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Icon(
                icon,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: 315,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      body,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
