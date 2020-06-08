extension DurationFormatting on Duration {
  String format() {
    if (this == null) return "00:00";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String formated = "";

    if (this.inDays >= 1) formated += "${twoDigits(this.inDays)}:";

    formated +=
        "${twoDigits(this.inHours)}:${twoDigits(this.inSeconds.remainder(60))}";

    return formated;
  }
}
