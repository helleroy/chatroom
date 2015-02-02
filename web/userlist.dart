import "package:polymer/polymer.dart";

@CustomTag("user-list")
class UserList extends PolymerElement {

  @published List<String> users;

  UserList.created() : super.created() {

  }
}