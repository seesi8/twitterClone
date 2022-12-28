import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/models.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:spark/shared/sharedSparkTools.dart';
import 'package:spark/sparks/spark.dart';

import '../services/firestore.dart';

class Account extends StatefulWidget {
  const Account({super.key, required this.user});

  final UserData user;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  AccountTab accountTab = AccountTab.Tweets;

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      // Create a DateFormat instance with the desired format
      String monthName;
      switch (date.toLocal().month) {
        case 1:
          monthName = "January";
          break;
        case 2:
          monthName = "February";
          break;
        case 3:
          monthName = "March";
          break;
        case 4:
          monthName = "April";
          break;
        case 5:
          monthName = "May";
          break;
        case 6:
          monthName = "June";
          break;
        case 7:
          monthName = "July";
          break;
        case 8:
          monthName = "August";
          break;
        case 9:
          monthName = "September";
          break;
        case 10:
          monthName = "October";
          break;
        case 11:
          monthName = "November";
          break;
        case 12:
          monthName = "December";
          break;
        default:
          monthName = "Invalid month number";
      }
      // Use the format method to convert the DateTime to a formatted string
      return "$monthName ${date.toLocal().year}";
    }

    Stream<List<Future<Tweet>>> getStream(accountTab) {
      switch (accountTab) {
        case AccountTab.Likes:
          return FirestoreService().streamUserLikes(widget.user.id);
        case AccountTab.Tweets:
          return FirestoreService().streamUserTweets(widget.user.id);
        case AccountTab.TweetsAndReplies:
          return FirestoreService().streamUserTweetsAndComments(widget.user.id);
        case AccountTab.Media:
          return FirestoreService().streamUserMedia(widget.user.id);
        default:
          return FirestoreService().streamUserTweets(widget.user.id);
      }
    }

    UserData report = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leadingWidth: 35,
        backgroundColor: Colors.lightBlue[300],
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.5),
            child: InkWell(
              onTap: () {},
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {},
                    color: Color.fromARGB(142, 158, 158, 158),
                    shape: CircleBorder(),
                  ),
                  const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(142, 158, 158, 158),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 40,
                color: Colors.lightBlue[300],
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: ProfileImg(
                          report: widget.user,
                          profileImg: widget.user.profileIMG,
                          size: Size.fromRadius(40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0, right: 15),
                      child: report == widget.user
                          ? ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Color.fromARGB(165, 158, 158, 158),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () {},
                              child: Text("Edit profile"),
                            )
                          : StreamBuilder<bool>(
                              stream: FirestoreService()
                                  .isFollowing(report.id, widget.user.id),
                              builder: (context, snapshot) {
                                bool following = snapshot.data ?? false;

                                return ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color:
                                            Color.fromARGB(165, 158, 158, 158),
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                        following
                                            ? Colors.transparent
                                            : Colors.white),
                                  ),
                                  onPressed: () {
                                    if (following) {
                                      FirestoreService()
                                          .unFollow(report.id, widget.user.id);
                                    } else {
                                      FirestoreService()
                                          .follow(report.id, widget.user.id);
                                    }
                                  },
                                  child: Text(
                                    following ? "Following" : "Follow",
                                    style: TextStyle(
                                        color: following
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                );
                              }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "@${widget.user.username}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        widget.user.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            color: Colors.grey,
                            Icons.calendar_month,
                            size: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "Joined ${formatDate(widget.user.dateJoined)}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                numberToString(widget.user.following),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  "Following",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  numberToString(widget.user.followers),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    "Followers",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          accountTab = AccountTab.Tweets;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            "Tweets",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          accountTab == AccountTab.Tweets
                              ? Container(
                                  width: 50,
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
                              accountTab = AccountTab.TweetsAndReplies;
                            });
                          },
                          child: Text(
                            "Tweets & replies",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        accountTab == AccountTab.TweetsAndReplies
                            ? Container(
                                width: 120,
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
                              accountTab = AccountTab.Media;
                            });
                          },
                          child: Text(
                            "Media",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        accountTab == AccountTab.Media
                            ? Container(
                                width: 50,
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
                              accountTab = AccountTab.Likes;
                            });
                          },
                          child: Text(
                            "Likes",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        accountTab == AccountTab.Likes
                            ? Container(
                                width: 50,
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
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              StreamBuilder<List<Future<Tweet>>>(
                  stream: getStream(accountTab),
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: 531,
                      child: SingleChildScrollView(
                        child: Column(
                            children: snapshot.data?.map((e) {
                                  return Spark(tweet: e);
                                }).toList() ??
                                [Text("Unable To get tweets")]),
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
