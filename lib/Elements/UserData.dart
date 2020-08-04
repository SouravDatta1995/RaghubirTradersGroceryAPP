class UserData {
  int phoneNumber, id;
  String name;
  UserData({this.phoneNumber, this.name, this.id});
  UserData.fromJSON(Map<String, dynamic> json)
      : this.phoneNumber = json["Number"],
        this.name = json["Name"],
        this.id = json["id"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Number'] = this.phoneNumber;
    data['Name'] = this.name;
    return data;
  }
}
