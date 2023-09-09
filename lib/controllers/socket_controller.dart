import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io/model/login_res_model.dart';
import 'package:socket_io/model/messege_model.dart';
import 'package:socket_io/page/chat_page.dart';

import 'package:http/http.dart' as http;

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utils.dart';

class SocketController extends GetxController {
  IO.Socket socket =
      IO.io('http://linkfysocket.linkfy.org:3434', <String, dynamic>{
    'transports': ['websocket']
  });

  final box = GetStorage();

  TextEditingController messageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  RxList<MessageModel> messages = <MessageModel>[].obs;

  void login() async {
    Map<String, dynamic> data = {
      'email': emailController.text.trim(),
      'password': passController.text.trim()
    };

    try {
      final response = await http.post(Uri.parse(BASE_URL + LOGIN), body: data);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final res = LoginResModel.fromJson(jsonDecode(response.body));
        box.write('email', emailController.text);
        box.write('id', res.id);
        Get.offAll(ChatScreen(
          email: emailController.text,
          id: res.id,
        ));
      } else {
        Get.snackbar('Opps', 'There was a error');
      }
    } catch (e) {
      print(e);
    }
  }

  void send() {
    //final uid = box.read('user');
    final msg = MessageModel(
        message: Message(text: messageController.text),
        attachments: [],
        users: [],
        sender: box.read('user'),
        receiver: 'Roki',
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString());
    socket.emit('privateMessage', msg);
    update();
    messageController.clear();
  }
}
