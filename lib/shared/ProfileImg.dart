import 'package:flutter/material.dart';

import '../acount/acount.dart';
import '../services/models.dart';

String defaultImageURL =
    "https://firebasestorage.googleapis.com/v0/b/portfolio-dedd9.appspot.com/o/a048fe1b-b000-40ee-b8ad-e3708f0e66ed?alt=media&token=4b4e1412-2e6f-44fe-8412-a5382c660bab";

class ProfileImg extends StatelessWidget {
  const ProfileImg(
      {Key? key, required this.profileImg, required this.size, this.report})
      : super(key: key);

  final String profileImg;
  final UserData? report;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: report != null
          ? () {
              print("here");

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Account(
                    user: report!,
                  ),
                ),
              );
            }
          : null,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(300.0)),
          child: Image.network(
            fit: BoxFit.fill,
            profileImg != "" || profileImg != null
                ? profileImg
                : defaultImageURL,
            width: size.width,
            height: size.height,
          ),
        ),
      ),
    );
  }
}
