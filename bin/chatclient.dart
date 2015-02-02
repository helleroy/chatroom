import "dart:io";
import "dart:convert";

class ChatClient {

  WebSocket _socket;
  String _address;
  int _port;
  List<ChatClient> _clients;

  ChatClient(WebSocket socket, HttpConnectionInfo connectionInfo, List<ChatClient> clients) {
    _socket = socket;
    _address = connectionInfo.remoteAddress.address;
    _port = connectionInfo.remotePort;
    _clients = clients;

    _socket.listen(messageHandler, onError : errorHandler, onDone : finishedHandler);
  }

  void messageHandler(String data) {
    print("Message from $_address:$_port: $data");
    Map json = JSON.decode(data);
    distributeMessage(JSON.encode({
        "sender": "$_address:$_port",
        "message": "${json["message"]}"
    }));
  }

  void errorHandler(String error) {
    print("$_address:$_port: Error: $error");
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    var message = "$_address:$_port: Disconnected";
    print(message);
    removeClient(this);
    distributeMessage(JSON.encode({
        "message": message, "connectedClients": _clients
    }));
    _socket.close();
  }

  void write(String message) {
    _socket.add(message);
  }

  void distributeMessage(String message) {
    for (ChatClient client in _clients) {
      client.write(message);
    }
  }

  void removeClient(ChatClient client) {
    _clients.remove(this);
  }

  Map toJson() {
    return {
        "id" : "$_address:$_port"
    };
  }

}