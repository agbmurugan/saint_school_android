import 'biodata.dart';

class Parent extends Bio {
  Parent({
    required icNumber,
    required email,
    required name,
    required this.children,
    required gender,
    address,
    addressLine1,
    addressLine2,
    city,
    imageUrl,
    lastName,
    primaryPhone,
    secondaryPhone,
    state,
    isActive,
    password,
    this.uid,
  }) : super(
          name: name,
          email: email,
          entityType: EntityType.parent,
          icNumber: icNumber,
          address: address,
          gender: gender,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          imageUrl: imageUrl,
          lastName: lastName,
          primaryPhone: primaryPhone,
          secondaryPhone: secondaryPhone,
          state: state,
          isActive:isActive,
        );

  List<String> children;
  String? uid;

  Bio get bio => this;

  copyWith(Parent parent) {
    gender = parent.gender;
    address = parent.address;
    uid = parent.uid;
    icNumber = parent.icNumber;
    email = parent.email;
    name = parent.name;
    children = parent.children;
    addressLine1 = parent.addressLine1;
    addressLine2 = parent.addressLine2;
    state = parent.state;
    city = parent.city;
    imageUrl = parent.imageUrl;
    lastName = parent.lastName;
    primaryPhone = parent.primaryPhone;
    secondaryPhone = parent.secondaryPhone;
    isActive = parent.isActive;
  }

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        gender: Gender.values.elementAt(json["gender"]),
        address: json["address"] ?? '',
        uid: json["uid"] ?? '',
        icNumber: json["icNumber"] ?? '',
        email: json["email"] ?? '',
        name: json["name"],
        children: List<String>.from(json["children"].map((x) => x)),
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        state: json["state"],
        city: json["city"],
        imageUrl: json["imageUrl"],
        lastName: json["lastName"],
        primaryPhone: json["primaryPhone"],
        secondaryPhone: json["secondaryPhone"],
        password: json["password"],
        isActive: json["isActive"]
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {"children": children, "uid": uid};
    map.addAll(super.toBioJson());
    return map;
  }
}
