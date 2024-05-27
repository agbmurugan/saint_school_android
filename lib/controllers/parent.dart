import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/appointment.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/models/result.dart';
import 'package:saint_schoolparent_pro/models/student.dart';
import 'auth.dart';

class ParentController extends GetxController {
  ParentController({required this.parent});
  final Parent parent;

  static ParentController instance = Get.find();

  @override
  void onInit() {
    listenParent();
    sessionController.session.parent = parent;
    super.onInit();
  }

  List<Student> children = [];

  listenParent() {
    parents.doc(parent.icNumber).snapshots().listen((event) {
      if (event.exists) {
        var tempParent = Parent.fromJson(event.data()!);
        parent.copyWith(tempParent);
        update();
      }
    });
  }

  loadChildren() {
    students.where('icNumber', arrayContainsAny: parent.children).get().then((event) {
      children = event.docs.map((e) => Student.fromJson(e.data())).toList();
      update();
    });
  }

//   Future<bool> verifyChild(String child) async {
//   print(parent.icNumber);
//   print("parent No");
//   print("$child child no");

//   // Fetch the documents from the 'students' collection
//   var querySnapshot = await students.where('parents', arrayContains: parent.icNumber).get();

//   // Debugging: print the number of documents found
//   print("${querySnapshot.docs.length} documents found");

//   // Extract the children IC numbers from the query results
//   var childrenIcs = querySnapshot.docs.map((doc) {
//     var data = doc.data();
//     // Debugging: print the raw data of each document
//     print("Document data: $data");

//     // Ensure data is a Map<String, dynamic>
//     if (data is Map<String, dynamic>) {
//       // Debugging: try to parse the Student object and catch any errors
//       try {
//         return Student.fromJson(data).icNumber;
//       } catch (e) {
//         print("Error parsing Student from document data: $e");
//         return null;
//       }
//     } else {
//       print("Data is not a Map<String, dynamic>");
//       return null;
//     }
//   }).where((icNumber) => icNumber != null).toList();

//   // Debugging: print the list of children IC numbers
//   print("Children IC numbers: $childrenIcs");

//   // Check if the provided child IC number is in the list
//   if (childrenIcs.contains(child)) {
//     if (parent.children.contains(child)) {
//       print("Child already added");
//       return false;
//     } else {
//       parent.children.add(child);

//       // Update the parent document in the 'parents' collection
//       await parents.doc(parent.icNumber).update(parent.toJson());
//       return true;
//     }
//   } else {
//     print("Child not found in the children IC numbers");
//     return false;
//   }
// }
Future<String> verifyChild(String child) async {
  print(parent.icNumber);
  print("parent No");
  print("$child child no");

  // Fetch the documents from the 'students' collection
  var querySnapshot = await students.where('parents', arrayContains: parent.icNumber).get();

  // Debugging: print the number of documents found
  print("${querySnapshot.docs.length} documents found");

  // Extract the children IC numbers from the query results
  var childrenIcs = querySnapshot.docs.map((doc) {
    var data = doc.data();
    // Debugging: print the raw data of each document
    print("Document data: $data");

    // Ensure data is a Map<String, dynamic>
    if (data is Map<String, dynamic>) {
      // Debugging: try to parse the Student object and catch any errors
      try {
        return Student.fromJson(data).icNumber;
      } catch (e) {
        print("Error parsing Student from document data: $e");
        return null;
      }
    } else {
      print("Data is not a Map<String, dynamic>");
      return null;
    }
  }).where((icNumber) => icNumber != null).toList();

  // Debugging: print the list of children IC numbers
  print("Children IC numbers: $childrenIcs");

  // Check if the provided child IC number is in the list
  if (childrenIcs.contains(child)) {
    if (parent.children.contains(child)) {
      print("Child already added");
      return "Child already added";
    } else {
      parent.children.add(child);

      // Update the parent document in the 'parents' collection
      await parents.doc(parent.icNumber).update(parent.toJson());
      return "Student Added Successfully";
    }
  } else {
    print("Child not found in the children IC numbers");
    return "Child not found in the children IC numbers";
  }
}





  Stream<List<Appointment>> streamAppointments() {
    return firestore.collection('appointments').where("parent.icNumber", isEqualTo: parent.icNumber).snapshots().map(
        (event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.id)).where((element) => element.date.isAfter(DateTime.now())).toList());
  }

  Stream<List<Appointment>> streamFinishedAppointments() {
    return firestore.collection('appointments').where("parent.icNumber", isEqualTo: parent.icNumber).snapshots().map(
        (event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.id)).where((element) => element.date.isBefore(DateTime.now())).toList());
  }

  static Stream<Parent> getProfileStream() {
    return parents.where("uid", isEqualTo: auth.uid).snapshots().map((event) => event.docs.map((e) => Parent.fromJson(e.data())).first);
  }

  static Future<void> registerParent(Parent parent) {
    return parents.doc(parent.icNumber).set(parent.toJson());
  }

  static Future<dynamic> getParent(String icNumber) async {
  var trimmedicNumber = icNumber.replaceAll(" ", "").replaceAll("-", "");
  try {
    var querySnapshot = await parents.where("nonHyphenIcNumber", isEqualTo: trimmedicNumber).limit(1).get();
    if (querySnapshot.docs.isEmpty) {
      return "Parent not found for the given IC number.";
    } else {
      return Parent.fromJson(querySnapshot.docs.first.data());
    }
  } catch (e) {
    return "An error occurred: ${e.toString()}";
  }
}



  static addParent(Parent parentData) {
    parents.doc(parentData.icNumber).set(parentData.toJson()).then((value) => Result.success("Parent added successflly"));
  }

  static Stream<List<Student>> streamChildrenByParent({required String parent}) {
    return students.where("parents", arrayContains: parent).snapshots().map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());
  }

  static Future<List<Student>> loadChildrenByparent({required String parent}) {
    return students.where("parents", arrayContains: parent).get().then((value) => value.docs.map((e) => Student.fromJson(e.data())).toList());
  }

  // Method to add password to parent document
  static Future<void> addPasswordToParent(String parentIcNumber, String password) {
    return parents.doc(parentIcNumber).update({'password': password});
  }
  static Future<void> addPasswordToParentVsEmail(String email, String newPassword) async {
  try {
    QuerySnapshot snapshot = await parents.where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      var docRef = snapshot.docs.first.reference;
      // Assume newPassword is hashed or managed securely
      await docRef.update({'password': newPassword});
    } else {
      print("No parent found with the email: $email");
    }
  } catch (e) {
    print("Failed to update password: $e");
    throw Exception("Error updating password for email $email: $e");
  }
}

}

ParentController parentController = ParentController.instance;
