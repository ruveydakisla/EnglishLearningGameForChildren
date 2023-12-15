class Users {
  String? mail;
  String? name;
  String? password;

  Users({this.mail, this.name, this.password});

  Users.fromJson(Map<String, dynamic> json) {
    mail = json['mail'];
    name = json['name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mail'] = mail;
    data['name'] = name;
    data['password'] = password;
    return data;
  }
}
