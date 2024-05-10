import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/landing_page.dart';
import 'package:saint_schoolparent_pro/screens/bottomrouter.dart';

import '../theme.dart';
import 'ic_verification_page.dart';

class Studentverification extends StatefulWidget {
  const Studentverification({Key? key}) : super(key: key);

  @override
  State<Studentverification> createState() => _StudentverificationState();
}

class _StudentverificationState extends State<Studentverification> {
  bool isVisible = true;

  final studenIc = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Verification'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: getHeight(context) * 0.01,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    height: getHeight(context) * 0.20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Verify your child\'s IC NO',
                    style: getText(context).headline6,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    prefixIcon: const Icon(Icons.perm_contact_cal),
                    controller: studenIc,
                    hintText: 'Student IC NO',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: getHeight(context) * 0.10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                      )),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          var result = parentController.verifyChild(studenIc.text);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FutureBuilder<bool>(
                                  future: result,
                                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                                      var value = snapshot.data;
                                      if (value ?? false) {
                                        return AlertDialog(
                                          title: const Text("Student Added Successfully"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.offAll(() => const LandingPage());
                                                },
                                                child: const Text("Okay")),
                                          ],
                                        );
                                      } else {
                                        return AlertDialog(
                                          title: const Text("Student Could not be added"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Okay")),
                                          ],
                                        );
                                      }
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
                              });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
                        child: const Text('Verify'),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
