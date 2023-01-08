import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/services/models.dart';
import 'package:spark/shared/topics.dart';

class Topics extends StatefulWidget {
  const Topics({super.key});

  @override
  State<Topics> createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  var topicsTab = TopicsTab.Followed;

  @override
  Widget build(BuildContext context) {
    UserData report = Provider.of<UserData>(context);
    List<String> selected = [];
    List<String> userTopics = [];
    List<String> newList = [];

    return StreamBuilder<List<String>>(
        stream: FirestoreService().getAllTopics(report.id),
        builder: (context, snapshot) {
          userTopics = snapshot.data ?? [];
          subtopics.values.forEach((value) {
            newList.addAll(value);
          });
          userTopics.map(
            (e) {
              newList.remove(e);
            },
          );
          return Scaffold(
            appBar: AppBar(
              title: Text("Topics"),
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          topicsTab = TopicsTab.Followed;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            "Followed",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          topicsTab == TopicsTab.Followed
                              ? Container(
                                  width: 65,
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  height: 5,
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              topicsTab = TopicsTab.Suggested;
                            });
                          },
                          child: Text(
                            "Suggested",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        topicsTab == TopicsTab.Suggested
                            ? Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                height: 5,
                              )
                            : Container()
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              topicsTab = TopicsTab.Not_Interested;
                            });
                          },
                          child: Text(
                            "Not Interested",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        topicsTab == TopicsTab.Not_Interested
                            ? Container(
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                height: 5,
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "The Topics you follow are used to personalize the Tweets, events, and ads that you see, and show up publicly on your profile",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Column(
                    children: userTopics
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.message,
                                              size: 15,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.lightBlue),
                                        ),
                                      ),
                                      Text(e),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                      ),
                                      color: Colors.transparent,
                                      height: 25,
                                      minWidth: 40,
                                      onPressed: () {
                                        setState(() {
                                          userTopics.remove(e);
                                        });
                                        FirestoreService()
                                            .unFollowTopic(report.id, e);
                                      },
                                      child: Text(
                                        "Following",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        .toList()),
                Divider(
                  color: Colors.grey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Suggested Topics",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ChipRow(
                      handleTap: () {},
                      start: 0,
                      stop: newList.length ~/ 3,
                      selected: selected,
                      newList: newList,
                      report: report,
                    ),
                    ChipRow(
                      handleTap: () {},
                      start: newList.length ~/ 3,
                      stop: (newList.length ~/ 3) * 2,
                      selected: selected,
                      newList: newList,
                      report: report,
                    ),
                    ChipRow(
                      handleTap: () {},
                      stop: newList.length,
                      start: (newList.length ~/ 3) * 2,
                      selected: selected,
                      newList: newList,
                      report: report,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class ChipRow extends StatelessWidget {
  final int start;
  final List<String> newList;
  final UserData report;
  final int stop;

  final List<String> selected;

  const ChipRow({
    Key? key,
    required this.selected,
    required this.newList,
    required this.handleTap,
    required this.start,
    required this.stop,
    required this.report,
  }) : super(key: key);

  final Function handleTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: newList
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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              sub,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              FirestoreService().followSubTopic(report.id, sub);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                color: Colors.blue,
                                size: 20,
                                Icons.add,
                              ),
                            ),
                          )
                        ],
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
