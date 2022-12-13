import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../services/models.dart';
import 'lengthSelector.dart';

class PollWidget extends StatefulWidget {
  PollWidget({
    Key? key,
    required this.removePoll,
    required this.initPoll,
    required this.addChoice,
    required this.setLengthTime,
    required this.updateChoice,
  }) : super(
          key: key,
        );

  final Function removePoll;
  final Function initPoll;
  final Function updateChoice;
  final Function addChoice;
  final Function setLengthTime;

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  late List<Widget> Choices = [
    Choice(
      index: 0,
      updateChoice: widget.updateChoice,
    ),
    Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Choice(
        index: 1,
        updateChoice: widget.updateChoice,
      ),
    ),
  ];
  num _maxChoices = 4;
  bool pollLengthInputOpen = false;
  bool valid = false;
  LengthTime lengthTime = LengthTime(hours: 0, days: 1, min: 0);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border:
              Border.all(color: Color.fromARGB(70, 158, 158, 158), width: 1),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: Choices,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            minimumSize: Size.zero,
                            padding: EdgeInsets.all(0),
                            backgroundColor:
                                Color.fromARGB(143, 158, 158, 158)),
                        onPressed: () {
                          widget.removePoll();
                        },
                        child: const Icon(
                          color: Colors.black,
                          size: 20,
                          Icons.close_rounded,
                        ),
                      ),
                      Choices.length < _maxChoices
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.all(0),
                                  backgroundColor:
                                      Color.fromARGB(143, 158, 158, 158)),
                              onPressed: () {
                                if (Choices.length < _maxChoices) {
                                  setState(() {
                                    Choices.add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Choice(
                                          index: Choices.length,
                                          updateChoice: widget.updateChoice,
                                        ),
                                      ),
                                    );
                                  });
                                  widget.addChoice("");
                                }

                                print(Choices);
                              },
                              child: const Icon(
                                color: Colors.black,
                                size: 20,
                                Icons.add,
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(70, 158, 158, 158), width: 1),
                  ),
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Poll length",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          '${lengthTime.days > 0 ? lengthTime.days.toString() : ""} ${lengthTime.days > 0 ? "day" : ""}${lengthTime.days > 1 ? "s" : ""} ${lengthTime.hours > 0 ? lengthTime.hours.toString() : ""} ${lengthTime.hours > 0 ? "hr" : ""} ${lengthTime.min > 0 ? lengthTime.min.toString() : ""} ${lengthTime.min > 0 ? "min" : ""}  ',
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.all(0),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pollLengthInputOpen = !pollLengthInputOpen;
                            });
                          },
                          icon: Icon(Icons.keyboard_arrow_up_rounded),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: LengthSelectorGroup(
                  hidden: !pollLengthInputOpen,
                  onItemsChanged: (Map<String, int> values) {
                    setState(() {
                      lengthTime = LengthTime(
                        hours: values["hours"] ?? 0,
                        days: values["days"] ?? 0,
                        min: values["min"] ?? 0,
                      );
                    });
                    widget.setLengthTime(lengthTime);
                  },
                  selectors: const [
                    LengthSelector(
                      identifier: "days",
                      start: 0,
                      initialItemIndex: 1,
                      unit: "days",
                      end: 7,
                    ),
                    LengthSelector(
                      start: 0,
                      identifier: "hours",
                      unit: "hours",
                      end: 23,
                    ),
                    LengthSelector(
                      start: 0,
                      unit: "min",
                      identifier: "min",
                      end: 59,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Choice extends StatefulWidget {
  Choice({
    Key? key,
    required this.index,
    required this.updateChoice,
  }) : super(key: key);

  final int index;
  final Function updateChoice;

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  @override
  int charLength = 0;

  Widget build(BuildContext context) {
    String uid = const Uuid().v4();
    TextEditingController _controller = TextEditingController();

    return SizedBox(
      height: 50,
      width: 327,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: Color.fromARGB(70, 158, 158, 158),
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    charLength = value.length;
                  });
                  widget.updateChoice(widget.index, value);
                  print(charLength);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 8.0,
                    bottom: 8.0,
                    top: 8.0,
                  ),
                  hintText: "Choice ${widget.index.toString()}",
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 158, 158, 158),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 158, 158, 158),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                (25 - charLength).toString(),
                style: TextStyle(
                  color: 25 - charLength >= 0
                      ? const Color.fromARGB(70, 158, 158, 158)
                      : Color.fromARGB(255, 173, 23, 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
