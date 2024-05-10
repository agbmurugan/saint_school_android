import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/models/appointment.dart';
import 'package:saint_schoolparent_pro/screens/formController/appointment_form_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range/time_range.dart';

import '../theme.dart';

class AppointmentTime extends StatefulWidget {
  const AppointmentTime({Key? key, required this.appointment}) : super(key: key);

  final Appointment appointment;

  @override
  State<AppointmentTime> createState() => _AppointmentTimeState();
}

class _AppointmentTimeState extends State<AppointmentTime> {
  @override
  void initState() {
    controller = AppointmentFormController.fromAppointment(widget.appointment);
    super.initState();
  }

  late AppointmentFormController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Date',
              style: getText(context).titleLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfDateRangePicker(
                    minDate: DateTime.now(),
                    initialSelectedDate: controller.date,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs date) {
                      setState(() {
                        controller.date = date.value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Time',
              style: getText(context).titleLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TimeRange(
                fromTitle: Text('FROM', style: getText(context).button),
                toTitle: Text(
                  'TO',
                  style: getText(context).button,
                ),
                titlePadding: 8.0,
                textStyle: getText(context).bodySmall,
                activeTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
                borderColor: getColor(context).inversePrimary,
                activeBorderColor: getColor(context).onTertiaryContainer,
                backgroundColor: Colors.transparent,
                activeBackgroundColor: getColor(context).primary,
                firstTime: const TimeOfDay(hour: 8, minute: 00),
                lastTime: const TimeOfDay(hour: 20, minute: 00),
                initialRange: controller.timeRange,
                timeStep: 10,
                timeBlock: 10,
                onRangeCompleted: (range) => setState(() {
                  if (range != null) {
                    controller.fromTime = range.start;
                    controller.toTime = range.end;
                  }
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Text('Submit'),
                ),
                onPressed: () {
                  var appointment = controller.appointment;
                  appointment.adminApproval = false;
                  appointment.update().then((result) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
