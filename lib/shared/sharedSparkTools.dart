import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../comment/Comment.dart';
import 'package:share_plus/share_plus.dart';
import '../services/firestore.dart';
import '../services/models.dart';
import 'ProfileImg.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.tweet,
    required this.report,
  }) : super(key: key);

  final Tweet tweet;
  final UserData report;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Comment(
                    tweet: tweet,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    FontAwesomeIcons.comment,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  tweet.numComments.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          InkWell(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    FontAwesomeIcons.retweet,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  tweet.numRetweets.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              FirestoreService().retweet(
                id: tweet.id,
                uid: report.id,
              );
            },
          ),
          InkWell(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    !tweet.heartedBuy.contains(report.id)
                        ? FontAwesomeIcons.heart
                        : FontAwesomeIcons.solidHeart,
                    color: !tweet.heartedBuy.contains(report.id)
                        ? Colors.grey
                        : Colors.red,
                  ),
                ),
                Text(
                  tweet.numHearts.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              FirestoreService().heart(
                id: tweet.id,
                uid: report.id,
              );
            },
          ),
          InkWell(
            child: Icon(
              FontAwesomeIcons.upload,
              color: Colors.grey,
            ),
            onTap: () {
              Share.share('https://example.com',
                  subject: 'Check out this tweet!');
            },
          )
        ],
      ),
    );
  }
}

String numberToString(int number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}b';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}m';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}k';
  } else {
    return number.toString();
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
                        profileImg: widget.user.profileIMG,
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
                            icon:
                                Icon(!playing ? Icons.play_arrow : Icons.pause),
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
                              } else if (player.state == PlayerState.playing) {
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
      },
    );
  }
}
