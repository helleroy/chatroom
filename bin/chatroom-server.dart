import "dart:io";
import "chatclient.dart";
import "package:shelf/shelf_io.dart" as shelf;
import "package:shelf_static/shelf_static.dart";
import 'package:chatroom/models/message.dart';

List<ChatClient> clients = [];

void main() {

  HttpServer.bind(InternetAddress.ANY_IP_V4, 8081).then((HttpServer server) {
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

  shelf.serve(createStaticHandler("../build/web", defaultDocument: "index.html"), "localhost", 8080);
}

Function handleWS(HttpConnectionInfo connectionInfo) {
  return (WebSocket client) {
    var message = "${connectionInfo.remoteAddress.address}:${connectionInfo.remotePort} connected";
    var chatClient = new ChatClient(client, connectionInfo, clients);
    clients.add(chatClient);
    print(message);
    chatClient.distributeMessage(new Message(message));
  };
}
