import 'package:flutter/material.dart';

class SnackBarService {
  static SnackBar? _currentSnackBar;

  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color textColor = Colors.white,
    double fontSize = 14,
    String? fontFamily,
    FontWeight fontWeight = FontWeight.w400,
    Color backgroundColor = Colors.red,
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
    Duration duration = const Duration(seconds: 4),
    double topMargin = 0,
    double bottomMargin = 0,
    double leftMargin = 0,
    double rightMargin = 0,
    TextAlign textAlign = TextAlign.center,
    AlignmentGeometry alignment = Alignment.bottomCenter,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: textAlign,
        style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight, fontFamily: fontFamily),
      ),
      backgroundColor: backgroundColor,
      behavior: behavior,
      duration: duration,
      margin:
          behavior == SnackBarBehavior.floating
              ? EdgeInsets.only(left: leftMargin, right: rightMargin, bottom: bottomMargin, top: topMargin)
              : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _currentSnackBar = snackBar;
  }

  static void dismissSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    _currentSnackBar = null;
  }

  static bool isSnackBarVisible(BuildContext context) {
    return ScaffoldMessenger.of(context).mounted;
  }
}
