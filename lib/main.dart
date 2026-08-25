import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/list_chat.dart';
import 'pages/detail_chat.dart';
import 'pages/login_pages.dart';
import 'pages/account_pages.dart';
import 'pages/cart_page.dart';
import 'providers/app_state_provider.dart';

void main() {
  runApp(
    const AppStateScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoGlobal E-Commerce',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C53A5),
          primary: const Color(0xFF4C53A5),
          secondary: const Color(0xFF653993),
        ),
      ),
      // Auth Guard at Startup
      initialRoute: auth.isAuthenticated ? "/dashboard" : "/login",
      routes: {
        "/": (context) => auth.isAuthenticated
            ? const HomePage()
            : const LoginPages(),
        "/login": (context) => const LoginPages(),
        "/dashboard": (context) => const HomePage(),
        "/homePage": (context) => const HomePage(),
        "/cart": (context) => const CartPage(),
        "cartPage": (context) => const CartPage(),
        "/account": (context) => const AccountPage(),
        "accountPage": (context) => const AccountPage(),
        "/list_chat": (context) => const ChatListPage(),
        "ListChat": (context) => const ChatListPage(),
        "/chat_detail": (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return ChatScreen(contactName: args ?? 'Nike Official');
        },
        "ChatDetail": (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return ChatScreen(contactName: args ?? 'Nike Official');
        },
        "/item_detail": (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Detail Produk",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color(0xFF4C53A5),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: const Center(
                child: Text(
                  "Halaman Detail Produk",
                  style: TextStyle(fontSize: 18, color: Color(0xFF4C53A5)),
                ),
              ),
            ),
        "itemsPage": (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Detail Produk",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color(0xFF4C53A5),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: const Center(
                child: Text(
                  "Halaman Detail Produk",
                  style: TextStyle(fontSize: 18, color: Color(0xFF4C53A5)),
                ),
              ),
            ),
      },
    );
  }
}
