import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spark/services/storage.dart';
import 'package:uuid/uuid.dart';

import '../services/models.dart';
import '../shared/ProfileImg.dart';

class SoundWave extends StatefulWidget {
  const SoundWave({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  final Stream<Amplitude> stream;
  State<SoundWave> createState() => _SoundWaveState();
}

class SlidingUpAudio extends StatefulWidget {
  SlidingUpAudio({
    Key? key,
    required PanelController panelController,
    required this.report,
    required this.setPanelCloasedTrue,
    required this.setAudioUrl,
  })  : _panelController = panelController,
        super(key: key);
  final void Function()? setPanelCloasedTrue;
  final PanelController _panelController;
  final Function setAudioUrl;
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
                        onPressed: () async {
                          final currentPath = await record.stop();

                          widget._panelController.close();

                          if (currentPath != null) {
                            String audioUrl = await StorageService().UploadFile(
                              file: File(currentPath),
                            );

                            widget.setAudioUrl(audioUrl);
                          }
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
              profileImg: widget.report.profileIMG,
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

class _SoundWaveState extends State<SoundWave> {
  @override
  List<Amplitude> amplitudeList = [];
  num maxLength = 45;
  Widget build(BuildContext context) {
    return StreamBuilder<Amplitude>(
        stream: widget.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            amplitudeList.add(snapshot.data!);
            while (amplitudeList.length > maxLength) {
              amplitudeList.removeAt(0);
            }
          }
          return Container(
            width: 410,
            height: 100,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: amplitudeList.length != maxLength
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.spaceAround,
                  children:
                      amplitudeList.map((e) => SoundBar(amplitude: e)).toList(),
                )
              ],
            ),
          );
        });
  }
}

class SoundBar extends StatelessWidget {
  const SoundBar({
    required this.amplitude,
    Key? key,
  }) : super(key: key);
  final Amplitude amplitude;

  convertToWave(double x) {
    if (x < -40) {
      return 7.0;
    }
    return 107.374 * pow(1.02663, x);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: SizedBox(
        height: convertToWave(amplitude.current),
        width: 7,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Color.fromARGB(255, 91, 23, 164),
          ),
        ),
      ),
    );
  }
}
