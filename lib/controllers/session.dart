import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/models/my_session.dart';

import '../models/parent.dart';

class SessionController extends GetxController {
  static SessionController instance = Get.find();

  int page = 0;
  bool get isAuthorized => auth.currentUser == null ? false : true;
  Parent? get parent => session.parent;

  @override
  void onInit() {
    session = MySession();
    super.onInit();
  }

  getChildren() {}

  late MySession session;
}

SessionController sessionController = SessionController.instance;
