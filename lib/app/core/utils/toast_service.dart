import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static bool isToastVisible = false;

  static void showToast(String message, {Color textColor = Colors.white, Color bgColor = Colors.black}) {
    if (!isToastVisible) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor,
        textColor: textColor,
        fontSize: 16.0,
      );
      isToastVisible = true;
      Future.delayed(const Duration(seconds: 2), () {
        isToastVisible = false;
      });
    }
  }
}
