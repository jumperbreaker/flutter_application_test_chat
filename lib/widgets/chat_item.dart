import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/chat_screen.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class ChatItem extends StatelessWidget {
  final UserModel user;
  final String prefix;
  final String lastMessage;
  final String lastMessageTimeText;

  const ChatItem({
    Key? key,
    required this.user,
    required this.prefix,
    required this.lastMessage,
    required this.lastMessageTimeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            color: AppColors.customGrey1,
            height: 1.0,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: user),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: user.avatarColor,
                  child: Text(
                    '${user.firstName[0]}${user.lastName[0]}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: textStyleGilroy15w600.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          if (prefix.isNotEmpty)
                            Text(
                              '$prefix',
                              style: textStyleGilroy12w500.copyWith(
                                color: AppColors.prefix,
                              ),
                            ),
                          if (prefix.isNotEmpty)
                            SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              lastMessage,
                              style: textStyleGilroy12w500.copyWith(
                                color: AppColors.lastMessage,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    lastMessageTimeText,
                    style: textStyleGilroy12w500.copyWith(
                      color: AppColors.lastMessage,
                    ),
                  ),
                )
                
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            color: AppColors.customGrey1,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}