import 'dart:html';
import "package:polymer/polymer.dart";

@CustomTag("chatroom-client")
class ChatroomClient extends PolymerElement {

  WebSocket _ws;

  @observable String message;
  @observable List<String> messages = toObservable([]);

  ChatroomClient.created() : super.created() {
    _ws = new WebSocket("ws://localhost:8080");

    _ws.onOpen.listen((Event data) {
      messages.add("Connected to the server!");
    });

    _ws.onMessage.listen((MessageEvent event) {
      messages.add(event.data);
    });

    _ws.onClose.listen((CloseEvent event) {
      messages.add("Connection to the server was lost...");
    });
  }

  void submitMessage(Event event, var detail, Node sender) {
    event.preventDefault();
    _ws.send(message.trim());
    message = "";
  }


}
