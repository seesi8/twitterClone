import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/firestore.dart';
import 'package:uuid/uuid.dart';

import '../services/models.dart';

class VoteablePoll extends StatefulWidget {
  VoteablePoll(
      {Key? key, required this.poll, required this.date, required this.id})
      : super(
          key: key,
        );

  final Poll poll;
  final DateTime date;
  final String id;
  @override
  State<VoteablePoll> createState() => _VoteablePollState();
}

class _VoteablePollState extends State<VoteablePoll> {
  num _maxChoices = 4;
  bool pollLengthInputOpen = false;
  bool valid = false;
  LengthTime lengthTime = LengthTime(hours: 0, days: 1, min: 0);
  @override
  Widget build(BuildContext context) {
    int totalVotes = 1;
    int highestVotes = 0;

    widget.poll.choices.forEach((element) {
      totalVotes += element.values.toList()[0] as int;
    });

    widget.poll.choices.forEach((element) {
      if (element.values.toList()[0] as int > highestVotes) {
        highestVotes = element.values.toList()[0] as int;
      }
    });

    bool isResultingDateInThePast(LengthTime lengthTime, DateTime dateTime) {
      DateTime resultingDateTime = dateTime.add(Duration(
        days: lengthTime.days.toInt(),
        hours: lengthTime.hours.toInt(),
        minutes: lengthTime.min.toInt(),
      ));
      return resultingDateTime.isBefore(DateTime.now());
    }

    UserData report = Provider.of<UserData>(context);
    return SizedBox(
      height: (widget.poll.choices.length * 50) + 14,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widget.poll.choices.asMap().entries.map(
            (
              choice,
            ) {
              int? votedFor = widget.poll.voters
                          .where((element) => element.user == report.id)
                          .toList()
                          .length >
                      0
                  ? widget.poll.voters
                      .where((element) => element.user == report.id)
                      .toList()[0]
                      .choice
                  : null;

              Widget item = isResultingDateInThePast(
                          widget.poll.lengthTime, widget.date) ||
                      votedFor != null
                  ? Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1.5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: choice.value.values.toList()[0] !=
                                      highestVotes
                                  ? Color.fromARGB(70, 158, 158, 158)
                                  : Color.fromARGB(255, 21, 178, 199),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            width: choice.value.values.toList()[0] == 0
                                ? 10
                                : (choice.value.values.toList()[0] /
                                        totalVotes) *
                                    300,
                            height: 45,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '  ${choice.value.keys.toList()[0]}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  choice.key == votedFor
                                      ? Center(
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 15,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  '${((choice.value.values.toList()[0] / totalVotes) * 100) != 1 / 0 ? ((choice.value.values.toList()[0] / totalVotes) * 100).toInt() : 0}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirestoreService().AddToPoll(
                                choice.value.keys.toList()[0],
                                widget.id,
                                report.id,
                                choice.key);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              '${choice.value.keys.toList()[0]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.lightBlue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );

              return item;
            },
          ).toList(),
        ),
      ),
    );
  }
}
