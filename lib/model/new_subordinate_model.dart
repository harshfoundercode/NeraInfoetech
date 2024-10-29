class NewSubordinateModel {
  String? userName;
  String? mobile;
  String? datetime;

  NewSubordinateModel({this.userName, this.mobile, this.datetime});

  NewSubordinateModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    mobile = json['mobile'];
    datetime = json['datetime'];
  }
}