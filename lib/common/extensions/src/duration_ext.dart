extension DurationExt on Duration {
  String toShortTime() {
    final days = this.inDays.abs();
    final years = days ~/ 365;
    return years > 0
        ? '${years}y'
        : days > 0
            ? '${days}d'
            : '${this.inHours.abs()}h';
  }

  String endOrEndedIn() {
    final val = toShortTime();
    return this.isNegative ? 'Ended $val ago' : 'Ends in $val';
  }

  String startOrStartedIn() {
    final val = toShortTime();
    return this.isNegative ? 'Started $val ago' : 'Starts in $val';
  }
}
