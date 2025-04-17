import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String usersID;
  String? email;
  String? userName;
  String? profilUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;
  String? surname;
  String? dateOfBirth;
  String? job;
  String? maritalStatus;
  String? horoscope;
  int? jeton;
  DateTime? lastWatch;

  Users({required this.usersID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': usersID,
      'email': email,
      'userName': userName ?? email!.substring(0, email!.indexOf('@')),
      'profilUrl': profilUrl ?? '',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
      'surname': surname ?? '',
      'dateOfBirth': dateOfBirth,
      'job': job ?? '',
      'maritalStatus': maritalStatus ?? '',
      'horoscope': horoscope ?? '',
      'jeton': jeton ?? 2,
      "lastWatch": lastWatch ?? DateTime(2021,1,1) 
    };
  }

  Users.fromMap(Map<String, dynamic> map)
      : usersID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilUrl = map['profilUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'],
        surname = map['surname'],
        dateOfBirth = map['dateOfBirth'],
        job = map['job'],
        horoscope = map['horoscope'],
        jeton = map["jeton"],
        lastWatch = (map['lastWatch'] as Timestamp?)?.toDate();
}
