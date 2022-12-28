import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:spark/shared/topics.dart';

import '../follow/follow.dart';
import '../profilePic/profilePic.dart';

class SubTopics extends StatefulWidget {
  final String name;

  final String phoneOrEmail;

  final DateTime dob;

  final File? profileIMG;

  final String password;

  final List<String> topics;

  final String? username;

  const SubTopics(
      {super.key,
      required this.name,
      required this.phoneOrEmail,
      required this.topics,
      required this.profileIMG,
      required this.password,
      required this.username,
      required this.dob});

  @override
  State<SubTopics> createState() => _SubTopicsState();
}

class _SubTopicsState extends State<SubTopics> {
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Follow(
                        dob: widget.dob,
                        name: widget.name,
                        phoneOrEmail: widget.phoneOrEmail,
                        password: widget.password,
                        profileIMG: widget.profileIMG,
                        subTopics: selected,
                        topics: widget.topics,
                        username: widget.username,
                      ),
                    ),
                  );
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
                  "What do you want to see on Spark Social?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Interests are used to personalize your experiance and will be visable on your profile.",
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
          SizedBox(
            width: 400,
            height: 650,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: subtopics.keys
                    .map(
                      (e) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ChipRow(
                                  handleTap: handleTap,
                                  e: e,
                                  start: 0,
                                  stop: subtopics.length ~/ 3,
                                  selected: selected,
                                ),
                                ChipRow(
                                  handleTap: handleTap,
                                  e: e,
                                  start: subtopics.length ~/ 3,
                                  stop: (subtopics.length ~/ 3) * 2,
                                  selected: selected,
                                ),
                                ChipRow(
                                  handleTap: handleTap,
                                  e: e,
                                  stop: subtopics.length,
                                  start: (subtopics.length ~/ 3) * 2,
                                  selected: selected,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleTap(String sub) {
    setState(() {
      if (!selected.contains(sub)) {
        selected.add(sub);
      } else {
        selected.remove(sub);
      }
    });
  }
}

class ChipRow extends StatelessWidget {
  final int start;

  final int stop;
  final String e;

  final List<String> selected;

  const ChipRow({
    Key? key,
    required this.selected,
    required this.handleTap,
    required this.e,
    required this.start,
    required this.stop,
  }) : super(key: key);

  final Function handleTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subtopics[e]!
              .getRange(start, stop)
              .map(
                (sub) => InkWell(
                  onTap: () {
                    handleTap(sub);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected.contains(sub)
                            ? Colors.blue
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(
                            color: selected.contains(sub)
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          sub,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
