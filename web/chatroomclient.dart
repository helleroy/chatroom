import "dart:html";
import "dart:convert";
import "package:polymer/polymer.dart";
import "package:chatroom/models/message.dart";
import "package:chatroom/models/user.dart";

@CustomTag("chatroom-client")
class ChatroomClient extends PolymerElement {

  WebSocket _ws;

  @observable bool connected = false;
  @observable String message, username;
  @observable List<Message> messages = toObservable([]);
  @observable List<User> users = toObservable([]);

  ChatroomClient.created() : super.created();

  void connect(Event event, var detail, Node sender) {
    event.preventDefault();

    _ws = new WebSocket("ws://localhost:8081");

    _ws.onOpen.listen((Event data) {
      _ws.send(new User("", name: username).toJson());
      connected = true;
    });

    _ws.onMessage.listen((MessageEvent event) {
      var message = new Message.fromJson(JSON.decode(event.data));
      messages.add(message);
      if (message.connectedClients.isNotEmpty) {
        users.clear();
        users.addAll(message.connectedClients);
      }
    });

    _ws.onClose.listen((CloseEvent event) {
      messages.add(new Message("Connection to the server was lost..."));
      connected = false;
    });
  }

  void submitMessage(Event event, var detail, Node sender) {
    event.preventDefault();

    _ws.send(new Message(message.trim()).toJson());
    message = "";
  }

}
