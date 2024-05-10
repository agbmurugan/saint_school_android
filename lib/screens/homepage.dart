import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/controllers/queue.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/student.dart';
import 'package:saint_schoolparent_pro/screens/studentverificationpage.dart';
import 'package:saint_schoolparent_pro/theme.dart';

import '../models/queue.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                auth.signOut();
              }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: () {
                  Get.to(() => const Studentverification());
                },
                icon: const Icon(Icons.person_add),
              ),
            )
          ],
        ),
        body: GetBuilder(
            init: parentController,
            builder: (context) {
              List<String> children = parentController.parent.children;

              if (children.isEmpty) {
                return const Center(child: Text("No Children added"));
              } else {
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: students.where('ic', whereIn: children).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    printInfo(info: snapshot.connectionState.toString());
                    if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                      var docs = snapshot.data!.docs;
                      var students = docs.map((e) => Student.fromJson(e.data())).toList();
                      print(students.map((e) => e.toJson()).toList());
                      Get.put(QueueListController());
                      return ListView.builder(
                          itemCount: students.length,
                          itemBuilder: ((context, index) {
                            var student = students[index];

                            return StudentTile(student: student);
                          }));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }
            }));
  }
}

class StudentTile extends StatefulWidget {
  const StudentTile({
    Key? key,
    required this.student,
  }) : super(key: key);

  final Student student;

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  @override
  void initState() {
    super.initState();
  }

  QueueListController get controller => queueLitsController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: const Color(0xFFF5F5F5),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: SizedBox(
                height: getHeight(context) * 0.285,
                width: getWidth(context) * 0.95,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: getWidth(context) * 0.15,
                                  backgroundImage: const AssetImage('assets/logo.png'),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                                      backgroundColor: MaterialStateProperty.all(const Color(0XFF48B253))),
                                  onPressed: controller.getQueue(widget.student.icNumber)?.queueStatus != null
                                      ? null
                                      : () {
                                          controller.pushToQueue(widget.student);
                                        },
                                  child: const Text('Pickup')),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              enabled: true,
                              title: Text(
                                widget.student.name,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              trailing: SizedBox(
                                height: getHeight(context) * 0.03,
                                width: getWidth(context) * 0.18,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiaryContainer),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                                  ),
                                  onPressed: () {},
                                  // child: const Text("Button"),
                                  child: Text(
                                    controller.getQueue(widget.student.icNumber)?.queueStatus == null
                                        ? "0:00"
                                        : controller.getQueue(widget.student.icNumber)?.queueStatus == QueueStatus.waiting
                                            ? "0.00"
                                            : "0:${(controller.countdown[widget.student.icNumber] ?? 0).toString().padLeft(2, '0')}",
                                    // : controller.countDown[].toString().padLeft(2, '0'),
                                    style: getText(context).labelSmall,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Table(
                                columnWidths: <int, TableColumnWidth>{
                                  0: FixedColumnWidth(getWidth(context) * 0.05),
                                  1: FixedColumnWidth(getWidth(context) * 0.40),
                                  2: FixedColumnWidth(getWidth(context) * 0.20)
                                },
                                children: [
                                  TableRow(decoration: const BoxDecoration(), children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        width: 10,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text('Attendance'),
                                    ),
                                    const Text('79' '%')
                                  ]),
                                  TableRow(decoration: const BoxDecoration(), children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        width: 10,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text('In Time'),
                                    ),
                                    const Text('9:30 Am')
                                  ]),
                                  TableRow(decoration: const BoxDecoration(), children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        width: 10,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text('Out Time'),
                                    ),
                                    const Text('5:30 PM')
                                  ]),
                                  TableRow(decoration: const BoxDecoration(), children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        width: 10,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text('Breakfast'),
                                    ),
                                    const Text('Taken')
                                  ]),
                                  TableRow(decoration: const BoxDecoration(), children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        width: 10,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text('Lunch'),
                                    ),
                                    const Text('Not Taken')
                                  ]),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
