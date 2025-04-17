import 'package:dream/app/custom_bottom_nav.dart';
import 'package:dream/app/horoscope/horoscope_page.dart';

import 'package:dream/app/notification_handler.dart';
import 'package:dream/app/profil.dart';
import 'package:dream/app/tab_items.dart';
import 'package:dream/app/tarot/tarot.dart';
import 'package:dream/app/users_page.dart';
import 'package:dream/model/user.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Users user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  TabItem _currentTab = TabItem.Users;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.Horoscope: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };
  Map<TabItem, Widget> allPage() {
    return {
      TabItem.Users: UsersPage(),
      TabItem.Tarot: TarotScreen(),
      TabItem.Horoscope: const HoroscopePage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFcmNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context);
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CustomBottomNavigation(
        createdPage: allPage(),
        currentTab: _currentTab,
        navigatorKeys: navigatorKeys,
        onSelectedTab: (selectedTab) {
          if (selectedTab == _currentTab) {
            navigatorKeys[selectedTab]!
                .currentState!
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = selectedTab;
            });
          }

          debugPrint(selectedTab.index.toString());
        },
      ),
    );
  }
}
