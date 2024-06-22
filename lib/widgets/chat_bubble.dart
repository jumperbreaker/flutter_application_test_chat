import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../utils/colors.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  
  ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? AppColors.sentMessageBackground : AppColors.receivedMessageBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: isMe ? Radius.circular(16.0) : Radius.circular(0.0),
              bottomRight: isMe ? Radius.circular(0.0) : Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  '12:34',
                  style: TextStyle(
                    color: isMe ? AppColors.sentMessageTimestamp : AppColors.receivedMessageTimestamp,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(width: 4.0),
                Icon(
                  isMe
                      ? message.status == MessageStatus.delivered
                          ? Icons.done_all
                          : Icons.done
                      : null,
                  color: isMe
                      ? message.status == MessageStatus.read
                          ? AppColors.sentMessageReadStatus
                          : AppColors.sentMessageDeliveredStatus
                      : null,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
