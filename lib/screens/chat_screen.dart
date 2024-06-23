import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import '../services/firebase_database_service.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

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
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            AppBar(
              leading: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: widget.user.avatarColor,
                    child: Text(
                      '${widget.user.firstName[0]}${widget.user.lastName[0]}',
                      style: textStyleGilroy20w700.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    radius: 24.0,
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.user.firstName} ${widget.user.lastName}',
                        style: textStyleGilroy15w600.copyWith(
                          color: AppColors.black,
                        ),
                        ),
                      SizedBox(height: 4.0),
                      Text(
                        widget.user.status,
                        style: textStyleGilroy12w500.copyWith(
                          color: AppColors.lastMessage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    message: message,
                    isMe: message.senderId == Constants.isMeUserId,
                    prevTimestamp: index > 0 ? _messages[index - 1].timestamp : null,
                  );
                },
              ),
            ),
            Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 48.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.customGrey1,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Обработчик нажатия на кнопку вложения
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: AppColors.black,
                      ),
                      visualDensity: VisualDensity.compact,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Сообщение',
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
                  SizedBox(width: 8.0),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 48.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.customGrey1,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Обработчик нажатия на кнопку записи голоса
                      },
                      icon: Icon(
                        Icons.mic_rounded,
                        color: AppColors.black,
                      ),
                      visualDensity: VisualDensity.compact,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}