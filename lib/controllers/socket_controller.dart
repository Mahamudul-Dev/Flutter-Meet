import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io/model/messege_model.dart';
import 'package:socket_io/page/chat_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket socket = IO.io('https://chat.linkfy.org', <String, dynamic>{
    'transports': ['websocket']
  });

  final box = GetStorage();

  TextEditingController messageController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  RxList<MessageModel> messages = <MessageModel>[].obs;

  buildConnection() {
    socket.onConnect((data) => print('Connection Success'));
    socket.onConnectError((data) => print(data.toString()));
    socket.onDisconnect((data) => print('desconnected.'));
  }

  @override
  void onInit() {
    buildConnection();
    super.onInit();
  }

  void joinChat(BuildContext context) {
    box.writeIfNull('user', userNameController.text);
    socket.emit('join', box.read('user'));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatScreen()));

    socket.on('chatMessage', (data) {
      var msg =
          MessageModel(username: data['username'], message: data['message']);
      messages.add(msg);
      print(msg.message);
      print(data);
      print(messages);
      update();
    });
  }

  void send() {
    SocketController().socket.emit('chatMessage', messageController.text);
    update();
    messageController.clear();
  }
}
