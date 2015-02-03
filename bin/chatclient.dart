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
    _socket = socket;
    _address = connectionInfo.remoteAddress.address;
    _port = connectionInfo.remotePort;
    _clients = clients;
    _user = new User("$_address:$_port");

    _socket.listen(_messageHandler, onError : _errorHandler, onDone : _finishedHandler);
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

    Map json = JSON.decode(data);
    if (_checkConnectMessage(json)) {
      distributeMessage(new Message("${_user.id} Connected", sender: _user, connectedClients: _clients.map((ChatClient client) => client.user).toList()).toJson());
    } else {
      distributeMessage(new Message(json["message"], sender: _user).toJson());
    }
  }

  void _errorHandler(String error) {
    print("$_address:$_port: Error: $error");
    _removeClient(this);
    _socket.close();
  }

  void _finishedHandler() {
    var message = "${_user.name} disconnected";
    print(message);
    _removeClient(this);
    distributeMessage(new Message(message, connectedClients: _clients.map((ChatClient client) => client.user).toList()).toJson());
    _socket.close();
  }

  void _removeClient(ChatClient client) {
    _clients.remove(this);
  }

  bool _checkConnectMessage(Map json) {
    var user = new User.fromJson(json);
    if (user.name.isNotEmpty) {
      this._user.name = user.name;
      return true;
    }
    return false;
  }

  Map toJson() {
    return {
        "id": "${_user.id}",
        "name": "${_user.name}"
    };
  }

}