import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:socket_io/controllers/socket_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/messege_model.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.email,
    required this.id,
  }) : super(key: key);

  final String email;
  final String id;
  RxList<MessageModel> messages = <MessageModel>[].obs;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    IO.Socket socket =
        IO.io('http://linkfysocket.linkfy.org:3434', <String, dynamic>{
      'transports': ['websocket'],
      'auth': {'token': widget.id}
    });
    socket.connect();

    socket.onConnect((data) => print('Connection Success'));
    socket.onConnectError((data) => print(data.toString()));
    socket.onDisconnect((data) => print('desconnected.'));

    socket.emit('join', widget.email);

    socket.on('privateMessage', (data) {
      var msg = MessageModel.fromJson(data);
      // var msg = MessageModel(message: data['message'], attachments: data['attachments'], receiver: data['attachments'], createdAt: data['createdAt'], updatedAt: data['updatedAt']);
      widget.messages.add(msg);
      print(msg.message);
      print(data);
      print(widget.messages);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SocketController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket.IO Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: Get.find<SocketController>().messages.length,
                itemBuilder: (context, index) {
                  return BubbleSpecialThree(
                    text: Get.find<SocketController>()
                        .messages[index]
                        .message
                        .text,
                    color: Get.find<SocketController>().box.read('user') ==
                            Get.find<SocketController>().messages[index].sender
                        ? Colors.blue
                        : Colors.grey.shade400,
                    tail: true,
                    isSender: Get.find<SocketController>().box.read('user') ==
                        Get.find<SocketController>().messages[index].sender,
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                  );
                },
              ),
            ),
          ),
          Flex(direction: Axis.horizontal, children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: Get.find<SocketController>().messageController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a message',
                  ),
                  onSubmitted: (value) {
                    Get.find<SocketController>().send();
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                  onPressed: () => Get.find<SocketController>().send(),
                  child: Text('Send')),
            )
          ]),
        ],
      ),
    );
  }
}
