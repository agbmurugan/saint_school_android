import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

import '../../models/appointment.dart';
import '../../models/parent.dart';

class AppointmentFormController {
  DateTime date = DateTime.now();
  String? id;
  TextEditingController purpose = TextEditingController();
  AppointmentStatus status = AppointmentStatus.pending;
  TimeOfDay fromTime = const TimeOfDay(hour: 14, minute: 50);
  TimeOfDay toTime = const TimeOfDay(hour: 15, minute: 20);
  String? approvedBy;

  bool parentApproval = true;
  String? raisedBy;
  String? location;
  List<dynamic> participants = [];

  final Parent parent;
  final bool adminApproval;
  AppointmentFormController({required this.parent, this.adminApproval = false});

  TimeRangeResult get timeRange => TimeRangeResult(
        fromTime,
        toTime,
      );

  Appointment get appointment => Appointment(
        date: DateTime(date.year, date.month, date.day, fromTime.hour, fromTime.minute),
        status: status,
        location: location,
        participants: participants,
        purpose: purpose.text,
        fromTime: fromTime,
        toTime: toTime,
        parent: parent,
        adminApproval: adminApproval,
        approvedBy: approvedBy,
        id: id,
        parentApproval: parentApproval,
        raisedBy: raisedBy,
      );

  factory AppointmentFormController.fromAppointment(Appointment appointment) {
    var controller = AppointmentFormController(parent: appointment.parent, adminApproval: appointment.adminApproval);
    controller.date = appointment.date;
    controller.id = appointment.id;
    controller.purpose.text = appointment.purpose;
    controller.fromTime = appointment.fromTime;
    controller.toTime = appointment.toTime;
    controller.approvedBy = appointment.approvedBy;
    controller.parentApproval = appointment.parentApproval;
    controller.raisedBy = appointment.raisedBy;
    controller.participants = appointment.participants;

    return controller;
  }
}
