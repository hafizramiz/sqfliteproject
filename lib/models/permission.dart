class Permission {
  final int id;
  final String start_date;
  final String finish_date;
  final int number_of_day;
  final int accept_status;
  final int user_id;

  Permission(
      {required this.id,
      required this.start_date,
      required this.finish_date,
      required this.number_of_day,
      required this.accept_status,
      required this.user_id});

  Map<String,dynamic>toJson(){
    return{
      "start_date":this.start_date,
      "finish_date":this.finish_date,
      "number_of_day":this.number_of_day,
      "accept_status":this.accept_status,
      "user_id":this.user_id
    };
  }

  Permission.fromJson(Map<String,dynamic>json)
    :this.id=json["id"],
    this.start_date=json["start_date"],
    this.finish_date=json["finish_date"],
    this.number_of_day=json["number_of_day"],
    this.accept_status=json["accept_status"],
    this.user_id=json["user_id"];
}
