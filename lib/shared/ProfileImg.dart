import 'package:flutter/material.dart';

import '../services/models.dart';

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
