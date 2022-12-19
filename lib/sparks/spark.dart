import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/services/models.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:spark/sparks/images.dart';
import 'package:spark/sparks/poll.dart';

class Spark extends StatefulWidget {
  const Spark({required this.tweet});

  final Future<Tweet> tweet;

  @override
  State<Spark> createState() => _SparkState();
}

class _SparkState extends State<Spark> {
  @override
  Widget build(BuildContext context) {
    String defaultImageURL =
        "https://firebasestorage.googleapis.com/v0/b/portfolio-dedd9.appspot.com/o/b6669dc7-0a14-43dc-a98a-ec3fcf90e40c?alt=media&token=68b11277-26a4-4a2b-bd4b-48b3090f717b";
    String timeSince(DateTime date) {
      // Get the current date and time
      var now = DateTime.now();

      // Subtract the given date from the current date to get a Duration object
      var duration = now.difference(date);

      // Check the length of the duration
      if (duration.inDays >= 7) {
        // Return the local date string for dates that are more than a week old
        return date.toLocal().toString();
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

    return FutureBuilder<Tweet>(
      future: widget.tweet,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          Tweet tweet = snapshot.data!;

          return FutureBuilder<UserData?>(
            future: FirestoreService().getUser(tweet.authorUid),
            builder: (context, snapshot) {
              UserData user =
                  snapshot.data ?? UserData(profileIMG: defaultImageURL);
              return Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                child: Image.network(user.profileIMG),
                              ),
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
                                                color: Colors.grey,
                                                fontSize: 10),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Icon(
                                                  FontAwesomeIcons.comment,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                tweet.numComments.toString(),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Icon(
                                                  FontAwesomeIcons.retweet,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                tweet.numRetweets.toString(),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    FontAwesomeIcons.heart,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              Text(
                                                tweet.numHearts.toString(),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            child: Icon(
                                          FontAwesomeIcons.upload,
                                          color: Colors.grey,
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                    Divider(color: Colors.grey)
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

class AudioWidget extends StatefulWidget {
  final Tweet tweet;

  const AudioWidget({Key? key, required this.user, required this.tweet})
      : super(key: key);

  final UserData user;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  bool playing = false;
  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    // await player.setSource(UrlSource(tweet));
    String convertDuration(Duration duration) {
      int minutes = duration.inMinutes;
      int seconds = duration.inSeconds;
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    }

    return FutureBuilder<Duration>(
        future: (player.setSource(UrlSource(widget.tweet.audioUrl!)).then(
          (value) async {
            var duration = (await player.getDuration())!;
            return (duration);
          },
        )),
        builder: (context, snapshot) {
          return Container(
            width: 340,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.red[800],
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  convertDuration(
                                    snapshot.data ?? Duration(),
                                  ),
                                  style: TextStyle(
                                    color: Color.fromARGB(172, 255, 255, 255),
                                  ),
                                ),
                                Icon(
                                  Icons.speaker,
                                  size: 15,
                                  color: Color.fromARGB(172, 255, 255, 255),
                                )
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  size: 15,
                                  FontAwesomeIcons.boltLightning,
                                  color: Color.fromARGB(172, 255, 255, 255),
                                ),
                                Text(
                                  "Voice",
                                  style: TextStyle(
                                    color: Color.fromARGB(172, 255, 255, 255),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: ProfileImg(
                          report: widget.user,
                          size: Size(75, 75),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(209, 0, 0, 0),
                          ),
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                  !playing ? Icons.play_arrow : Icons.pause),
                              color: Colors.white,
                              onPressed: () async {
                                if (player.state == PlayerState.stopped) {
                                  await player.play(
                                      UrlSource(widget.tweet.audioUrl!),
                                      mode: PlayerMode.lowLatency);
                                  setState(() {
                                    playing = true;
                                  });
                                } else if (player.state == PlayerState.paused) {
                                  player.resume();
                                  setState(() {
                                    playing = true;
                                  });
                                } else if (player.state ==
                                    PlayerState.playing) {
                                  player.pause();
                                  setState(() {
                                    playing = false;
                                  });
                                } else if (player.state ==
                                    PlayerState.completed) {
                                  player.play(UrlSource(widget.tweet.audioUrl!),
                                      mode: PlayerMode.lowLatency);
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
