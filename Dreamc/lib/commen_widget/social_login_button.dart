import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double? height;
  final Widget? buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key? key,
      this.buttonColor = Colors.purple,
      required this.buttonText,
      this.textColor = Colors.white,
      this.buttonIcon,
      this.height = 40,
      required this.onPressed,
      this.radius = 16});

  @override
  Widget build(BuildContext context) {
    var myTextStyle = GoogleFonts.firaSans();

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (buttonIcon != null) ...[
                buttonIcon!,
                Text(
                  buttonText,
                  style: TextStyle(color: textColor),
                ),
                Opacity(
                  child: buttonIcon,
                  opacity: 0,
                )
              ],
              if (buttonIcon == null) ...[
                Container(),
                Text(
                  buttonText,
                  style: TextStyle(color: textColor),
                ),
                Container()
              ]
            ],
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              )),
        ),
      ),
    );
  }
}
