import "dart:io";
import "dart:convert";
import "package:chatroom/models/user.dart";
import "package:chatroom/models/message.dart";

class ChatClient {

  WebSocket _socket;
  User _user;
  String _address;
  int _port;
  List<ChatClient> _clients;

  ChatClient(WebSocket socket, HttpConnectionInfo connectionInfo, List<ChatClient> clients) {
    this
      .._socket = socket
      .._address = connectionInfo.remoteAddress.address
      .._port = connectionInfo.remotePort
      .._clients = clients
      .._user = new User("$_address:$_port")

      .._socket.listen(_messageHandler, onError : _errorHandler, onDone : _finishedHandler);
  }

  User get user => _user;

  void write(String message) {
    _socket.add(message);
  }

  void distributeMessage(String message) {
    for (ChatClient client in _clients) {
      client.write(message);
    }
  }

  void _messageHandler(String data) {
    print("Message from $_address:$_port: $data");

    Message message = new Message.fromJson(JSON.decode(data));

    switch (message.type) {
      case MessageType.connect:
        this._user.name = message.sender.name;
        distributeMessage(new Message("${_user.id} Connected", type: message.type, sender: _user, connectedClients: _clients.map((ChatClient client) => client.user).toList()).toJson());
        break;
      default:
        distributeMessage(new Message(message.text, type: message.type, sender: _user).toJson());
        break;
    }
  }

  void _errorHandler(String error) {
    print("$_address:$_port: Error: $error");
    _clients.remove(this);
    _socket.close();
  }

  void _finishedHandler() {
    var message = "${_user.name} disconnected";
    print(message);
    _clients.remove(this);
    distributeMessage(new Message(message, connectedClients: _clients.map((ChatClient client) => client.user).toList()).toJson());
    _socket.close();
  }

  Map toJson() {
    return {
      "id": "${_user.id}",
      "name": "${_user.name}"
    };
  }

}