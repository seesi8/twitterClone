import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import '../services/auth.dart';
import '../services/models.dart';
import '../services/storage.dart';
import '../shared/poll.dart';
import '../shared/sound.dart';

class Comment extends StatefulWidget {
  const Comment({super.key, required this.tweet});

  final Tweet tweet;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  List<File> imageFiles = [];
  num _numWidgets = 0;
  num maxChar = 280;
  num currentChar = 0;
  PanelController _panelController = new PanelController();
  bool panelCloased = true;
  bool poll = false;
  final TextEditingController _tweetController = TextEditingController();

  setPanelCloasedTrue() {
    setState(() {
      if (_panelController.isPanelClosed) {
        panelCloased = true;
      }
    });
  }

  Tweet tweet = Tweet(
    text: "",
    timeSent: DateTime.now(),
    authorUid: "",
  );

  Widget build(BuildContext context) {
    UserData report = Provider.of<UserData>(context);
    tweet.authorUid = report.id;

    updateText(String value) {
      tweet.text = value;
    }

    addImagePath(String path) {
      tweet.imagePathsOrUrls ??= [];
      tweet.imagePathsOrUrls!.add(path);
    }

    removeImagePath(String path) {
      tweet.imagePathsOrUrls!.remove(path);
    }

    setAudioUrl(String url) {
      tweet.audioUrl = url;
    }

    initPoll() {
      tweet.poll = Poll(choices: [
        {"": 0},
        {"": 0}
      ]);
    }

    addChoice(String choice) {
      tweet.poll ??= Poll(choices: [
        {"": 0},
        {"": 0}
      ]);
      tweet.poll!.choices.add({choice: 0});
    }

    updateChoice(int index, String value) {
      tweet.poll ??= Poll(choices: [
        {"": 0},
        {"": 0}
      ]);

      tweet.poll!.choices[index] = {value: 0};
    }

    removePoll() {
      tweet.poll = null;
      setState(() {
        poll = false;
        _numWidgets = 0;
      });
    }

    Stream<Tweet> getTweet() {
      return Stream<Tweet>.periodic(Duration(milliseconds: 10),
          (computationCount) {
        return tweet;
      });
    }

    setLengthTime(LengthTime lengthTime) {
      tweet.poll ??= Poll(choices: [
        {"": 0},
        {"": 0}
      ]);
      tweet.poll!.lengthTime = lengthTime;
    }

    return Scaffold(
      backgroundColor:
          panelCloased ? Colors.black : Color.fromARGB(255, 40, 37, 37),
      appBar: panelCloased
          ? Header(
              id: widget.tweet.id,
              getTweet: getTweet,
            )
          : AppBar(
              toolbarHeight: 0,
            ),
      body: Stack(
        children: [
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              FontAwesomeIcons.earthAmericas,
                              color: Colors.blue,
                              size: 17,
                            ),
                          ),
                          Text(
                            "Everyone can reply",
                            style: TextStyle(color: Colors.blue, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () async {
                                var status = await Permission.microphone;
                                var request = await status.request();

                                if (await status.isGranted ||
                                    await status.isLimited) {
                                  if (_panelController.isAttached) {
                                    if (_panelController.isPanelOpen) {
                                      setState(() {
                                        panelCloased = true;
                                      });
                                      _panelController.close();
                                    } else {
                                      setState(() {
                                        panelCloased = false;
                                      });

                                      _panelController.open();
                                    }
                                  }
                                } else {}

                                // You can can also directly ask the permission about its status.
                                if (await Permission.location.isRestricted) {
                                  // The OS restricts access, for example because of parental controls.
                                }
                              },
                              icon: const Icon(
                                Icons.multitrack_audio,
                                color: Colors.blue,
                                size: 17,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                if (_numWidgets == 0) {
                                  setState(() {
                                    _numWidgets += 4;
                                    poll = !poll;
                                  });
                                }
                              },
                              icon: Icon(
                                FontAwesomeIcons.listUl,
                                color: _numWidgets == 0
                                    ? Colors.blue
                                    : Color.fromARGB(255, 15, 55, 88),
                                size: 17,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () async {
                                if (_numWidgets < 4) {
                                  final ImagePicker _picker = ImagePicker();
                                  // Pick an image
                                  XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  File fileImage = File(image!.path);
                                  setState(() {
                                    _numWidgets += 1;
                                    imageFiles.add(fileImage);
                                  });

                                  addImagePath(fileImage.path);
                                }
                              },
                              icon: Icon(
                                FontAwesomeIcons.image,
                                color: _numWidgets < 4
                                    ? Colors.blue
                                    : const Color.fromARGB(255, 16, 65, 105),
                                size: 17,
                              ),
                            ),
                            CharCounter(
                                currentChar: currentChar, maxChar: maxChar),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: panelCloased ? null : 0.1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    FutureBuilder<UserData?>(
                        future: FirestoreService().getUser(tweet.authorUid),
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Replying to ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  "@${snapshot.data?.username}",
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                          );
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ProfileImg(
                                report: report,
                                profileImg: report.profileIMG,
                                size: Size(40, 40)),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  currentChar = value.length;
                                  updateText(value);
                                  if (0 < value.length &&
                                      value.length < maxChar) {
                                  } else {}
                                });
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                hintText: "Tweet your reply",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: imageFiles
                            .map((e) => ImageWidget(e, removeImagePath, e.path))
                            .toList(),
                      ),
                    ),
                    poll
                        ? PollWidget(
                            removePoll: removePoll,
                            addChoice: addChoice,
                            initPoll: initPoll,
                            setLengthTime: setLengthTime,
                            updateChoice: updateChoice,
                          )
                        : Text("")
                  ],
                ),
              ),
            ),
          ),
          SlidingUpAudio(
            panelController: _panelController,
            report: report,
            setAudioUrl: setAudioUrl,
            setPanelCloasedTrue: setPanelCloasedTrue,
          ),
        ],
      ),
    );
  }

  Widget ImageWidget(File e, Function removeImageUrl, String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Image.file(
              e,
              alignment: Alignment.topLeft,
              height: 150,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  minimumSize: Size.zero,
                  padding: EdgeInsets.all(5),
                  backgroundColor: Colors.black87),
              onPressed: () {
                setState(() {
                  _numWidgets -= 1;
                  imageFiles.removeWhere((item) => item == e);
                  removeImageUrl(path);
                });
              },
              child: Icon(
                size: 10,
                FontAwesomeIcons.x,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String id;

  const Header({
    Key? key,
    required this.id,
    required this.getTweet,
  });

  final Stream<Tweet> Function() getTweet;
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      shape: Border(bottom: BorderSide(color: Colors.grey, width: .5)),
      elevation: 4,
      leadingWidth: 69,
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),
      actions: [
        StreamBuilder<Tweet>(
            stream: getTweet(),
            builder: (context, snapshot) {
              bool testIfDisabled(Tweet tweet) {
                final bool validText =
                    tweet.text != "" && tweet.text.length < 280;
                final bool validUid = tweet.authorUid != "";
                bool validChoices = true;
                if (tweet.poll != null) {
                  for (var choice in tweet.poll!.choices) {
                    if (choice == "" || choice == " ") {
                      validChoices = false;
                    }
                    if (choice.length > 25) {
                      validChoices = false;
                    }
                  }
                }
                final bool validDate = tweet.poll != null
                    ? tweet.poll!.lengthTime.days <= 7 &&
                        tweet.poll!.lengthTime.hours <= 23 &&
                        tweet.poll!.lengthTime.min <= 59
                    : true;

                final finalBool =
                    validDate && validChoices && validUid && validText;
                // print(finalBool);
                // print(finalBool
                //     ? "true"
                //     : !validDate
                //         ? "validDate"
                //         : !validChoices
                //             ? "validChoices"
                //             : !validUid
                //                 ? "validUid"
                //                 : "validText");
                return finalBool;
              }

              return Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(66, 10)),
                          backgroundColor: MaterialStateProperty.all(
                              !testIfDisabled(snapshot.data ??
                                      Tweet(
                                          text: "",
                                          timeSent: DateTime.now(),
                                          authorUid: ""))
                                  ? Color.fromARGB(92, 3, 168, 244)
                                  : Colors.blue)),
                      onPressed: () {
                        FirestoreService().CreateComment(
                            snapshot.data ??
                                Tweet(
                                  text: "",
                                  timeSent: DateTime.now(),
                                  authorUid: "",
                                ),
                            id);
                        Navigator.pushNamed(context, "/");
                      },
                      child: Text(
                        "Spark",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )),
                ),
              );
            }),
      ],
    );
  }
}

