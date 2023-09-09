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
              controller: controller.emailController,
              decoration: const InputDecoration(label: Text('Email')),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: controller.passController,
              decoration: const InputDecoration(label: Text('Password')),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () => controller.login(), child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
