import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';

String secondsToString(int seconds) {
  return sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
}

void showToast(int count) {
  Fluttertoast.showToast(
      msg: '오늘 $count 개의 포모도로를 달성했습니다!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 16.0,
      backgroundColor: Colors.grey,
      timeInSecForIosWeb: 5);
}
