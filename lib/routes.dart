import 'package:spark/account/account.dart';
import 'package:spark/acount/acount.dart';
import 'package:spark/home/home.dart';
import 'package:spark/settings/SecuirtyAA/SecuirtyAA.dart';
import 'package:spark/settings/YourAccont/AccountInformation/AccountInformation.dart';
import 'package:spark/settings/YourAccont/YourAccont.dart';
import 'package:spark/settings/YourAccont/changePassword/changePassword.dart';
import 'package:spark/settings/settings.dart';
import 'package:spark/topics/topics.dart';

import 'account/confirm/confirm.dart';
import 'create/create.dart';
import 'settings/SecuirtyAA/tfa/tfa.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/createAccount': (context) => CreateAccount(),
  '/topics': (context) => Topics(),
  '/create': (context) => const Create(),
  '/settings': (context) => const Settings(),
  '/settings/yourAccont': (context) => const YourAccont(),
  '/settings/yourAccont/account': (context) => const AccountInfo(),
  '/settings/yourAccont/changePassword': (context) => const ChangePassword(),
  '/settings/secuirtyAA': (context) => const SecuirtyAA(),
  '/settings/secuirtyAA/tfa': (context) => const TFA(),
};
