import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String uid;
  final String avatarUrl;
  final String name;
  final String message;
  final DateTime createdAt;

  const Message({
    @required this.uid,
    @required this.avatarUrl,
    @required this.name,
    @required this.message,
    @required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    uid: json['uid'],
    avatarUrl: json['avatarUrl'],
    name: json['name'],
    message: json['message'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'avatarUrl': avatarUrl,
    'name': name,
    'message': message,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}
