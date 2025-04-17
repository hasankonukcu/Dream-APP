import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Dreams {
  final String usersID;
  String? email;
  String? userName;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? content;
  String? request;
  int? point;
  String? dreamID;
  String? commenter;
  int? timer1;
  int? timer2;

  Dreams(
      {required this.usersID,
      required this.email,
      this.content,
      this.userName,
      this.request,
      this.dreamID,
      this.point,
      this.commenter,
      this.timer1,
      this.timer2});

  Map<String, dynamic> toMap() {
    return {
      'userID': usersID,
      'email': email,
      'userName':
          userName ?? email!.substring(0, email!.indexOf('@')) + randomNumber(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'content': content ?? "",
      'request': request ?? "",
      'point': point ?? 0,
      'dreamID': dreamID ?? FirebaseFirestore.instance.collection("dreams").doc().id,
      'timer1':timer1,
      'timer2':timer2,
      'commenter':commenter,
    };
  }

  Dreams.fromMap(Map<String, dynamic> map)
      : usersID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        content = map['content'],
        request = map['request'],
        point = map['point'],
        dreamID = map['dreamID'],
        timer1 = map['timer1'],
        commenter = map['commenter'],
        timer2 = map['timer2'];

  String randomNumber() {
    int randomNum = Random().nextInt(99999);
    return randomNum.toString();
  }
}
