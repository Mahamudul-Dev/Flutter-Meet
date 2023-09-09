import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io/model/messege_model.dart';
import 'package:socket_io/page/chat_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket socket = IO.io('http://linkfysocket.linkfy.org:3434', <String, dynamic>{
    'transports': ['websocket']
  });

  final box = GetStorage();

  TextEditingController messageController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
    box.write('user', userNameController.text);
    socket.emit('join', box.read('user'));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatScreen()));

    socket.on('privateMessage', (data) {
      var msg = MessageModel.fromJson(data);
      // var msg = MessageModel(message: data['message'], attachments: data['attachments'], receiver: data['attachments'], createdAt: data['createdAt'], updatedAt: data['updatedAt']);
      messages.add(msg);
      print(msg.message);
      print(data);
      print(messages);
      update();
    });
  }

  void send() {
    //final uid = box.read('user');
    final msg = MessageModel(message: Message(text: messageController.text), attachments: [], users: [], sender: box.read('user'), receiver: 'Roki', createdAt: DateTime.now().toString(), updatedAt: DateTime.now().toString());
    socket.emit('privateMessage', msg);
    update();
    messageController.clear();
  }
}