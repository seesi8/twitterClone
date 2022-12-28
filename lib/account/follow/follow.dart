import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spark/services/auth.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/services/models.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:spark/shared/topics.dart';

import '../profilePic/profilePic.dart';

class Follow extends StatefulWidget {
  final String name;

  final String phoneOrEmail;

  final DateTime dob;

  final File? profileIMG;

  final String password;

  final List<String> topics;

  final String? username;

  final List<String> subTopics;

  const Follow(
      {super.key,
      required this.name,
      required this.phoneOrEmail,
      required this.subTopics,
      required this.topics,
      required this.profileIMG,
      required this.password,
      required this.username,
      required this.dob});

  @override
  State<Follow> createState() => _FollowState();
}

class _FollowState extends State<Follow> {
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 380,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 30,
              width: 70,
              child: FloatingActionButton(
                mini: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(90),
                  ),
                ),
                onPressed: () async {
                  bool complete =
                      await AuthService().createUserWithUsernameAndPassword(
                    followers: selected,
                    dob: widget.dob,
                    name: widget.name,
                    phoneOrEmail: widget.phoneOrEmail,
                    password: widget.password,
                    profileIMG: widget.profileIMG,
                    subTopics: widget.subTopics,
                    topics: widget.topics,
                    username: widget.username,
                  );

                  if (complete) {
                    Navigator.pushNamed(context, "/");
                  } else {
                    Navigator.pushNamed(context, "/");
                  }
                },
                backgroundColor: Colors.white,
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Text(
                  "Dont miss out",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "When you follow someone, you'll see thier Sparks in your Timeline. You'll also get more relavant recommendations.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: Text(
              "Follow 1 or more accounts",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            height: 650,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SingleChildScrollView(
                child: FutureBuilder<List<UserData>>(
                    future: FirestoreService().getSuggestedFollowers(),
                    builder: (context, snapshot) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: snapshot.data
                                ?.map((e) => SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: ProfileImg(
                                              profileImg: e.profileIMG,
                                              size: Size(50, 50),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 300,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e.displayName,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '@${e.username}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                            fontSize: 13,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(100),
                                                        ),
                                                      ),
                                                      color: selected
                                                              .contains(e.id)
                                                          ? Colors.black
                                                          : Colors.white,
                                                      height: 25,
                                                      minWidth: 40,
                                                      onPressed: () {
                                                        setState(() {
                                                          if (!selected
                                                              .contains(e.id)) {
                                                            selected.add(e.id);
                                                          } else {
                                                            selected
                                                                .remove(e.id);
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        selected.contains(e.id)
                                                            ? "Following"
                                                            : "Follow",
                                                        style: TextStyle(
                                                          color: !selected
                                                                  .contains(
                                                                      e.id)
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                e.description,
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                .toList() ??
                            [],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
