import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/models/appointment.dart';
import 'package:saint_schoolparent_pro/screens/formController/appointment_form_controller.dart';
import 'package:saint_schoolparent_pro/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range/time_range.dart';

import '../models/biodata.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key, this.appointment}) : super(key: key);

  final Appointment? appointment;

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // int? _value = 1;
  // ignore: unused_field

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      controller = AppointmentFormController.fromAppointment(widget.appointment!);
    } else {
      controller = AppointmentFormController(parent: parentController.parent);
    }
  }

  late AppointmentFormController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make Appointment',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Subject",
                style: getText(context).titleLarge,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controller.purpose,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Responsible person',
            //     style: getText(context).titleLarge,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     elevation: 2,
            //     child: ListTile(
            //       title: const Text('Subject'),
            //       subtitle: const Text('Subject'),
            //       trailing: CircleAvatar(
            //         child: Image.network('https://cdn-icons-png.flaticon.com/512/949/949666.png'),
            //       ),
            //     ),
            //   ),
            // ),
            const Divider(),
            ListTile(
              title: Text(
                'Date',
                style: getText(context).titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfDateRangePicker(
                    initialSelectedDate: controller.date,
                    minDate: DateTime.now(),
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs date) {
                      if (kDebugMode) {
                        print(date.value);
                      }
                      setState(() {
                        controller.date = date.value;
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Time',
                    style: getText(context).titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      controller.fromTime = range?.start ?? controller.fromTime;
                      controller.toTime = range?.end ?? controller.toTime;
                    }),
                  ),
                ),
                const SizedBox(height: 30),
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
                        if (appointment.date.isBefore(DateTime.now())) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter a future date or time")));
                        } else {
                          appointment.add().then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message)));
                            Navigator.of(context).pop();
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
