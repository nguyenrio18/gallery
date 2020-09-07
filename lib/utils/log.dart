import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/services.dart';

void printError(String label, dynamic error) {
  var redPen = AnsiPen()..red();
  if (error is PlatformException && error.code != null) {
    print(redPen('### $label [${error.code}]: $error'));
  } else {
    print(redPen('### $label: $error'));
  }
}
