import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spark/services/models.dart';

class Spark extends StatefulWidget {
  const Spark(Tweet tweet);

  @override
  State<Spark> createState() => _SparkState();
}

class _SparkState extends State<Spark> {
  @override
  Widget build(BuildContext context) {
    String defaultImageURL =
        "https://firebasestorage.googleapis.com/v0/b/portfolio-dedd9.appspot.com/o/b6669dc7-0a14-43dc-a98a-ec3fcf90e40c?alt=media&token=68b11277-26a4-4a2b-bd4b-48b3090f717b";
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: Image.network(defaultImageURL),
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
                            "Default Person",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            "@defualtPerson",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "-7h-",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("HI I did s tweet"),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
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
                                  "20.1k",
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
                                  "20.1k",
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
                                    FontAwesomeIcons.heart,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "20.1k",
                                  style: TextStyle(color: Colors.grey),
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
                    )
                  ],
                ),
              )
            ]),
          ),
          Divider(color: Colors.grey)
        ],
      ),
    );
  }
}
