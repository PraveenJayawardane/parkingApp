import 'package:timezone/standalone.dart' as tz;

class AppTimeZone {
  static DateTime getTimeZone(
      {required String timeZoneName, required int milliseconds}) {
    var timeZone = tz.getLocation(timeZoneName);
    DateTime date =
        tz.TZDateTime.fromMillisecondsSinceEpoch(timeZone, milliseconds);
    print(date);
    return date;
  }
}
