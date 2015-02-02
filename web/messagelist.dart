import "package:polymer/polymer.dart";

@CustomTag("message-list")
class MessageList extends PolymerElement {

  @published List<Map> messages;

  MessageList.created() : super.created() {

  }
}