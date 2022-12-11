import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spark/services/auth.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Icon(
            FontAwesomeIcons.boltLightning,
            color: Colors.lightBlue[300],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text(
            "See what's happening in the world right now.",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Column(
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    AuthService()
                        .googleLogin()
                        .then((value) => Navigator.pushNamed(context, "home"));
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              FontAwesomeIcons.google,
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            "Continue with Google",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                FontAwesomeIcons.apple,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Continue with Apple",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 1,
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey[600])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 1,
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey[600])),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
