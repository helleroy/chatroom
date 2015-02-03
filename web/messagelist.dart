import "package:polymer/polymer.dart";
import "package:chatroom/models/message.dart";

@CustomTag("message-list")
class MessageList extends PolymerElement {

  @published List<Message> messages;

  MessageList.created() : super.created();
}