class MyUtils {
  static String formatDateTimeHHMMSS(DateTime date) {
    return (date.hour > 9 ? date.hour : "0" + date.hour.toString()).toString() +
        ":" +
        (date.minute > 9 ? date.minute : "0" + date.minute.toString())
            .toString() +
        ":" +
        (date.second > 9 ? date.second : "0" + date.second.toString())
            .toString();
  }
}
