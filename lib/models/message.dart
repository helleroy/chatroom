library chatroom.models.message;

import "user.dart";

class Message {

  User sender;
  String text;
  List<User> connectedClients;

  Message(this.text, {this.sender, this.connectedClients : const []});

  Message.fromJSON(Map json) {
    this.sender = json.containsKey("sender") ? new User.fromJSON(json["sender"]) : new User("");
    this.text = json["message"];

    this.connectedClients = json.containsKey("connectedClients") ? json["connectedClients"].map((Map clientJson) => new User.fromJSON(clientJson)) : const [];
  }
}