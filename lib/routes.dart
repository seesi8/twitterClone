import 'package:spark/home/home.dart';

import 'create/create.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/create': (context) => Create(),
};
