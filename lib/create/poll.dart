import 'package:flutter/material.dart';

import '../services/models.dart';
import 'lengthSelector.dart';

class PollWidget extends StatefulWidget {
  const PollWidget({
    Key? key,
    required this.removePoll,
  }) : super(
          key: key,
        );

  final Function removePoll;

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  List<Widget> choices = [
    choice(index: 1),
    Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: choice(index: 2),
    ),
  ];
  num _maxChoices = 4;
  bool pollLengthInputOpen = false;
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
                    children: choices,
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
                      choices.length < _maxChoices
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.all(0),
                                  backgroundColor:
                                      Color.fromARGB(143, 158, 158, 158)),
                              onPressed: () {
                                if (choices.length < _maxChoices) {
                                  setState(() {
                                    choices.add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child:
                                            choice(index: choices.length + 1),
                                      ),
                                    );
                                  });
                                }

                                print(choices);
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
                              pollLengthInputOpen = true;
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
            pollLengthInputOpen
                ? SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: LengthSelectorGroup(
                        onItemsChanged: (Map<String, int> values) {
                          lengthTime = LengthTime(
                            days: values["days"] ?? 1,
                            hours: values["hours"] ?? 0,
                            min: values["min"] ?? 0,
                          );
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
                : Container(),
          ],
        ),
      ),
    );
  }
}

class choice extends StatelessWidget {
  const choice({
    Key? key,
    required this.index,
  }) : super(key: key);

  final num index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 327,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Choice " + index.toString(),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            borderSide: BorderSide(
              color: Color.fromARGB(70, 158, 158, 158),
              width: 1.1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            borderSide: BorderSide(
              color: Color.fromARGB(70, 158, 158, 158),
              width: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
