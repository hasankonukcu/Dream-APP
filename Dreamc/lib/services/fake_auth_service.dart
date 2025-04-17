import 'package:dream/model/user.dart';
import 'package:dream/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "123124234234123234";
  @override
  Future<Users> currentUser() async {
    return await Future.value(Users(usersID: userID,email: "fake"));
  }

  @override
  Future<Users> signInAnonymous() async {
    return await Future.delayed(
        Duration(seconds: 2), () => Users(usersID: userID,email: "fake"));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<Users?> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Users?> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Users?> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Users?> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }
}
