import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final Color avatarColor;
  final String status;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarColor,
    required this.status,
  });
}

