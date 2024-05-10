import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/models/appointment.dart';
import 'package:saint_schoolparent_pro/screens/appointment_bottom_sheet_time.dart';
import 'package:saint_schoolparent_pro/screens/appointmetpage.dart';
import 'package:saint_schoolparent_pro/theme.dart';

import '../models/biodata.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: TabBar(
              tabs: [
                Tab(
                  child: Text('Upcoming'),
                ),
                Tab(
                  child: Text('Completed'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const AppointmentPage());
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Appointment>>(
                  stream: parentController.streamAppointments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                      List<Appointment> appointments = snapshot.data!;
                      if (appointments.isEmpty) {
                        return const Center(
                          child: Text("No Pending appointments"),
                        );
                      }
                      return ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            return AppointmentTile(appointment: appointments[index]);
                          });
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Appointment>>(
                  stream: parentController.streamFinishedAppointments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                      List<Appointment> appointments = snapshot.data!;
                      return ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            print("rebuild");
                            return AppointmentTile(appointment: appointments[index]);
                          });
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  String getUrl(EntityType type) {
    switch (type) {
      case EntityType.student:
        return 'https://cdn-icons-png.flaticon.com/512/3829/3829933.png';

      case EntityType.teacher:
        return 'https://cdn-icons-png.flaticon.com/512/4696/4696727.png';

      case EntityType.parent:
        return 'https://cdn-icons-png.flaticon.com/512/780/780270.png';

      case EntityType.admin:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.png'
                      ''),
                ),
                title: Text(appointment.purpose),
                trailing: SizedBox(
                  width: getWidth(context) * 0.3,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: appointment.status == AppointmentStatus.approved ? Colors.greenAccent : Colors.blue,
                        ),
                      ),
                      Text(
                        appointment.status.toString().split('.').last.toUpperCase(),
                        style: getText(context).bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Meeting Requested By : ${appointment.raisedBy == parentController.parent.icNumber ? "You" : "Admin"}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/3652/3652191.png',
                        height: 32,
                      ),
                    ),
                    // title: Text("${appointment.date.day}/${appointment.date.month}/${appointment.date.year}"),
                    title: Text(appointment.date.toString()),
                    subtitle: Text("${appointment.fromTime.format(context)} : ${appointment.toTime.format(context)}"),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    children: [
                      appointment.participants.isEmpty
                          ? const Center(
                              child: Text("No Participants"),
                            )
                          : Wrap(
                              alignment: WrapAlignment.start,
                              children: appointment.participants
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Chip(
                                          avatar: CircleAvatar(
                                            child: Image.network(
                                              getUrl(e.entityType),
                                              height: getHeight(context) * 0.03,
                                            ),
                                          ),
                                          label: Text(
                                            (e as Bio).name,
                                          ),
                                        ),
                                      ))
                                  .toList()),
                    ],
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  appointment.date.isBefore(DateTime.now())
                      ? Container()
                      : appointment.parentApproval != true
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  // backgroundColor:MaterialStateProperty.all(getColor(context).errorContainer),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                              onPressed: () {
                                appointment.parentApproval = true;
                                appointment.status = (appointment.parentApproval && appointment.adminApproval)
                                    ? AppointmentStatus.approved
                                    : AppointmentStatus.pending;
                                appointment.update();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.08),
                                child: Text('Accept', style: getText(context).bodySmall?.apply(color: Colors.white)),
                              ))
                          : Container(),
                  ElevatedButton(
                      style: ButtonStyle(
                          // backgroundColor:MaterialStateProperty.all(getColor(context).errorContainer),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                constraints: const BoxConstraints(minHeight: 800),
                                child: SingleChildScrollView(
                                  child: AppointmentTime(appointment: appointment),
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.08),
                        child: Text('Reschedule', style: getText(context).bodySmall?.apply(color: Colors.white)),
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
