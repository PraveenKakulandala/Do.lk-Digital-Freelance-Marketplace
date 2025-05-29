
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:untitled12/features/user_auth/presentation/pages/home_page.dart';
import 'search_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final File? image;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.image,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 1;
  bool _showChatInterface = false;
  Map<String, dynamic>? _selectedChat;
  final Map<String, List<ChatMessage>> _chatMessages = {
    '1': [
      ChatMessage(
        text: "Hello! I'm interested in your logo design service.",
        isMe: false,
        time: "10:30 AM",
      ),
      ChatMessage(
        text: "Sure! Let's discuss your needs.",
        isMe: true,
        time: "10:32 AM",
      ),
    ],
    '2': [
      ChatMessage(
        text: "The website mockup is ready for review.",
        isMe: false,
        time: "Yesterday",
      ),
      ChatMessage(text: "I'll check it soon!", isMe: true, time: "Yesterday"),
    ],
    '3': [
      ChatMessage(
        text: "Payment received, thank you!",
        isMe: false,
        time: "2 days ago",
      ),
      ChatMessage(
        text: "You're welcome! Let me know if you need anything else.",
        isMe: true,
        time: "2 days ago",
      ),
    ],
  };

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': 'Kasun Perera',
      'lastMessage': 'Hi there! About your logo design request...',
      'time': '10:30 AM',
      'unread': 2,
      'avatar': 'assets/profile_placeholder.png',
      'isVerified': true,
      'profession': 'Logo Designer',
    },
    {
      'id': '2',
      'name': 'Amali Silva',
      'lastMessage': 'The website mockup is ready for review',
      'time': 'Yesterday',
      'unread': 1,
      'avatar': 'assets/profile_placeholder.png',
      'isVerified': true,
      'profession': 'Web Designer',
    },
    {
      'id': '3',
      'name': 'Rajith Fernando',
      'lastMessage': 'Payment received, thank you!',
      'time': '2 days ago',
      'unread': 0,
      'avatar': 'assets/profile_placeholder.png',
      'isVerified': false,
      'profession': 'Content Writer',
    },
  ];

  void _onItemTapped(int index) {
    if (_showChatInterface) {
      setState(() {
        _showChatInterface = false;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  void _openChat(Map<String, dynamic> chat) {
    setState(() {
      _selectedChat = chat;
      _showChatInterface = true;
      // Reset unread
      final chatIndex = _chats.indexWhere((c) => c['id'] == chat['id']);
      if (chatIndex != -1) _chats[chatIndex]['unread'] = 0;
    });
  }

  void _sendMessage({String? text, File? image}) {
    if ((text != null && text.trim().isNotEmpty) || image != null) {
      final id = _selectedChat!['id'];
      setState(() {
        _chatMessages[id]!.add(
          ChatMessage(
            text: image != null ? '[Image]' : text!,
            isMe: true,
            time: "${DateTime.now().hour}:${DateTime.now().minute}",
            image: image,
          ),
        );
        _messageController.clear();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _sendMessage(image: File(picked.path));
    }
  }

  Future<bool> _onWillPop() async {
    if (_showChatInterface) {
      setState(() {
        _showChatInterface = false;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(221, 13, 216, 23),
          elevation: 2,
          shadowColor: Colors.black,
          titleSpacing: 0,
          leading: _showChatInterface
              ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              setState(() {
                _showChatInterface = false;
              });
            },
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/Short White.png',
              width: 40,
              height: 40,
            ),
          ),
          title: _showChatInterface
              ? Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  _selectedChat?['avatar'] ?? 'assets/profile_placeholder.png',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedChat?['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ],
          )
              : const Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: _showChatInterface
              ? [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.videocam, color: Colors.white),
              onPressed: () {},
            ),
          ]
              : null,
        ),
        body: _showChatInterface ? _buildChatInterface() : _buildChatList(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavBarItem(Icons.home, 0),
                _buildNavBarItem(Icons.chat, 1),
                _buildNavBarItem(Icons.search, 2),
                _buildNavBarItem(Icons.shopping_bag, 3),
                _buildNavBarItem(Icons.person, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return InkWell(
          onTap: () => _openChat(chat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(chat['avatar']),
                    ),
                    if (chat['isVerified'])
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            chat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            chat['time'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat['profession'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat['lastMessage'],
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontWeight: chat['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (chat['unread'] > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat['unread'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatInterface() {
    final id = _selectedChat!['id'];
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: _chatMessages[id]!.length,
            itemBuilder: (context, index) => _buildMessage(_chatMessages[id]![index]),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: () => _sendMessage(text: _messageController.text),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            const CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/profile_placeholder.png'),
            ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe
                    ? const Color.fromARGB(221, 13, 216, 23)
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 0),
                  bottomRight: Radius.circular(message.isMe ? 0 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (message.image != null)
                    Image.file(
                      message.image!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  if (message.text.isNotEmpty && message.text != '[Image]')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isMe ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe)
            const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/profile_placeholder.png'),
            ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.green : Colors.grey,
        size: 30,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}