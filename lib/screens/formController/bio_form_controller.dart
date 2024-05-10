import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/biodata.dart';

enum Provide { network, memory, logo }

class BioFormController {
  final name = TextEditingController();
  final lastName = TextEditingController();
  final icNumber = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final addressLine1 = TextEditingController();
  final addressLine2 = TextEditingController();
  String? state;
  String? city;
  final primaryPhone = TextEditingController();
  final secondaryPhone = TextEditingController();
  // final imageUrl = TextEditingController();
  Gender gender = Gender.unspecified;
  String? image;

  Provide show = Provide.logo;
  ImageProvider getAvatar() {
    if (fileData != null) {
      return FileImage(fileData!);
    } else if (image != null) {
      return NetworkImage(image!);
    } else {
      return const AssetImage('assets/logo.png');
    }
  }

  File? fileData;

  Future chooseFile() async {
    var xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      fileData = File(xfile.path);
    }
  }

  clear() {
    name.clear();
    lastName.clear();
    icNumber.clear();
    email.clear();
    address.clear();
    addressLine1.clear();
    addressLine2.clear();
    city = null;
    state = null;
    primaryPhone.clear();
    secondaryPhone.clear();
    gender = Gender.unspecified;
    image = null;
    fileData = null;
  }
}
