import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordlyAlertDialog {
  static Future<void> show(
    String title,
    String content,
    BuildContext context, {
    String buttonText = "Ok",
  }) async {
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: Text(buttonText),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              )
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: Text(buttonText),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              )
            ],
          );
        },
      );
    }
    return;
  }
}
