import 'dart:math';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

class SoundWave extends StatefulWidget {
  const SoundWave({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  final Stream<Amplitude> stream;
  State<SoundWave> createState() => _SoundWaveState();
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
