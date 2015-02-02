import "dart:html";
import "dart:convert";
import "package:polymer/polymer.dart";

@CustomTag("chatroom-client")
class ChatroomClient extends PolymerElement {

  WebSocket _ws;

  @observable String message;
  @observable List<Map> messages = toObservable([]);
  @observable List<String> users = toObservable([]);

  ChatroomClient.created() : super.created() {
    _ws = new WebSocket("ws://localhost:8080");

    _ws.onOpen.listen((Event data) {
      messages.add({
          "message" : "Connected to the server!"
      });
    });

    _ws.onMessage.listen((MessageEvent event) {
      Map data = JSON.decode(event.data);
      messages.add(data);
      if (data.containsKey("connectedClients")) {
        users.clear();
        users.addAll(data["connectedClients"]);
      }
    });

    _ws.onClose.listen((CloseEvent event) {
      messages.add({
          "message" : "Connection to the server was lost..."
      });
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
