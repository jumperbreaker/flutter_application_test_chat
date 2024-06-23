import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/chat_message_model.dart';
import 'firebase_auth_service.dart';
import 'package:logger/logger.dart';
import '../utils/constants.dart';

final _logger = Logger();

class FirebaseDatabaseService {
  static final _firestore = FirebaseFirestore.instance;

 static Future<List<UserModel>> getUsers() async {
  _logger.i('Fetching users from Firestore');
  final snapshot = await _firestore.collection('users').get();
  final List<UserModel> users = [];

  for (final doc in snapshot.docs) {
    if (doc.id != Constants.isMeUserId) {
      final data = doc.data();
      users.add(
        UserModel(
          id: doc.id,
          firstName: data['firstName'],
          lastName: data['lastName'],
          avatarColor: Color(int.parse(data['avatarColor'].replaceFirst('#', '0xff'))),
          status: data['status'],
        ),
      );
    }
  }

  _logger.i('Users fetched: ${users.length}');
  return users;
}

  static Future<List<ChatMessageModel>> getMessages(String userId) async {
    _logger.i('Fetching messages from Firestore');
    

    final snapshot1 = await _firestore
        .collection('messages')
        .where('senderId', isEqualTo: userId)
        .where('receiverId', isEqualTo: Constants.isMeUserId)
        .orderBy('timestamp')
        .get();

    final snapshot2 = await _firestore
        .collection('messages')
        .where('senderId', isEqualTo: Constants.isMeUserId)
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp')
        .get();

    final messages = [...snapshot1.docs, ...snapshot2.docs]
        .map((doc) {
          final data = doc.data();
          return ChatMessageModel(
            id: doc.id,
            senderId: data['senderId'],
            receiverId: data['receiverId'],
            text: data['text'],
            timestamp: data['timestamp'].toDate(),
            status: _getMessageStatus(data['status']),
          );
        })
        .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    _logger.i('Messages fetched: ${messages.length}');
    for (var message in messages) {
      _logger.i('id: ${message.id} | receiverId: ${message.receiverId} | senderId: ${message.senderId} | text: ${message.text} | timestamp: ${message.timestamp} | status: ${message.status}');
    }
    return messages;
  }
  static Future<void> sendMessage(String receiverId, String text) async {
    //Обработчик отправки собщения
  }

  static MessageStatus _getMessageStatus(String status) {
    switch (status) {
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      default:
        return MessageStatus.sent;
    }
  }  
}