import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String uid;
  final String lid;
  
  User({ this.uid, this.lid });

}

class UserData {

  final bool isNewUser;
  final String lid;
  final String uid;
  final String name;
  final String avatarUrl;
  final String gender;
  final int age;
  final int height;
  final bool wantToBePaired;
  final bool wantToBePairedRandomly;
  final String hairColor;
  final String hairLength;
  final String cigarettes;
  final String alcohol;
  final List<dynamic> interests;
  final GeoPoint position;
  final int pairedDate;
  final int lastMessageTime;
  final bool isPositionUpdated;
  final bool isUserProfileUpdated;
  final bool isLoverProfileUpdated;
  final String politics;

  UserData({
    this.isNewUser,
    this.lid,
    this.uid,
    this.name,
    this.avatarUrl,
    this.gender,
    this.age,
    this.height,
    this.wantToBePaired,
    this.wantToBePairedRandomly,
    this.hairColor,
    this.hairLength,
    this.cigarettes,
    this.alcohol,
    this.interests,
    this.position,
    this.pairedDate,
    this.lastMessageTime,
    this.isPositionUpdated,
    this.isUserProfileUpdated,
    this.isLoverProfileUpdated,
    this.politics
  });

}