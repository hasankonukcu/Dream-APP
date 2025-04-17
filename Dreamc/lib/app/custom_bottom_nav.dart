import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dream/app/tab_items.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation(
      {Key? key,
      required this.navigatorKeys,
      required this.onSelectedTab,
      required this.currentTab,
      required this.createdPage})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> createdPage;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    var _myBottomBackgrounColor = Colors.transparent;
    var _myBottomItemInactiveColor = Theme.of(context).hoverColor;
    var _myBottomItemActiveColor = Theme.of(context).canvasColor;
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: _myBottomItemActiveColor,
        backgroundColor: _myBottomBackgrounColor,
        inactiveColor: _myBottomItemInactiveColor,
        items: [
          _navItemCreate(TabItem.Users, _myBottomItemInactiveColor,
              _myBottomItemActiveColor),
          _navItemCreate(TabItem.Tarot, _myBottomItemInactiveColor,
              _myBottomItemActiveColor),
          _navItemCreate(TabItem.Horoscope, _myBottomItemInactiveColor,
              _myBottomItemActiveColor),
          _navItemCreate(TabItem.Profil, _myBottomItemInactiveColor,
              _myBottomItemActiveColor),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[showItem],
          builder: (context) {
            return createdPage[showItem]!;
          },
        );
      },
    );
  }

  BottomNavigationBarItem _navItemCreate(TabItem tabItem,
      Color myBottomItemInactiveColor, Color myBottomItemActiveColor) {
    final createdTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        createdTab!.icon,
        color: myBottomItemInactiveColor,
      ),
      activeIcon: Icon(
        createdTab.icon,
        color: myBottomItemActiveColor,
      ),
      label: createdTab.title,
    );
  }
}
