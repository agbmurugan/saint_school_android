import 'biodata.dart';
import 'parent.dart';

class Student extends Bio {
  Student({
    required String icNumber,
    required this.studentClass,
    required this.section,
    required String name,
    required String email,
    required Gender gender,
    required this.father,
    required this.guardian,
    required this.mother,
    String? address,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? imageUrl,
    String? lastName,
    String? primaryPhone,
    String? secondaryPhone,
    String? state,
    bool? IsActive,
  }) : super(
          name: name,
          email: email,
          entityType: EntityType.student,
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
          isActive: IsActive
        );

  String studentClass;
  String section;

  Parent? father;
  Parent? mother;
  Parent? guardian;

  List<String> get parents {
    List<String> result = [];
    if (father != null) {
      result.add(father!.icNumber);
    }
    if (mother != null) {
      result.add(mother!.icNumber);
    }
    if (guardian != null) {
      result.add(guardian!.icNumber);
    }
    return result;
  }

  Bio get bio => this;
  factory Student.fromJson(Map<String, dynamic> json) => Student(
  icNumber: json["icNumber"] ?? '', // provide a default empty string
  name: json["name"] ?? '', // provide a default empty string
  email: json["email"] ?? '', // provide a default empty string
  gender: json["gender"] == null ? Gender.male : Gender.values.elementAt(json["gender"]),
  address: json["address"] ?? '', // provide a default empty string
  addressLine1: json["addressLine1"] ?? '', // provide a default empty string
  addressLine2: json["addressLine2"] ?? '', // provide a default empty string
  city: json["city"] ?? '', // provide a default empty string
  imageUrl: json["imageUrl"] ?? '', // provide a default empty string
  lastName: json["lastName"] ?? '', // provide a default empty string
  primaryPhone: json["primaryPhone"] ?? '', // provide a default empty string
  secondaryPhone: json["secondaryPhone"] ?? '', // provide a default empty string
  state: json["state"] ?? '', // provide a default empty string
  father: json["father"] != null ? Parent.fromJson(json['father']) : null,
  guardian: json["guardian"] != null ? Parent.fromJson(json['guardian']) : null,
  mother: json["mother"] != null ? Parent.fromJson(json['mother']) : null,
  studentClass: json["studentClass"] ?? '', // provide a default empty string
  section: json["section"] ?? '', // provide a default empty string
  IsActive: json["isActive"] ?? true // provide a default true value
);


  Map<String, dynamic> toJson() => {
        "ic": icNumber,
        "name": name,
        "email": email,
        "gender": gender.index,
        "entityType": entityType.index,
        "address": address,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "imageUrl": imageUrl,
        "lastName": lastName,
        "primaryPhone": primaryPhone,
        'secondaryPhone': secondaryPhone,
        "state": state,
        "search": search,
        "nonHyphenIcNumber": nonHyphenIcNumber,
        //------------
        "father": father?.toJson(),
        "mother": mother?.toJson(),
        "guardian": guardian?.toJson(),
        //------------
        "class": studentClass,
        "section": section,
        //------------
        "parents": parents,
        "isActive":isActive
      };
}
