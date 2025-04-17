import 'dart:io';

import 'package:dream/commen_widget/platform_sens_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformSensAlertDialog extends PlatformSensWidget {
  final String title;
  final String content;
  final String mainButtonText;
  final String? cancelButtonText;

  PlatformSensAlertDialog(
      {required this.title,
      required this.content,
      required this.mainButtonText,
      this.cancelButtonText});

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonSetting(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonSetting(context),
    );
  }

  List<Widget> _dialogButtonSetting(BuildContext context) {
    final allButton = <Widget>[];
    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        allButton.add(
          CupertinoDialogAction(
              child: Text(cancelButtonText!),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
        );
      }

      allButton.add(CupertinoDialogAction(
        child: Text(mainButtonText),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
    } else {
      if (cancelButtonText != null) {
        allButton.add(
          TextButton(
              child: Text(cancelButtonText!),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
        );
      }
      allButton.add(TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            ;
          },
          child: Text("Tamam")));
    }

    return allButton;
  }
}
