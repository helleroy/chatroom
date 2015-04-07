import "dart:html";
import "dart:convert";
import "package:polymer/polymer.dart";
import "package:chatroom/models/message.dart";

@CustomTag("chatroom-client")
class ChatroomClient extends PolymerElement {

  WebSocket _ws;

  @observable String message;
  @observable List<Message> messages = toObservable([]);

  ChatroomClient.created() : super.created() {
    _ws = new WebSocket("ws://localhost:8081");

    _ws.onOpen.listen((Event data) {
    });

    _ws.onMessage.listen((MessageEvent event) {
      messages.add(new Message.fromJson(JSON.decode(event.data)));
    });

    _ws.onClose.listen((CloseEvent event) {
      messages.add(new Message("Connection to the server was lost..."));
    });
  }

  void submitMessage(Event event, var detail, Node sender) {
    event.preventDefault();

    _ws.send(new Message(message.trim()).toJson());
    message = "";
  }

}
