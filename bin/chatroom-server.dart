import "dart:io";
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
    clients.add(new ChatClient(client, connectionInfo, clients));
  };
}
