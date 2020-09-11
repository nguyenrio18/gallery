import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void printInfo(String label, dynamic message) {
  var pen = AnsiPen()..green();
  print(pen('??? $label: $message'));
}

void printError(String label, dynamic error) {
  var pen = AnsiPen()..red();
  if (error is PlatformException && error.code != null) {
    print(pen('!!! $label [${error.code}]: $error'));
  } else {
    print(pen('!!! $label: $error'));
  }
}

void showInSnackBar(
    String value, bool isError, GlobalKey<ScaffoldState> scaffoldKey) {
  scaffoldKey.currentState.hideCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      value,
      style: isError ? const TextStyle(color: Colors.red) : null,
    ),
  ));
}
