class Result {
  Result({
    required this.code,
    required this.message,
  });

  String code;
  String message;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };

  factory Result.error(error) => Result(code: "Error", message: error);
  factory Result.success(message) => Result(code: "Success", message: message);
}
