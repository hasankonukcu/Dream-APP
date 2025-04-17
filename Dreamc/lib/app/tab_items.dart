import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Users, Tarot, Horoscope, Profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users: TabItemData("Rüyalarım", Icons.nights_stay),
    TabItem.Tarot: TabItemData("Tarot", Icons.auto_awesome),
    TabItem.Horoscope: TabItemData("Burçlar", Icons.star),
    TabItem.Profil: TabItemData("Profil", Icons.person),
  };
}
