library chatroom.models.message;

import "user.dart";
import 'dart:convert';

class Message {

  User sender;
  String text;
  List<User> connectedClients;

  Message(this.text, {User this.sender, List<User> this.connectedClients : const []});

  Message.fromJson(Map json) {
    this
      ..text = json["text"]
      ..sender = json.containsKey("sender") ? new User.fromJson(JSON.decode(json["sender"])) : null
      ..connectedClients = json.containsKey("connectedClients") ? json["connectedClients"].map((String clientJson) => new User.fromJson(JSON.decode(clientJson))) : const [];
  }

  String toJson() {
    Map json = {
        "text": text,
        "connectedClients": connectedClients
    };

    if (sender != null) {
      json["sender"] = sender;
    }

    return JSON.encode(json);
  }

}