import "dart:html";
import "dart:convert";
import "package:polymer/polymer.dart";
import "package:chatroom/models/message.dart";
import "package:chatroom/models/user.dart";

@CustomTag("chatroom-client")
class ChatroomClient extends PolymerElement {

  WebSocket _ws;

  @observable String message;
  @observable List<Message> messages = toObservable([]);
  @observable List<User> users = toObservable([]);

  ChatroomClient.created() : super.created() {
    _ws = new WebSocket("ws://localhost:8080");

    _ws.onOpen.listen((Event data) {
      messages.add(new Message("Connected to the server!"));
    });

    _ws.onMessage.listen((MessageEvent event) {
      var message = new Message.fromJSON(JSON.decode(event.data));
      messages.add(message);
      if (message.connectedClients.isNotEmpty) {
        users.clear();
        users.addAll(message.connectedClients);
      }
    });

    _ws.onClose.listen((CloseEvent event) {
      messages.add(new Message("Connection to the server was lost..."));
    });
  }

  void submitMessage(Event event, var detail, Node sender) {
    event.preventDefault();
    _ws.send(JSON.encode({
        "message": message.trim()
    }));
    message = "";
  }


}
