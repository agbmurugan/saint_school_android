import 'dart:async';

import 'package:saint_schoolparent_pro/models/student.dart';

class StudentQueue {
  Student student;
  QueueStatus queueStatus;
  DateTime? queuedTime;
  StudentQueue({
    required this.student,
    required this.queuedTime,
    this.queueStatus = QueueStatus.waiting,
  });

  Timer? timer;

  String get name => student.name;
  String get icNumber => student.icNumber;
  String get studentClass => student.studentClass;
  String get section => student.section;
  int? get remaingTime => queuedTime == null ? 0 : 60 - DateTime.now().difference(queuedTime!).inSeconds;

  factory StudentQueue.fromJson(json) => StudentQueue(
        student: Student.fromJson(json["student"]),
        queuedTime: json["queuedTime"]?.toDate(),
        queueStatus: QueueStatus.values.elementAt(json["queueStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "student": student.toJson(),
        "queuedTime": queuedTime,
        "queueStatus": queueStatus.index,
      };
}

enum QueueStatus { waiting, inQueue }
