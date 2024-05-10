import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/models/result.dart';

import '../firebase.dart';
import 'biodata.dart';

enum AppointmentStatus { pending, approved, cancelled, finished }

class Appointment {
  Appointment({
    required this.date,
    required this.status,
    this.approvedBy,
    required this.location,
    this.raisedBy,
    required this.participants,
    required this.purpose,
    required this.fromTime,
    required this.toTime,
    required this.parent,
    this.id,
    this.adminApproval = false,
    this.parentApproval = false,
  });

  DateTime date;
  String? id;
  String purpose;
  AppointmentStatus status;
  Parent parent;
  TimeOfDay fromTime;
  TimeOfDay toTime;
  String? approvedBy;
  bool adminApproval;
  bool parentApproval;
  String? raisedBy;
  String? location;
  List<dynamic> participants;

  factory Appointment.fromJson(Map<String, dynamic> json, id) => Appointment(
        id: id,
        date: json["date"].toDate(),
        status: AppointmentStatus.values.elementAt(json["status"]),
        approvedBy: json["approvedBy"],
        location: json["location"],
        participants: json["participants"].map((e) => Bio.fromBioJson(e)).toList(),
        raisedBy: json["raisedBy"],
        purpose: json["purpose"],
        fromTime: TimetoJson.fromJson(json["fromTime"]),
        toTime: TimetoJson.fromJson(json["toTime"]),
        parent: Parent.fromJson(json["parent"]),
        adminApproval: json["adminApproval"] ?? false,
        parentApproval: json["parentApproval"] ?? false,
      );

  Map<String, dynamic> toJson() {
    var json = {
      "id": id,
      "date": date,
      "status": status.index,
      "approvedBy": approvedBy,
      "location": location,
      "participants": participants.map((e) => e.toBioJson()).toList(),
      "raisedBy": raisedBy,
      "purpose": purpose,
      "fromTime": fromTime.toJson(),
      "toTime": toTime.toJson(),
      "particpantsIcs": participants.map((e) => (e as Bio).icNumber).toList(),
      "parent": parent.toJson(),
      "adminApproval": adminApproval,
      "parentApproval": parentApproval,
    };
    for (Bio element in participants) {
      json.addAll({
        element.icNumber: true,
      });
    }
    return json;
  }

  Future<Result> update() {
    return firestore
        .collection('appointments')
        .doc(id)
        .update(toJson())
        .then((value) => Result.success("Updated Successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Future<Result> add() {
    raisedBy = parent.icNumber;
    return firestore
        .collection('appointments')
        .add(toJson())
        .then((value) => Result.success("Added Successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }
}

extension TimetoJson on TimeOfDay {
  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
  static TimeOfDay fromJson(json) {
    return TimeOfDay(hour: json["hour"], minute: json["minute"]);
  }
}
