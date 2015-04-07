import "dart:io";
import "dart:convert";
import "package:chatroom/models/message.dart";

class ChatClient {

  WebSocket _socket;
  String _address;
  int _port;
  List<ChatClient> _clients;

  ChatClient(WebSocket socket, HttpConnectionInfo connectionInfo, List<ChatClient> clients) {
    this
      .._socket = socket
      .._address = connectionInfo.remoteAddress.address
      .._port = connectionInfo.remotePort
      .._clients = clients

      .._socket.listen(_messageHandler, onError : _errorHandler, onDone : _finishedHandler);
  }

  void write(String message) {
    _socket.add(message);
  }

  void distributeMessage(Message message) {
    for (ChatClient client in _clients) {
      client.write(message.toJson());
    }
  }

  void _messageHandler(String data) {
    print("Message from $_address:$_port: $data");
    Map json = JSON.decode(data);
    distributeMessage(new Message(json["text"], sender: "$_address:$_port"));
  }

  void _errorHandler(String error) {
    print("$_address:$_port: Error: $error");
    _clients.remove(this);
    _socket.close();
  }

  void _finishedHandler() {
    var message = "$_address:$_port disconnected";
    print(message);
    _clients.remove(this);
    distributeMessage(new Message(message));
    _socket.close();
  }

}