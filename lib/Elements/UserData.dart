class UserData {
  int phoneNumber, id;
  String name;
  UserData({this.phoneNumber, this.name});
  UserData.fromJSON(Map<String, dynamic> json)
      : this.phoneNumber = json["Number"],
        this.name = json["Name"],
        this.id = json["id"];
}
