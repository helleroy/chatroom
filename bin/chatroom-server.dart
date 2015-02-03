import "dart:io";
import "dart:convert";
import "chatclient.dart";

List<ChatClient> clients = [];

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 8080).then((HttpServer server) {
    server.listen((HttpRequest request) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocketTransformer.upgrade(request).then(handleWS(request.connectionInfo));
      } else {
        request.response.statusCode = HttpStatus.FORBIDDEN;
        request.response.reasonPhrase = "WebSocket connections only";
        request.response.close();
      }
    });
  });
}

Function handleWS(HttpConnectionInfo connectionInfo) {
  return (WebSocket client) {
    print("Connection from ${connectionInfo.remoteAddress.address}:${connectionInfo.remotePort}");

    var json = JSON.encode({
        "text": "${connectionInfo.remoteAddress.address}:${connectionInfo.remotePort} connected",
        "connectedClients": clients
    });

    ChatClient chatClient = new ChatClient(client, connectionInfo, clients);

    clients.add(chatClient);
  };
}
