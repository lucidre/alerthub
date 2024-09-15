import 'package:flutter/cupertino.dart';

class BottomBarModel {
  final String title;
  final IconData icon;

  BottomBarModel({required this.title, required this.icon});
}

final barItems = [
  BottomBarModel(title: 'Home', icon: CupertinoIcons.home),
  BottomBarModel(title: 'Map', icon: CupertinoIcons.map),
  BottomBarModel(title: 'Profile', icon: CupertinoIcons.profile_circled),
];
