import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io/controllers/socket_controller.dart';

class ChatScreen extends StatelessWidget {
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
                    text: Get.find<SocketController>().messages[index].message.text,
                    color: Get.find<SocketController>().box.read('user') ==
                            Get.find<SocketController>()
                                .messages[index]
                                .sender
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
