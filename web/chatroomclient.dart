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
  @observable List<String> usersWriting = toObservable([]);

  ChatroomClient.created() : super.created();

  void connect(Event event, var detail, Node sender) {
    event.preventDefault();

    _ws = new WebSocket("ws://localhost:8081");

    _ws.onOpen.listen((Event data) {
      _ws.send(new Message("", type: MessageType.connect, sender: new User("", name: username)).toJson());
      connected = true;
    });

    _ws.onMessage.listen((MessageEvent event) {
      var message = new Message.fromJson(JSON.decode(event.data));

      switch (message.type) {
        case MessageType.startedWriting:
          usersWriting
            ..remove(message.sender.name)
            ..add(message.sender.name);
          break;
        case MessageType.stoppedWriting:
          usersWriting.remove(message.sender.name);
          break;
        default:
          messages.add(message);
          break;
      }

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

  void startedWriting() {
    _ws.send(new Message("", type: MessageType.startedWriting).toJson());
  }

  void stoppedWriting() {
    _ws.send(new Message("", type: MessageType.stoppedWriting).toJson());
  }

  void submitMessage(Event event, var detail, Node sender) {
    event.preventDefault();

    _ws.send(new Message(message.trim()).toJson());
    message = "";
  }

}
