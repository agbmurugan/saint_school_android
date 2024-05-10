import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> get parents => firestore.collection('parents');
Query<Map<String, dynamic>> get children =>
    firestore.collection('students').where('parent', arrayContains: sessionController.session.parent!.icNumber);
CollectionReference<Map<String, dynamic>> get students => firestore.collection('students');
final CollectionReference<Map<String, dynamic>> queueRef = firestore.collection('NewQueue');
