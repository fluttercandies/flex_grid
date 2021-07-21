enum ShowOption {
  History,

  Dividend,

  Split,
}

extension PeriodExtension on ShowOption {
  String get name {
    switch (this) {
      case ShowOption.History:
        return 'history';
      case ShowOption.Dividend:
        return 'div';
      case ShowOption.Split:
        return 'split';
      default:
        return '';
    }
  }
}
