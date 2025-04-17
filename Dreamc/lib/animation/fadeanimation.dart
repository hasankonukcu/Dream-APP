
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation({required this.delay, required  this.child});

  @override
  Widget build(BuildContext context) {
 

    return Container(child: child,).animate().fade(delay:Duration(milliseconds: (500*delay).round())).slideY(curve: Curves.easeOut);
    
  }
}