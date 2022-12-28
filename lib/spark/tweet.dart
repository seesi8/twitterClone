import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/services/models.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:spark/sparks/images.dart';
import 'package:intl/intl.dart';
import 'package:spark/sparks/poll.dart';

import '../shared/sharedSparkTools.dart';
import '../spark/spark.dart';

class SparkBig extends StatefulWidget {
  const SparkBig({required this.tweet});

  final Future<Tweet> tweet;

  @override
  State<SparkBig> createState() => _SparkBigState();
}

class _SparkBigState extends State<SparkBig> {
  @override
  Widget build(BuildContext context) {
    String defaultImageURL =
        "https://firebasestorage.googleapis.com/v0/b/portfolio-dedd9.appspot.com/o/b6669dc7-0a14-43dc-a98a-ec3fcf90e40c?alt=media&token=68b11277-26a4-4a2b-bd4b-48b3090f717b";
    String getFormattedLocalTime(DateTime dateTime) {
      // Convert the DateTime object to local time
      DateTime localDateTime = dateTime.toLocal();
      // Get the time in the format "hh:mm"
      String formattedTime = DateFormat.jm().format(localDateTime);
      // Get the date in the format "MM/dd/yy"
      String formattedDate = DateFormat.yMd().format(localDateTime);
      // Return the formatted time and date with the desired separator " • "
      return "$formattedTime • $formattedDate";
    }

    String timeSince(DateTime date) {
      // Get the current date and time
      var now = DateTime.now();

      // Subtract the given date from the current date to get a Duration object
      var duration = now.difference(date);

      // Check the length of the duration
      if (duration.inDays >= 7) {
        // Return the local date string for dates that are more than a week old
        var formatter = new DateFormat(
            'MM/dd/yyyy'); // create a formatter with the desired format
        var formattedDate = formatter.format(date); // format the date using the
        return formattedDate;
      } else if (duration.inDays >= 1) {
        // Return the number of whole days
        return '-${duration.inDays}d-';
      } else if (duration.inHours >= 1) {
        // Return the number of whole hours
        return '-${duration.inHours}h-';
      } else {
        // Return the number of whole minutes
        return '-${duration.inMinutes}m-';
      }
    }

    UserData report = Provider.of<UserData>(context);

    return FutureBuilder<Tweet>(
      future: widget.tweet,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          Tweet tweet = snapshot.data!;

          return FutureBuilder<UserData?>(
            future: FirestoreService().getUser(tweet.authorUid),
            builder: (context, snapshot) {
              UserData user = snapshot.data ??
                  UserData(
                      profileIMG: defaultImageURL, dateJoined: DateTime.now());
              return Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    tweet.retweeted != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.retweet),
                                Text(
                                    "  Retweeeted by: ${tweet.retweeted!.displayName}"),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileImg(
                            profileImg: user.profileIMG,
                            size: Size(40, 40),
                            report: user,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        user.displayName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          color: Colors.lightBlue,
                                          FontAwesomeIcons.circleCheck,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                        "@${user.username}",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          timeSince(tweet.timeSent),
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    width: 333,
                                    child: Text(
                                      tweet.text,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                tweet.poll != null
                                    ? VoteablePoll(
                                        poll: tweet.poll!,
                                        date: tweet.timeSent,
                                        id: tweet.id,
                                      )
                                    : Container(),
                                //must be in this order in order to work using short circut eval
                                tweet.imagePathsOrUrls != null &&
                                        tweet.imagePathsOrUrls!.length > 0
                                    ? Images(
                                        images: tweet.imagePathsOrUrls!,
                                      )
                                    : Container(),
                                tweet.audioUrl != null
                                    ? AudioWidget(
                                        user: user,
                                        tweet: tweet,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        getFormattedLocalTime(tweet.timeSent),
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Divider(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0, left: 8.0),
                          child: Text(tweet.numHearts.toString()),
                        ),
                        Text("likes",
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Divider(color: Colors.grey),
                    ),
                    ActionButtons(tweet: tweet, report: report),
                    Divider(color: Colors.grey),
                  ],
                ),
              );
            },
          );
        } else {
          return Text("Loading...");
        }
      },
    );
  }
}
