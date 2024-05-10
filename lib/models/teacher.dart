import 'biodata.dart';

class Teacher extends Bio {
  Teacher({required this.className, required this.section, required email, required icNumber, required name, required gender})
      : super(email: email, entityType: EntityType.teacher, icNumber: icNumber, name: name, gender: gender);

  String className;
  String section;

  // TeacherController get controller => TeacherController(this);

  factory Teacher.fromJson(json) => Teacher(
        gender: json["gender"],
        className: json["className"],
        section: json["section"],
        email: json["email"],
        icNumber: json["icNumber"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {"className": className, "section": section};
    map.addAll(super.toBioJson());
    return map;
  }
}
