import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';

import 'package:saint_schoolparent_pro/screens/bottomrouter.dart';
import 'package:saint_schoolparent_pro/screens/loginpage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return StreamBuilder<Parent>(
              stream: ParentController.getProfileStream(),
              builder: (BuildContext context, AsyncSnapshot<Parent> snapshot) {
                printError(info: snapshot.connectionState.toString());
                if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                  Parent parent = snapshot.data!;
                  return BottomRouter(parent: parent);
                }
                if (snapshot.hasError) {
                  printInfo(info: "I am here");
                  return Center(
                      child: AlertDialog(
                    title: const Text("Error occured"),
                    content: Text(snapshot.error.toString()),
                  ));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else {
            return const LoginPage();
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
  }
}
