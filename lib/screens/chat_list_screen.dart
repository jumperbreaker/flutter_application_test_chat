import 'package:flutter/material.dart';
import '../widgets/chat_item.dart';
import '../models/user_model.dart';
import '../services/firebase_database_service.dart';
import 'package:logger/logger.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _logger = Logger();
  final _searchController = TextEditingController();
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    try {
      _users = await FirebaseDatabaseService.getUsers();
      setState(() {});
    } catch (e, s) {
      _logger.e('Error fetching users', e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чаты'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ChatItem(user: _users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
