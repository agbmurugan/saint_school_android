import 'dart:async';

import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/student.dart';

import '../models/parent.dart';

class StudentController extends GetxController {
  StudentController(this.student);

  @override
  void onInit() {
    super.onInit();
    listenToQueue();
  }

  final Student student;
  bool inQueue = false;

  List<Parent> parents = [];

  listenToQueue() {
    queueRef.doc(student.icNumber).snapshots().listen((event) {
      if (event.exists) {
        inQueue = true;
      } else {
        inQueue = false;
      }
    });
  }

  static Stream<List<Student>> getStudents() {
    return children.snapshots().map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());
  }

  static Future<Student> getStudent(String icNumber) async {
    return students.doc(icNumber).get().then((value) => Student.fromJson(value.data()!));
  }
}
