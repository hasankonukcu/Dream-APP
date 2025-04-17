import 'package:dream/app/tarot/bgfile.dart';
import 'package:flutter/material.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: StarBackground(), // Tüm ekranı kaplar
        ),
        Positioned.fill(
          child: child, // Asıl sayfan
        ),
      ],
    );
  }
}
