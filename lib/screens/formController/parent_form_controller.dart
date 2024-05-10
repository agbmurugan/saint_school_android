import 'package:get/get_utils/get_utils.dart';
import 'package:flutter/material.dart';
import '../../models/biodata.dart';
import '../../models/parent.dart';
import 'bio_form_controller.dart';

enum Provide { network, memory, logo }

class ParentFormController with BioFormController {
  ParentFormController();
  List<TextEditingController> children = [];
  EntityType entityType = EntityType.parent;
  String? uid;

  @override
  clear() {
    children = [];
    uid = null;
    super.clear();
  }

  Parent? get parent => icNumber.text.isEmpty
      ? null
      : Parent(
          name: name.text,
          icNumber: icNumber.text.toUpperCase().removeAllWhitespace,
          email: email.text,
          imageUrl: image,
          addressLine1: addressLine1.text,
          addressLine2: addressLine2.text,
          city: city,
          primaryPhone: primaryPhone.text,
          secondaryPhone: secondaryPhone.text,
          address: addressLine1.text,
          gender: gender,
          lastName: lastName.text,
          state: state,
          //------------------------
          children: children.map((e) => e.text).toList(),
          uid: uid,
        );

  copyWith(Parent parent) {
    name.text = parent.name;
    icNumber.text = parent.icNumber;
    image = parent.imageUrl;
    state = parent.state;
    email.text = parent.email ?? '';
    addressLine1.text = parent.addressLine1 ?? '';
    addressLine2.text = parent.addressLine2 ?? '';
    city = parent.city;
    gender = parent.gender;
    primaryPhone.text = parent.primaryPhone ?? '';
    secondaryPhone.text = parent.secondaryPhone ?? '';
    children = parent.children.map((e) => TextEditingController(text: e)).toList();
    uid = parent.uid;
  }

  factory ParentFormController.fromParent(Parent parent) {
    ParentFormController controller = ParentFormController();
    controller.name.text = parent.name;
    controller.icNumber.text = parent.icNumber;
    controller.image = parent.imageUrl;
    controller.state = parent.state;
    controller.city = parent.city;
    controller.email.text = parent.email;
    controller.addressLine1.text = parent.addressLine1 ?? '';
    controller.addressLine2.text = parent.addressLine2 ?? '';
    controller.city = parent.city;
    controller.gender = parent.gender;
    controller.primaryPhone.text = parent.primaryPhone ?? '';
    controller.secondaryPhone.text = parent.secondaryPhone ?? '';
    controller.children = parent.children.map((e) => TextEditingController(text: e)).toList();
    controller.uid = parent.uid;
    return controller;
  }
}
