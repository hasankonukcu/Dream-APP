import 'dart:async';
import 'package:dream/model/entitlement.dart';
import 'package:dream/services/purchase_api.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:dream/locator.dart';
import 'package:dream/model/dreams.dart';
import 'package:dream/model/user.dart';
import 'package:dream/repostory/user_repository.dart';
import 'package:dream/services/auth_base.dart';
import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = locator<UserRepository>();
  Users? _user;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? dreamErrorMessage;

  Users? get user => _user;



  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  UserModel() {
    init();
    currentUser();
  }

  Future init() async {
    
    updatePurchaseStatus();
    
   
  }

  Future updatePurchaseStatus() async {

    //final PurchaserInfo = await Purchases.getPurchaserInfo();
    final PurchaserInfo = await Purchases.getCustomerInfo();
    final entitlements = PurchaserInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allcourses;
  }

  @override
  Future<Users?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      notifyListeners();
      if (_user != null)
        return _user;
      else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users?> signInAnonymous() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymous();
      notifyListeners();

      return _user;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      notifyListeners();

      return sonuc;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users?> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      notifyListeners();
      if (_user != null)
        return _user;
      else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users?> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      notifyListeners();
      if (_user != null)
        return _user;
      else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      if (_emailPassControl(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepository.createUserWithEmailAndPassword(
            email, password);
        notifyListeners();

        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (_emailPassControl(email, password)) {
        state = ViewState.Busy;
        _user =
            await _userRepository.signInWithEmailAndPassword(email, password);
        notifyListeners();

        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailPassControl(String email, String pass) {
    var sonuc = true;

    if (pass.length < 6) {
      passwordErrorMessage = "En az 6 karakter olmalı";
      sonuc = false;
    } else
      passwordErrorMessage = null;
    if (!email.contains('@')) {
      emailErrorMessage = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailErrorMessage = null;

    return sonuc;
  }

  bool _createDreamControl(String dream) {
    var sonuc = true;

    if (dream.length < 10) {
      dreamErrorMessage = "En az 10 karakter olmalı";
      sonuc = false;
    }
    return sonuc;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, newUserName);
    if (sonuc) {
      _user!.userName = newUserName;
    } else {}
    return sonuc;
  }
/*
  Future<List<Dreams>> getAllDream(String userID) async {
    var allDreamList = await _userRepository.getAllDream(userID);
    return allDreamList;
  }*/

  Future<bool> saveDream(Dreams saveMessage,String yorumcuID,int stateCount) async {
    return await _userRepository.saveDream(saveMessage,yorumcuID,stateCount);
  }

  Future<List<Dreams>> getAllDreamsPagination(
      String usersID, Dreams? lastDream, int pageItemCount) async {
    return await _userRepository.getAllDreamsPagination(
        usersID, lastDream, pageItemCount);
  }

  Future<bool> updateSurname(String userID, String newsurName) async {
    var sonuc = await _userRepository.updateSurname(userID, newsurName);
    if (sonuc) {
      _user!.surname = newsurName;
    } else {}
    return sonuc;
  }

  Future<bool> updateJob(String userID, String newJob) async {
    var sonuc = await _userRepository.updateJob(userID, newJob);
    if (sonuc) {
      _user!.job = newJob;
    } else {}
    return sonuc;
  }

  Future<bool> updateDateOfBirth(String userID, String newDate) async {
    var sonuc = await _userRepository.updateDateOfBirth(userID, newDate);
    if (sonuc) {
      _user!.dateOfBirth = newDate;
    } else {}
    return sonuc;
  }

  Future<bool> updateHoroscope(String userID, String newHoroscope) async {
    var sonuc = await _userRepository.updateHoroscope(userID, newHoroscope);
    if (sonuc) {
      _user!.horoscope = newHoroscope;
    } else {}
    return sonuc;
  }

  Future<bool> updateMaritalStatus(
      String userID, String newMaritalStatus) async {
    var sonuc =
        await _userRepository.updateMaritalStatus(userID, newMaritalStatus);
    if (sonuc) {
      _user!.maritalStatus = newMaritalStatus;
    } else {}
    return sonuc;
  }

  Future<bool> jetonUpdate(String userID, int? jeton) async {
    var sonuc = await _userRepository.jetonUpdate(userID, jeton);
    if (sonuc) {
      _user!.jeton = jeton;
    } else {}
    return sonuc;
  }

  Future<bool> savePoint(Dreams dreams) async {
    var sonuc = await _userRepository.savePoint(dreams);

    return sonuc;
  }

  Future<bool> takeJeton(String userID, DateTime time, int jeton) async {
    var sonuc = await _userRepository.takeJeton(userID, time, jeton);
    var newJeton = jeton + 1;
    if (sonuc) {
      _user!.lastWatch = time;
      _user!.jeton = newJeton;
    } else {}
    return sonuc;
  }

  Future<bool> addJeton(Package package) async {
    switch (package.offeringIdentifier) {
      case Coins.idjeton5:
        var newJeton = _user!.jeton! + 5;
        var sonuc = await _userRepository.buyJeton(_user!.usersID, newJeton);
        if (sonuc) {
          _user!.jeton = _user!.jeton! + 5;
        }

        break;
      case Coins.idjeton10:
        var newJeton = _user!.jeton! + 10;
        var sonuc = await _userRepository.buyJeton(_user!.usersID, newJeton);
        if (sonuc) {
          _user!.jeton = _user!.jeton! + 10;
        }

        break;
      case Coins.idjeton20:
        var newJeton = _user!.jeton! + 20;
        var sonuc = await _userRepository.buyJeton(_user!.usersID, newJeton);
        if (sonuc) {
          _user!.jeton = _user!.jeton! + 20;
        }

        break;
      default:
        break;
    }
    notifyListeners();
    return true;
  }
}
