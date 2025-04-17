import 'package:dream/repostory/user_repository.dart';
import 'package:dream/services/fake_auth_service.dart';
import 'package:dream/services/firebase_auth_service.dart';
import 'package:dream/services/firestore_db_service.dart';
import 'package:dream/services/notification_service.dart';


import 'package:get_it/get_it.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => NotificationSendSevice());


}
