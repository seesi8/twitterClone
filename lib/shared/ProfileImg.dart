import 'package:flutter/material.dart';

import '../services/models.dart';

String defaultImageURL =
    "https://firebasestorage.googleapis.com/v0/b/portfolio-dedd9.appspot.com/o/35779ab8-16bb-461b-9145-8b063f53f492?alt=media&token=bb07ebab-0447-4376-a913-4034907caa80";

class ProfileImg extends StatelessWidget {
  const ProfileImg({Key? key, required this.report, required this.size})
      : super(key: key);

  final UserData report;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(300.0)),
        child: Image.network(
          fit: BoxFit.fill,
          report.profileIMG,
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}