class CharCounter extends StatelessWidget {
  const CharCounter({
    Key? key,
    required this.currentChar,
    required this.maxChar,
  }) : super(key: key);

  final num currentChar;
  final num maxChar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: SizedBox(
        width: currentChar > maxChar - 20 ? 16 : 13,
        height: currentChar > maxChar - 20 ? 16 : 13,
        child: Stack(
          children: [
            Center(
              child: Text(
                currentChar > maxChar - 20
                    ? currentChar > maxChar
                        ? (maxChar - currentChar).toString()
                        : (maxChar - currentChar).toString()
                    : "",
                style: TextStyle(
                    fontSize: 9,
                    color: currentChar >= maxChar ? Colors.red : Colors.amber,
                    fontWeight: FontWeight.bold),
              ),
            ),
            CircularProgressIndicator(
              color: currentChar > maxChar - 20 && currentChar < maxChar
                  ? Colors.amber
                  : currentChar >= maxChar
                      ? currentChar >= maxChar + 10
                          ? Colors.transparent
                          : Colors.red
                      : Colors.lightBlue,
              backgroundColor: !(currentChar >= maxChar + 10)
                  ? Color.fromARGB(104, 158, 158, 158)
                  : Colors.transparent,
              strokeWidth: 2,
              value: currentChar / maxChar,
            ),
          ],
        ),
      ),
    );
  }
}
