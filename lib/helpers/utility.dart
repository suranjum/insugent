import 'package:intl/intl.dart';
import 'dart:math' show Random;

class Utility {
  static String getInitials(String text) {
    var aText = text.trim().split(" ");
    String initials = "";
    for (var i = 0; i < aText.length; i++) {
      if (i > 1) break;
      try {
        initials += aText[i].substring(0, 1);
      } on Exception catch (e) {
        print(e.toString());
      }
    }
    return initials;
  }

  static String formatDateTime(String dateTime) {
    var formatter = new DateFormat('MMM dd, yyyy\nHH:mm a');
    var formatter2 = new DateFormat('HH:mm a');
    DateTime dt = DateTime.parse(dateTime);
    if (dt.day == DateTime.now().day)
      return formatter2.format(dt);
    else
      return formatter.format(dt);
  }

  static String passCode() {
    var rnd = Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.ceil().toString();
  }
}
