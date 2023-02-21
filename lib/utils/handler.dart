import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void handleToast(String msg) {
  Fluttertoast.showToast(
      msg: "Error on register",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[600],
      textColor: Colors.white,
      fontSize: 16.0);
}
