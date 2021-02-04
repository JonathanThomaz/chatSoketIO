import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

import '../components/User.dart';
import '../components/Message.dart';

class ChatModel extends Model {
  List<User> users = [
    User('IronMan', '111'),
    User('Captain America', '222'),
    User('Antman', '333'),
    User('Hulk', '444'),
    User('Thor', '555'),
  ];

  User currentUser;
  List<User> friendList = List<User>();
  List<Message> messages = List<Message>();
  SocketIO socketIO;

  void init() {
    currentUser = users[1];
    friendList =
        users.where((user) => user.chatID != currentUser.chatID).toList();

    socketIO = SocketIOManager().createSocketIO(
      'http://192.168.15.199:3000',
      '/',
      query: 'chatID=${currentUser.chatID}',
    );
    socketIO.init();

    socketIO.subscribe('new-message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print('new-message');
      print(data);
      messages.add(Message(
          data['message'], data['name'], data['receiverChatID']));
      notifyListeners();
    });

    socketIO.connect();
  }

  void joinRoom(User friend) {
    print('entrando-na-sala');
    print(friend.chatID);
    socketIO.sendMessage(
      'join-room',
      json.encode({'name': friend.name, 'roomId': friend.chatID}),
    );
  }

  void sendMessage(String text, String receiverChatID) {
    messages.add(Message(text, currentUser.chatID, receiverChatID));
    socketIO.sendMessage(
      'send-message',
      json.encode({
        'roomId': receiverChatID,
        'name': currentUser.name,
        'message': text,
      }),
    );
    notifyListeners();
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
        .toList();
  }
}
