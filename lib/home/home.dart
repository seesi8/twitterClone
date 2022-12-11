import 'package:flutter/material.dart';

import '../login/login.dart';
import '../services/auth.dart';
import '../sparks/sparks.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else if (snapshot.hasData) {
          // AuthService().signOut();
          return const Sparks();
        } else {
          return const Login();
        }
      },
    );
  }
}
