import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io/page/chat_page.dart';
import 'package:socket_io/page/login.dart';

class AuthService {
  final store = GetStorage();

  Widget checkLogin() {
    if (store.hasData('email') && store.hasData('id')) {
      return ChatScreen(
        email: store.read('email'),
        id: store.read('id'),
      );
    } else {
      return LoginPage();
    }
  }
}
