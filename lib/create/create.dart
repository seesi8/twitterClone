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
import 'package:spark/create/poll.dart';
import 'package:spark/create/sound.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import '../services/models.dart';
import 'lengthSelector.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  List<File> imageFiles = [];
  num _numWidgets = 0;
  num maxChar = 280;
  num currentChar = 0;
  bool _disabled = true;
  PanelController _panelController = new PanelController();
  bool panelCloased = true;
  bool poll = false;

  setPanelCloasedTrue() {
    setState(() {
      if (_panelController.isPanelClosed) {
        panelCloased = true;
      }
    });
  }

  Widget build(BuildContext context) {
    UserData report = Provider.of<UserData>(context);

    removePoll() {
      setState(() {
        poll = false;
      });
    }

    return Scaffold(
      backgroundColor:
          panelCloased ? Colors.black : Color.fromARGB(255, 40, 37, 37),
      appBar: panelCloased
          ? Header(disabled: _disabled)
          : AppBar(
              toolbarHeight: 0,
            ),
      body: Stack(
        children: [
          panelCloased
              ? Align(
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
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 13),
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
                                      if (await Permission
                                          .location.isRestricted) {
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
                                      setState(() {
                                        poll = !poll;
                                      });
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.listUl,
                                      color: Colors.blue,
                                      size: 17,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () async {
                                      if (_numWidgets < 4) {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        // Pick an image
                                        XFile? image = null;
                                        image = await _picker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          _numWidgets += 1;
                                          imageFiles.add(File(image!.path));
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.image,
                                      color: Colors.blue,
                                      size: 17,
                                    ),
                                  ),
                                  CharCounter(
                                      currentChar: currentChar,
                                      maxChar: maxChar),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          panelCloased
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              ProfileImg(report: report, size: Size(40, 40)),
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
                                    if (0 < value.length &&
                                        value.length < maxChar) {
                                      _disabled = false;
                                    } else {
                                      _disabled = true;
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  hintText: "What's happening?",
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
                          children:
                              imageFiles.map((e) => ImageWidget(e)).toList(),
                        ),
                      ),
                      poll
                          ? PollWidget(
                              removePoll: removePoll,
                            )
                          : Text("")
                    ],
                  ),
                )
              : Container(),
          SlidingUpAudio(
            panelController: _panelController,
            report: report,
            setPanelCloasedTrue: setPanelCloasedTrue,
          ),
        ],
      ),
    );
  }

  Padding ImageWidget(File e) {
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
                  imageFiles.removeWhere((item) => item == e);
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

class SlidingUpAudio extends StatefulWidget {
  const SlidingUpAudio({
    Key? key,
    required PanelController panelController,
    required this.report,
    required this.setPanelCloasedTrue,
  })  : _panelController = panelController,
        super(key: key);
  final void Function()? setPanelCloasedTrue;
  final PanelController _panelController;
  final UserData report;

  @override
  State<SlidingUpAudio> createState() => _SlidingUpAudioState();
}

class _SlidingUpAudioState extends State<SlidingUpAudio> {
  bool valid = false;
  AudioState audioState = AudioState.Stopped;

  String path = 'recording/${Uuid.NAMESPACE_URL}.mp4';
  Record record = Record();
  clearState() {
    setState(() {
      valid = false;
      path = 'recording/${Uuid.NAMESPACE_URL}.mp4';
      record = Record();
      audioState = AudioState.Stopped;
    });
  }

  late Stream<Amplitude> amplitudeStream = record
      .onAmplitudeChanged(Duration(milliseconds: 100))
      .asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      color: Colors.black,
      onPanelClosed: widget.setPanelCloasedTrue,
      onPanelOpened: clearState,
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      maxHeight: 825,
      minHeight: 0,
      controller: widget._panelController,
      panel: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Text("Cancel"),
                  onTap: () => widget._panelController.close(),
                ),
                audioState != AudioState.Stopped
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: SizedBox(
                              width: 8,
                              height: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: audioState == AudioState.Paused
                                      ? Colors.grey[800]
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Text(audioState == AudioState.Paused
                              ? "Paused"
                              : "Recording")
                        ],
                      )
                    : Row(),
                audioState != AudioState.Stopped
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(0),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: () {
                          record.stop();
                          widget._panelController.close();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 4.0,
                            bottom: 4.0,
                          ),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : Row(),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileSound(amplitudeStream: amplitudeStream, widget: widget),
                audioState == AudioState.Stopped
                    ? SizedBox(
                        height: 38,
                        child: Column(
                          children: [
                            Text(
                              "What's happening?",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "Hit record.",
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SoundWave(stream: amplitudeStream),
                FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 91, 23, 164),
                  onPressed: () async {
                    // Import package\
                    if (audioState == AudioState.Stopped) {
                      // Check and request permission
                      if (await record.hasPermission()) {
                        // Start recording
                        await record.start();
                      }
                      // Get the state of the recorder
                      bool isRecording = await record.isRecording();
                      if (isRecording) {
                        setState(() {
                          audioState = AudioState.Recording;
                        });
                      }
                      // Stop recording
                    } else if (audioState == AudioState.Paused) {
                      await record.resume();

                      bool isRecording = await record.isRecording();
                      if (isRecording) {
                        setState(() {
                          audioState = AudioState.Recording;
                        });
                      }
                    } else if (audioState == AudioState.Recording) {
                      await record.pause();

                      bool isPaused = await record.isPaused();
                      if (isPaused) {
                        setState(() {
                          audioState = AudioState.Paused;
                        });
                      }
                    }
                  },
                  child: const Ring(
                    radius: 20,
                    child: Icon(
                      color: Colors.white,
                      FontAwesomeIcons.microphone,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSound extends StatelessWidget {
  const ProfileSound({
    Key? key,
    required this.amplitudeStream,
    required this.widget,
  }) : super(key: key);

  final Stream<Amplitude> amplitudeStream;
  final SlidingUpAudio widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Amplitude>(
      stream: amplitudeStream,
      builder: (context, snapshot) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ProfileImg(
              report: widget.report,
              size: Size(100, 100),
            ),
          ],
        );
      },
    );
  }
}

class Ring extends StatelessWidget {
  final double radius;

  final double width;
  final Widget? child;
  final Color color;

  const Ring(
      {Key? key,
      required this.radius,
      this.child,
      this.color = Colors.white,
      this.width = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: width,
        ),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    Key? key,
    required bool disabled,
  })  : _disabled = disabled,
        super(key: key);

  final bool _disabled;

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
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            child: ElevatedButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(66, 10)),
                    backgroundColor: MaterialStateProperty.all(_disabled
                        ? Color.fromARGB(92, 3, 168, 244)
                        : Colors.blue)),
                onPressed: () {},
                child: Text(
                  "Spark",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                )),
          ),
        ),
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
