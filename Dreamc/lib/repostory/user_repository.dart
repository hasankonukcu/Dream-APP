import 'package:dream/locator.dart';
import 'package:dream/model/dreams.dart';
import 'package:dream/model/user.dart';
import 'package:dream/services/auth_base.dart';
import 'package:dream/services/firebase_auth_service.dart';
import 'package:dream/services/firestore_db_service.dart';
import 'package:dream/services/notification_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  NotificationSendSevice _notificationSendSevice =
      locator<NotificationSendSevice>();

  AppMode appMode = AppMode.RELEASE;
  Map<String, String> userTokens = Map<String, String>();

  @override
  Future<Users?> currentUser() async {
    Users? _user = await _firebaseAuthService.currentUser();
    if (_user != null) {
      return await _firestoreDBService.readUser(_user.usersID);
    } else
      return null;
  }

  @override
  Future<Users?> signInAnonymous() async {
    return await _firebaseAuthService.signInAnonymous();
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  @override
  Future<Users?> signInWithGoogle() async {
    final _user = await _firebaseAuthService.signInWithGoogle();
    if (_user != null) {
      bool sonuc = await _firestoreDBService.saveUser(_user);
      if (sonuc == true) {
        return await _firestoreDBService.readUser(_user.usersID);
      } else {
        await _firebaseAuthService.signOut();
        return null;
      }
    } else
      return null;
  }

  @override
  Future<Users?> signInWithFacebook() async {
    Users? _user = await _firebaseAuthService.signInWithFacebook();
    if (_user != null) {
      bool sonuc = await _firestoreDBService.saveUser(_user);
      if (sonuc == true) {
        return await _firestoreDBService.readUser(_user.usersID);
      } else {
        await _firebaseAuthService.signOut();
        return null;
      }
    } else
      return null;
  }

  @override
  Future<Users?> createUserWithEmailAndPassword(
      String email, String password) async {
    Users? _user = await _firebaseAuthService.createUserWithEmailAndPassword(
        email, password);
    bool sonuc = await _firestoreDBService.saveUser(_user!);
    if (sonuc == true) {
      return await _firestoreDBService.readUser(_user.usersID);
    } else
      return null;
  }

  @override
  Future<Users?> signInWithEmailAndPassword(
      String email, String password) async {
    Users? _user =
        await _firebaseAuthService.signInWithEmailAndPassword(email, password);

    return await _firestoreDBService.readUser(_user!.usersID);
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    return await _firestoreDBService.updateUserName(userID, newUserName);
  }

  Future<bool> saveDream(
      Dreams saveMessage, String yorumcuID, int stateCount) async {
    var dbWrite =
        await _firestoreDBService.saveDream(saveMessage, yorumcuID, stateCount);
    if (dbWrite) {
      String key = await _firestoreDBService.getKey();
      await _notificationSendSevice.sendNotification(key);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Dreams>> getAllDreamsPagination(
      String usersID, Dreams? lastDream, int pageItemCount) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDBService.getAllDreamsPagination(
          usersID, lastDream, pageItemCount);
    }
  }

  Future<bool> updateSurname(String userID, String newsurName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateSurname(userID, newsurName);
    }
  }

  Future<bool> updateJob(String userID, String newJob) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateJob(userID, newJob);
    }
  }

  Future<bool> updateDateOfBirth(String userID, String newDate) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateDateOfBirth(userID, newDate);
    }
  }

  Future<bool> updateHoroscope(String userID, String newHoroscope) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateHoroscope(userID, newHoroscope);
    }
  }

  Future<bool> updateMaritalStatus(
      String userID, String newMaritalStatus) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateMaritalStatus(
          userID, newMaritalStatus);
    }
  }

  Future<bool> jetonUpdate(String userID, int? jeton) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.jetonUpdate(userID, jeton!);
    }
  }

  Future<bool> savePoint(Dreams dreams) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.savePoint(dreams);
    }
  }

  Future<bool> takeJeton(String userID, DateTime time, int jeton) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.takeJeton(userID, time, jeton);
    }
  }

  Future<bool> buyJeton(String usersID, int newJeton) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.buyJeton(usersID, newJeton);
    }
  }
}
