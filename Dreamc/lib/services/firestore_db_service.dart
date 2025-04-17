import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/model/dreams.dart';
import 'package:dream/model/user.dart';
import 'package:dream/services/db_base.dart';

class FirestoreDBService implements DataBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<bool> saveUser(Users user) async {
    DocumentSnapshot _readedUser =
        await FirebaseFirestore.instance.doc('users/${user.usersID}').get();
    if (_readedUser.data() == null) {
      await _firebaseFirestore
          .collection("users")
          .doc(user.usersID)
          .set(user.toMap());
      return true;
    } else {
      return true;
    }

    /*Map<String, dynamic> _readedUserInformation =
        _readedUser.data() as Map<String, dynamic>;
    Users _readedUserInformationObject = Users.fromMap(_readedUserInformation);*/
  }

  @override
  Future<Users> readUser(String userID) async {
    DocumentSnapshot _readedUser =
        await _firebaseFirestore.collection('users').doc(userID).get();
    Map<String, dynamic> _reaadedUserInfMap =
        _readedUser.data() as Map<String, dynamic>;
    Users _readedUserObject = Users.fromMap(_reaadedUserInfMap);
    return _readedUserObject;
  }

  @override
  Future<bool> updateUserName(String userID, newUserName) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"userName": newUserName});
    return true;
  }

/*
  @override
  Future<List<Dreams>> getAllDreams(String userID) async {
    QuerySnapshot _snapshot = await _firebaseFirestore
        .collection('dreams')
        .doc(userID)
        .collection('dream')
        .orderBy('updatedAt')
        .get();
    List<Dreams> allDream = [];
    for (DocumentSnapshot dream in _snapshot.docs) {
      Dreams _dream = Dreams.fromMap(dream.data() as Map<String, dynamic>);
      allDream.add(_dream);
    }
    return allDream;
  }
*/
  @override
  Future<Dreams> getDream(String userID) async {
    DocumentSnapshot _snapshot = await _firebaseFirestore
        .collection('dreams')
        .doc(userID)
        .collection('dream')
        .doc(userID)
        .get();
    Dreams _snapshotToMap =
        Dreams.fromMap(_snapshot.data() as Map<String, dynamic>);
    return _snapshotToMap;
  }

  @override
  Future<bool> saveDream(
      Dreams saveMessage, String yorumcuID, int stateCount) async {
    try {
      var _userID = saveMessage.usersID;
      var _saveMessageMapBuild = saveMessage.toMap();
      var _messageID = _saveMessageMapBuild["dreamID"];
      await _firebaseFirestore
          .collection("dreams")
          .doc(_userID)
          .set({"set": "set"});

      await _firebaseFirestore
          .collection('dreams')
          .doc(_userID)
          .collection("dream")
          .doc(_messageID)
          .set(_saveMessageMapBuild);
      await _firebaseFirestore
          .collection("yorumcu")
          .doc(yorumcuID)
          .update({"state": stateCount + 1});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> getKey() async {
    var result = await _firebaseFirestore.collection('key').doc("key").get();
    Map<String, dynamic> mapData = result.data() as Map<String, dynamic>;
    var key = mapData["key"];
    return key;
  }

  @override
  Future<List<Dreams>> getAllDreamsPagination(
      String userID, Dreams? lastDream, int itemCount) async {
    QuerySnapshot _querySnapShot;
    List<Dreams> _allDream = [];
    if (lastDream == null) {
      _querySnapShot = await FirebaseFirestore.instance
          .collection("dreams")
          .doc(userID)
          .collection("dream")
          .orderBy("updatedAt", descending: true)
          .limit(itemCount)
          .get();
    } else {
      _querySnapShot = await FirebaseFirestore.instance
          .collection("dreams")
          .doc(userID)
          .collection("dream")
          .orderBy("updatedAt", descending: true)
          .startAfter([lastDream.updatedAt])
          .limit(itemCount)
          .get();
    }
    for (DocumentSnapshot snap in _querySnapShot.docs) {
      Dreams oneDream = Dreams.fromMap(snap.data() as Map<String, dynamic>);
      _allDream.add(oneDream);
    }
    return _allDream;
  }

  @override
  Future<bool> updateSurname(String userID, newsurName) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"surname": newsurName});
    return true;
  }

  @override
  Future<bool> updateJob(String userID, newJob) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"job": newJob});
    return true;
  }

  @override
  Future<bool> updateDateOfBirth(String userID, newDate) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"dateOfBirth": newDate});
    return true;
  }

  @override
  Future<bool> updateHoroscope(String userID, newHoroscope) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"horoscope": newHoroscope});
    return true;
  }

  @override
  Future<bool> updateMaritalStatus(String userID, newMaritalStatus) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"maritalStatus": newMaritalStatus});
    return true;
  }

  Future<String?> tokenGetir(String usersID) async {
    DocumentSnapshot _token =
        await _firebaseFirestore.doc("tokens/" + usersID).get();
    Map<String, dynamic> mapData = _token.data() as Map<String, dynamic>;
    if (_token != null)
      return mapData["token"];
    else
      return null;
  }

  @override
  Future<bool> jetonUpdate(String userID, int jeton) async {
    var _jeton = jeton - 1;
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"jeton": _jeton});
    return true;
  }

  Future<bool> savePoint(Dreams dreams) async {
    await _firebaseFirestore
        .collection('dreams')
        .doc(dreams.usersID)
        .collection("dream")
        .doc(dreams.dreamID)
        .update({"point": dreams.point});
    return true;
  }

  Future<bool> takeJeton(String userID, DateTime time, int jeton) async {
    var _jeton = jeton + 1;
    await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"jeton": _jeton, "lastWatch": time});
    return true;
  }

  Future<bool> buyJeton(String usersID, int newJeton) async {
    print("buy jeton db okundu, new jeton : " + newJeton.toString());

    await _firebaseFirestore
        .collection("users")
        .doc(usersID)
        .update({"jeton": newJeton});
    return true;
  }
}
