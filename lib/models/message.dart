library chatroom.models.message;

import 'dart:convert';

class Message {

  String sender, text;

  Message(this.text, {String this.sender});

  Message.fromJson(Map json) {
    this
      ..text = json["text"]
      ..sender = json.containsKey("sender") ? json["sender"] : "";
  }

  String toJson() {
    Map json = {
      "text": text,
    };

    if (sender != null) {
      json["sender"] = sender;
    }

    return JSON.encode(json);
  }

}