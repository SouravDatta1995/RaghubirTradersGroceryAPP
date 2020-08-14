class UserData {
  int phoneNumber, id;
  String name, address;
  UserData({this.phoneNumber, this.name, this.id, this.address});
  UserData.fromJSON(Map<String, dynamic> json)
      : this.phoneNumber = json["Number"],
        this.name = json["Name"],
        this.id = json["id"],
        this.address = json["Address"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Number'] = this.phoneNumber;
    data['Name'] = this.name;
    data['Address'] = this.address;
    return data;
  }
}
