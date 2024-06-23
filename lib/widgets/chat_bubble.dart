import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../utils/text_styles.dart';

final _logger = Logger();

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final DateTime? prevTimestamp;

  ChatBubble({
    required this.message,
    required this.isMe,
    this.prevTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    final showDateDivider = prevTimestamp == null ||
        message.timestamp.day != prevTimestamp!.day ||
        message.timestamp.month != prevTimestamp!.month ||
        message.timestamp.year != prevTimestamp!.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.dateDividerColor,
                    thickness: 1.0,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  DateFormat('dd.MM.yy').format(message.timestamp),
                  style: textStyleGilroy14w500.copyWith(
                     color: AppColors.dateDividerColor,
                  ),
                  
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Divider(
                    color: AppColors.dateDividerColor,
                    thickness: 1.0,
                  ),
                ),
              ],
            ),
          ),
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isMe ? AppColors.sentMessageBackground : AppColors.customGrey1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21.0),
                  topRight: Radius.circular(21.0),
                  bottomLeft: isMe ? Radius.circular(21.0) : Radius.circular(-5.0),
                  bottomRight: isMe ? Radius.circular(-5.0) : Radius.circular(21.0),
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
                        style: textStyleGilroy14w500.copyWith(
                          color: isMe ? AppColors.sentMessage : AppColors.receivedMessage,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    
                    SizedBox(width: 8.0),
                    
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: textStyleGilroy14w500.copyWith(
                        color: isMe ? AppColors.sentMessage : AppColors.receivedMessage,
                      ),
                    ),

                    if (isMe)
                      SizedBox(width: 4.0),
                    if (isMe)
                      Icon(
                        () {
                          switch (message.status) {
                            case MessageStatus.sent:
                              return Icons.done;
                            case MessageStatus.delivered:
                              return Icons.done_all;
                            case MessageStatus.read:
                              return Icons.done_all;
                          }
                        }(),
                        color: () {
                          switch (message.status) {
                            case MessageStatus.sent:
                              return AppColors.sentMessageDeliveredStatus;
                            case MessageStatus.delivered:
                              return AppColors.sentMessageDeliveredStatus;
                            case MessageStatus.read:
                              return AppColors.sentMessageReadStatus;
                          }
                        }(),
                        size: 12.0,
                      ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MessageBubbleClipper extends CustomClipper<Path> {
  final bool isMe;

  MessageBubbleClipper({required this.isMe});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (isMe) {
      path.moveTo(0, size.height);
      path.lineTo(size.width - 10, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(10, 0);
    } else {
      path.moveTo(10, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - 10, 0);
      path.lineTo(0, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}