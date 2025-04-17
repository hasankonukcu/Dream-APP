import 'package:flutter/widgets.dart';

import 'package:dream/app/landing_page.dart';
import 'package:dream/app/notification_handler.dart';
import 'package:dream/firebase_options.dart';
import 'package:dream/l10n/l10n.dart';
import 'package:dream/locator.dart';
import 'package:dream/services/purchase_api.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  final dynamic data = message.data;

  print("Arka planda gelen data: ${data.toString()}");
  NotificationHandler.showNotification(message);

  return Future<void>.value();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PurchaseApi.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  /* final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();*/
/*
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);*/

  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        locale: View.of(context).platformDispatcher.locale,
        title: "Rüya Perisi",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          indicatorColor: Color.fromARGB(255, 224, 216, 224),
          scaffoldBackgroundColor: Color.fromARGB(255, 73, 11, 73),

          primaryColor: Color.fromARGB(255, 73, 11, 73),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.transparent,
          ),

          disabledColor: Color.fromARGB(255, 189, 182, 182),

          cardColor: Color.fromARGB(255, 42, 2, 58),
          focusColor: Colors.white, //Text color 1
          hoverColor: Colors.white, //Text color 2
          canvasColor: Color.fromARGB(255, 80, 209, 166),

          //backgroundColor: Color.fromARGB(255, 12, 0, 41),
        ),
        home: LandingPage(),
      ),
    );
  }
}
