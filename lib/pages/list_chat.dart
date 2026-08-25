import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Chat Data
    final List<Map<String, String>> chats = [
      {
        'name': 'Nike Official',
        'message': 'Segera Memesan Sebelum Kehabisan.',
        'time': '12:30',
        'avatar': 'images/7.jpg',
      },
      {
        'name': 'Expander',
        'message': 'Hallo, Selamat Datang Di Expander.',
        'time': '12:05',
        'avatar': 'images/2.jpg',
      },
      {
        'name': 'TOYOTA',
        'message': 'Hallo, Selamat Datang Di TOYOTA.',
        'time': '12:05',
        'avatar': 'images/4.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FF),
      appBar: AppBar(
        title: const Text(
          'Pesan & Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF4C53A5),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF4C53A5)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.white,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Semua',
                    style: TextStyle(
                      color: Color(0xFF4C53A5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Belum Dibaca',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 114, 123, 1),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat List View
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFEDECF2),
                    child: ClipOval(
                      child: Image.asset(
                        chat['avatar']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.store,
                            color: Color(0xFF4C53A5),
                            size: 28,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    chat['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    chat['message']!,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (index == 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/chat_detail",
                      arguments: chat['name'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
