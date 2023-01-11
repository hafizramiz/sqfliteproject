class User {
  final int id;
  final String user_name;
  final String password;
  final String user_type;

  User(
      {required this.id,
      required this.user_name,
      required this.password,
      required this.user_type});

  Map<String, dynamic> toJson() {
    return {
      "user_name": this.user_name,
      "password": this.password,
      "user_type": this.user_type
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : this.id = json["id"],
        this.user_name = json["user_name"],
        this.password = json["password"],
        this.user_type = json["user_type"];
}
