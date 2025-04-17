import 'package:dream/model/dreams.dart';
import 'package:dream/model/user.dart';

abstract class DataBase {
  Future<bool> saveUser(Users user);
  Future<Users> readUser(String userID);
  Future<bool> updateUserName(String userID, newUserName);
  Future<bool> updateSurname(String userID, newsurName);
  Future<bool> updateJob(String userID, newJob);
  Future<bool> updateDateOfBirth(String userID, newDate);
  Future<bool> updateHoroscope(String userID, newHoroscope);
  Future<bool> updateMaritalStatus(String userID, newMaritalStatus);
  Future<bool> jetonUpdate(String userID,int jeton);
  Future<bool> takeJeton(String userID,DateTime time,int jeton);
  Future<bool> buyJeton(String usersID,int jeton);
  //Future<List<Dreams>> getAllDreams(String userID);
  Future<List<Dreams>> getAllDreamsPagination(String userID, Dreams lastDream,int itemCount);
  Future<Dreams> getDream(String userID);
  Future<bool> saveDream(Dreams saveDream,String yorumcuID,int stateCount);
}