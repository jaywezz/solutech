import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomSnackBar(String message, {Color? bgColor, bool isError = true}) {
  Fluttertoast.showToast(
    toastLength: Toast.LENGTH_LONG,
    msg: message,
    textColor: Colors.white,
    gravity: ToastGravity.TOP,
    backgroundColor: bgColor != null ? bgColor : isError ? Colors.red : Colors.green,
  );
} 