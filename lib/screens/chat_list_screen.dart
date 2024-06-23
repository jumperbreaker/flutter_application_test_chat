import 'package:flutter/material.dart';
import '../widgets/chat_item.dart';
import '../models/user_model.dart';
import '../models/chat_message_model.dart';
import '../services/firebase_database_service.dart';
import 'package:logger/logger.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _logger = Logger();
  final _searchController = TextEditingController();
  List<UserModel> _users = [];
  Map<String, ChatMessageModel> _latestMessages = {};  
  bool _isLoadingMessages = false;  

  @override
  void initState() {
    super.initState();
    _fetchUsers();    
  }

  void _fetchUsers() async {
    try {
      _users = await FirebaseDatabaseService.getUsers();
      _fetchLatestMessages();
      setState(() {});
    } catch (e, s) {
      _logger.e('Error fetching users', e, s);
    }
  }

  Future<void> _fetchLatestMessages() async {
    try {
      setState(() {
        _isLoadingMessages = true;
      });
      for (final user in _users) {
        final messages = await FirebaseDatabaseService.getMessages(user.id);
        if (messages.isNotEmpty) {
          final latestMessage = messages.last;
          String prefix = '';
          if (latestMessage.senderId == Constants.isMeUserId) {
            prefix = 'Вы: ';
          }
          _latestMessages[user.id] = latestMessage;
          final lastMessageTimeText = _getLastMessageTimeText(latestMessage.timestamp);
          _logger.i('Latest message text: $prefix${latestMessage.text} ($lastMessageTimeText)');
        }
      }
      setState(() {
        _isLoadingMessages = false;
      });
    } catch (e, s) {
      _logger.e('Error fetching messages', e, s);
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  String _getLastMessageTimeText(DateTime? timestamp) {
    if (timestamp == null) {
      return '';
    }
    
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 1) {
      return DateFormat('dd.MM.yy').format(timestamp);
    } else if (diff.inDays == 1) {
      return 'Вчера';
    } else if (diff.inHours < 1) {
      final minutes = diff.inMinutes;
      return '$minutes минут назад';
    } else {
      return DateFormat('HH:mm').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Чаты',
          style: textStyleGilroy32w600.copyWith(
            color: AppColors.tileChat,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск',
                prefixIcon: const Icon(Icons.search),
                fillColor: AppColors.customGrey1,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: textStyleGilroy16w500.copyWith(
                color: AppColors.dateDividerColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final prefix = _latestMessages[user.id]?.senderId == Constants.isMeUserId ? 'Вы: ' : '';
                final lastMessage = _latestMessages[user.id]?.text ?? '';
                final lastMessageTimeText = _getLastMessageTimeText(_latestMessages[user.id]?.timestamp);
                return ChatItem(
                  user: user,
                  prefix: prefix,
                  lastMessage: lastMessage,
                  lastMessageTimeText: lastMessageTimeText,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}