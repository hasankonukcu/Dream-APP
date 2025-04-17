import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Lottie.asset(
        'assets/animations/stars_background.json',
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
}
