class Bio {
  Bio({
    required this.name,
    required this.entityType,
    required this.icNumber,
    required this.email,
    required this.gender,
    this.address,
    this.lastName,
    this.imageUrl,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.primaryPhone,
    this.secondaryPhone,
    this.state,
  });

  String name;
  String? lastName;
  EntityType entityType;
  String icNumber;
  String email;
  String? address;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? primaryPhone;
  String? secondaryPhone;
  String? imageUrl;
  Gender gender;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return icNumber == (other as Bio).icNumber;
  }

  List<String> makeSearchstring(String string) {
    List<String> list = [];
    for (int i = 1; i < string.length; i++) {
      list.add(string.substring(0, i).toLowerCase());
    }
    list.add(string.toLowerCase());
    return list;
  }

  List<String> get search {
    List<String> text = [];
    text.addAll(makeSearchstring(name));
    text.addAll(makeSearchstring(icNumber));
    text.addAll(makeSearchstring(email.split('@').first));
    return text;
  }

  String get nonHyphenIcNumber => icNumber.replaceAll('-', '');

  factory Bio.fromBioJson(json) => Bio(
        name: json["name"] ?? '',
        entityType: EntityType.values.elementAt(json["entityType"]),
        icNumber: json["icNumber"] ?? '',
        email: json["email"] ?? '',
        gender: Gender.values.elementAt(json["gender"]),
        address: json["address"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        imageUrl: json["imageUrl"],
        lastName: json["lastName"],
        primaryPhone: json["primaryPhone"],
        secondaryPhone: json["secondaryPhone"],
        state: json["state"],
      );

  Map<String, dynamic> toBioJson() => {
        "name": name,
        "lastName": lastName,
        "entityType": entityType.index,
        "icNumber": icNumber,
        "nonHyphenIcNumber": nonHyphenIcNumber,
        "email": email,
        "address": address,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "primaryPhone": primaryPhone,
        "secondaryPhone": secondaryPhone,
        "imageUrl": imageUrl,
        "gender": gender.index,
        "search": search
      };
}

enum EntityType { student, teacher, parent, admin }

enum Gender { male, female, unspecified }
