import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io/controllers/socket_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.put(SocketController());

  @override
  void initState() {
    if (Get.find<SocketController>().box.hasData('user')) {
      controller.joinChat(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.userNameController,
              decoration: const InputDecoration(label: Text('Username')),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () => controller.joinChat(context),
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
