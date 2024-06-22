import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/chat_list_screen.dart';

void main() {
  // Устанавливаем светлый системный режим
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  @override
  const MainApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messenger',
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      //home: ChatListScreen(),
    );
  }
}
