enum Period {
  Daily,

  Weekly,

  Monthly
}

extension PeriodExtension on Period {
  String get name {
    switch (this) {
      case Period.Daily:
        return 'd';
      case Period.Weekly:
        return 'wk';
      case Period.Monthly:
        return 'mo';
      default:
        return '';
    }
  }
}
