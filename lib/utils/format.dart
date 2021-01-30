class MyUtils {
  static String formatDateTimeHHMMSS(DateTime date) {
    return (date.hour > 9 ? date.hour : "0" + date.hour.toString()).toString() +
        ":" +
        (date.minute > 9 ? date.minute : "0" + date.minute.toString()).toString() +
        ":" +
        (date.second > 9 ? date.second : "0" + date.second.toString()).toString();
  }

  static String getTime(DateTime date) {
    var diference = DateTime.now().difference(date);

    if (diference.inSeconds < 60) {
      return "${diference.inSeconds} segundo" + ((diference.inSeconds == 1) ? "" : "s");
    } else if (diference.inMinutes < 60) {
      return "${diference.inMinutes} minuto" + ((diference.inMinutes == 1) ? "" : "s");
    } else if (diference.inHours < 24) {
      return "${diference.inHours} hora" + ((diference.inHours == 1) ? "" : "s");
    } else if (diference.inDays < 7) {
      return "${diference.inDays} dia" + ((diference.inDays == 1) ? "" : "s");
    } else if (diference.inDays / 7 < 3) {
      return "${diference.inDays ~/ 7} semana" + (diference.inDays / 7 > 1 ? "s" : "");
    } else if ((diference.inDays / (30.5)) < 12) {
      return "${(diference.inDays ~/ (30.5))} mes" + ((diference.inDays / 30.5) > 1 ? "es" : "");
    } else if (diference.inDays / (366) > 1) {
      return "${diference.inDays ~/ (366)} ano" + ((diference.inDays / (366) > 1 ? "s" : ""));
    }
    return "Invalid Time!";
  }
}
