import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spark/shared/ProfileImg.dart';

import '../profilePic/profilePic.dart';
import '../subtopics/subtopics.dart';

class TopicsCreate extends StatefulWidget {
  final String name;

  final String phoneOrEmail;

  final DateTime dob;

  final File? profileIMG;

  final String password;

  final String? username;

  const TopicsCreate(
      {super.key,
      required this.name,
      required this.phoneOrEmail,
      required this.profileIMG,
      required this.password,
      required this.username,
      required this.dob});

  @override
  State<TopicsCreate> createState() => _TopicsCreateState();
}

class _TopicsCreateState extends State<TopicsCreate> {
  List<String> selected = [];
  var chips = [
    "Music",
    "Entertainment",
    "Sports",
    "Gaming",
    "Fassion & beauty",
    "Fassion & Food",
    "Business and finance",
    "Arts & culture",
    "Technology",
    "Travel",
    "Outdoors",
    "Fitness",
    "Careers",
    "Animation & comics",
    "Family & relationships",
    "Science",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 380,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selected.length > 2
                ? Text(
                    "Great work 🎉",
                    style: TextStyle(color: Colors.grey),
                  )
                : Text(
                    "${selected.length} of 3 selected",
                    style: TextStyle(color: Colors.grey),
                  ),
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
                  if (selected.length > 2) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SubTopics(
                          dob: widget.dob,
                          name: widget.name,
                          phoneOrEmail: widget.phoneOrEmail,
                          password: widget.password,
                          profileIMG: widget.profileIMG,
                          username: widget.username,
                          topics: selected,
                        ),
                      ),
                    );
                  }
                },
                backgroundColor:
                    selected.length > 2 ? Colors.white : Colors.grey,
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
                "Select at least 3 interests to personalize your Spark experience. They will be visable on your profile.",
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
              child: SizedBox(
                width: 400,
                height: 650,
                child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    // Generate 100 widgets that display their index in the List.
                    children: chips
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                if (!selected.contains(e)) {
                                  print("Sick");
                                  setState(() {
                                    selected.add(e);
                                  });
                                } else {
                                  setState(() {
                                    selected.remove(e);
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                alignment: AlignmentDirectional.bottomStart,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: !selected.contains(e)
                                        ? Color.fromARGB(255, 77, 76, 76)
                                        : Colors.blue, // red as border color
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: !selected.contains(e)
                                      ? Color.fromARGB(122, 59, 56, 56)
                                      : Colors.blue,
                                ),
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomStart,
                                  children: [
                                    selected.contains(e)
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                                FontAwesomeIcons.circleCheck),
                                          )
                                        : Container(),
                                    Text(e),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
