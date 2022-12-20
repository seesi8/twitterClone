import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/services/firestore.dart';
import 'package:spark/spark/tweet.dart';
import 'package:spark/sparks/spark.dart';

import '../services/models.dart';

class SparkScreen extends StatelessWidget {
  const SparkScreen({super.key, required this.tweet});

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    UserData report = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Spark"),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            SparkBig(
              tweet: Future.value(tweet),
            ),
            StreamBuilder<List<Future<Tweet>>>(
                stream: FirestoreService().streamComments(report.id, tweet.id),
                builder: (context, snapshot) {
                  return Column(
                    children:
                        snapshot.data?.map((e) => Spark(tweet: e)).toList() ??
                            [Container()],
                  );
                })
          ],
        ),
      ),
    );
  }
}
