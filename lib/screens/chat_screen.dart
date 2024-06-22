import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import '../services/firebase_database_service.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  ChatScreen({required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  List<ChatMessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() async {
    _messages = await FirebaseDatabaseService.getMessages(widget.user.id);
    setState(() {});
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await FirebaseDatabaseService.sendMessage(
        widget.user.id,
        message,
      );
      _messageController.clear();
      _fetchMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.user.avatarColor,
              child: Text(
                '${widget.user.firstName[0]}${widget.user.lastName[0]}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.user.firstName} ${widget.user.lastName}'),
                SizedBox(height: 4.0),
                Text(
                  widget.user.status,
                  style: TextStyle(fontSize: 12.0),
                ),

              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message,
                  isMe: message.senderId == widget.user.id,
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Отправить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
