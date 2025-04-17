import 'package:dream/model/user.dart';
import 'package:dream/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<Users?> currentUser() async {
    User? user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  Users? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return Users(usersID: user.uid, email: user.email!);
    }
  }

  @override
  Future<Users?> signInAnonymous() async {
    UserCredential sonuc = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<bool> signOut() async {
    final _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();

    final _facebookLogin = FacebookAuth.instance.logOut();

    await _firebaseAuth.signOut();
    return true;
  }

  @override
  Future<Users?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: _googleAuth.accessToken,
                idToken: _googleAuth.idToken));
        User _user = sonuc.user!;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<Users?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
    ]);

    /*final _facebookLogin = FacebookLogin();
    FacebookLoginResult _faceResult = await _facebookLogin.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);*/

    switch (result.status) {
      case LoginStatus.success:
        if (result.accessToken != null) {
          UserCredential _firebaseResult =
              await _firebaseAuth.signInWithCredential(
                  FacebookAuthProvider.credential(result.accessToken!.token));
          User _user = _firebaseResult.user!;
          return _userFromFirebase(_user);
        }
        break;
      case LoginStatus.cancelled:
        print("kullanıcı facebook girişini iptal etti");
        break;
      case LoginStatus.failed:
        print("Hata çıktı" + result.message!.toString());
        break;
      default:
        print("Bilinmeyen bir durum oluştu.");
        break;
    }
    return null;
  }

  @override
  Future<Users?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<Users?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(sonuc.user);
  }
}
