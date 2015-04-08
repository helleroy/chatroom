library chatroom.models.message;

import "user.dart";
import 'dart:convert';

class Message {

  User sender;
  MessageType type;
  String text;
  List<User> connectedClients;

  Message(this.text, {MessageType this.type, User this.sender, List<User> this.connectedClients : const []});

  Message.fromJson(Map json) {
    this
      ..text = json["text"]
      ..type = json["type"] == null ? null : MessageType.values[json["type"]]
      ..sender = json.containsKey("sender") ? new User.fromJson(JSON.decode(json["sender"])) : null
      ..connectedClients = json.containsKey("connectedClients") ? json["connectedClients"].map((String clientJson) => new User.fromJson(JSON.decode(clientJson))).toList() : const [];
  }

  String toJson() {
    Map json = {
      "text": text,
      "connectedClients": connectedClients
    };

    if (sender != null) {
      json["sender"] = sender;
    }

    if (type != null) {
      json["type"] = type.index;
    }

    return JSON.encode(json);
  }
}

enum MessageType {
connect, startedWriting, stoppedWriting
}
