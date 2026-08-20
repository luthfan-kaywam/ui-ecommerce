import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/list_chat.dart';
import 'pages/detail_chat.dart';
import 'pages/login_pages.dart';
import 'pages/account_pages.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoGlobal',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "homePage": (context) => const HomePage(),
        "loginPage": (context) => const LoginPages(),
        "accountPage": (context) => const AccountPage(),
        "cartPage": (context) => const CartPage(),
        "ListChat": (context) => const ChatListPage(),
        "ChatDetail": (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return ChatScreen(contactName: args ?? 'Nike Official');
        },
        "itemsPage": (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Product Details"),
            backgroundColor: const Color(0xFF4C53A5),
          ),
          body: const Center(child: Text("Halaman Detail Produk")),
        ),
      },
    );
  }
}
