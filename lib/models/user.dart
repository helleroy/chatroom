library chatroom.models.user;

class User {

  String id, name;

  User(this.id, {this.name});

  User.fromJSON(Map json) {
    this.id = json["id"];
    this.name = json["name"];
  }
}