import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/sparks/spark.dart';

import '../acount/acount.dart';
import '../services/models.dart';
import '../shared/ProfileImg.dart';
import '../shared/sharedSparkTools.dart';

class Sparks extends StatefulWidget {
  const Sparks({super.key});

  @override
  State<Sparks> createState() => _SparksState();
}

class _SparksState extends State<Sparks> {
  @override
  bool _drawerOpen = false;
  bool scrolled = false;

  Widget build(BuildContext context) {
    var report = Provider.of<UserData>(context);
    var currentStream = FirestoreService().streamTweets(report.id);

    return Scaffold(
      onDrawerChanged: (isOpened) {
        setState(() {
          _drawerOpen = isOpened;
        });
      },
      drawer: AccountDrawer(
        report: report,
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.grey, width: .5)),
        elevation: 4,
        leadingWidth: 0,
        leading: Container(),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    child: ProfileImg(
                      size: Size(30, 30),
                      profileImg: report.profileIMG != null
                          ? report.profileIMG
                          : defaultImageURL,
                    ),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/");
                },
                child: Icon(
                  FontAwesomeIcons.boltLightning,
                  color: Colors.lightBlue[300],
                ),
              ),
              // Icon(FontAwesomeIcons.star)
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: () => {Navigator.pushNamed(context, "/create")},
          child: Icon(FontAwesomeIcons.plus)),
      // persistentFooterButtons: [
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Icon(FontAwesomeIcons.house),
      //       Icon(FontAwesomeIcons.magnifyingGlass),
      //       Icon(FontAwesomeIcons.microphone),
      //       Icon(FontAwesomeIcons.bell),
      //       Icon(FontAwesomeIcons.envelope),
      //     ],
      //   )
      // ],
      persistentFooterAlignment: AlignmentDirectional.center,
      body: Stack(
        children: [
          if (_drawerOpen == true)
            Container(
              color: Colors.white24,
            ),
          StreamBuilder<List<Future<Tweet>>>(
              stream: currentStream,
              builder: (context, snapshot) {
                ScrollController _scrollController = ScrollController();
                _scrollController.addListener(() {
                  if (_scrollController.offset <=
                          _scrollController.position.minScrollExtent &&
                      !_scrollController.position.outOfRange) {
                    setState(() {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (route) => false);
                    });
                  }
                  setState(() {
                    scrolled = true;
                  });
                });

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: snapshot.data != null
                        ? [
                            scrolled
                                ? Image.asset(
                                    "assets/loading.gif",
                                    height: 25.0,
                                    width: 25.0,
                                  )
                                : Container(),
                            ...snapshot.data!
                                .map((e) => Spark(tweet: e))
                                .toList()
                          ]
                        : [
                            Text("Unable To Get Tweets"),
                          ],
                  ),
                );
              })
        ],
      ),
    );
  }
}

class AccountDrawer extends StatelessWidget {
  const AccountDrawer({
    Key? key,
    required this.report,
  }) : super(key: key);

  final UserData report;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileImg(
                        report: report,
                        profileImg: report.profileIMG,
                        size: Size(35, 35)),
                    Text("Samuel Liebert"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '@${report.username}',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                            numberToString(report.following),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Following",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            numberToString(report.followers),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Account(
                          user: report,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: const [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(FontAwesomeIcons.user),
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/topics");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: const [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.message),
                        ),
                        Text(
                          "Topics",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: .5,
                ),
                ListTileTheme(
                  minVerticalPadding: 0,
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.all(0),
                    childrenPadding: EdgeInsets.all(0),
                    textColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    title: const Text(
                      'Settings and Support',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Row(children: const [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              FontAwesomeIcons.gear,
                              size: 15,
                            ),
                          ),
                          Text(
                            "Settings and privacy",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.normal),
                          )
                        ]),
                        onTap: () {
                          Navigator.pushNamed(context, "/settings");
                        },
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Row(children: const [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              FontAwesomeIcons.circleQuestion,
                              size: 15,
                            ),
                          ),
                          Text(
                            "Help Center",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.normal),
                          )
                        ]),
                        onTap: () {
                          // Handle tap on item 1
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
