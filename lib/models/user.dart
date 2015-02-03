library chatroom.models.user;
import 'dart:convert';

class User {

  String id, name;

  User(String this.id, {String this.name : ""});

  User.fromJson(Map json) {
    this.id = json["id"];
    this.name = json.containsKey("name") ? json["name"] : "";
  }

  String toJson() {
    return JSON.encode({
        "id": id,
        "name": name
    });
  }
}