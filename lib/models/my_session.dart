import 'package:saint_schoolparent_pro/models/parent.dart';

class MySession {
  static final MySession _session = MySession._internal();

  int page = 0;
  bool? isAuthorized;
  Parent? parent;

  factory MySession() {
    return _session;
  }

  MySession._internal();
}
