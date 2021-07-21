import 'package:flex_grid/flex_grid.dart';
import 'package:loading_more_list/loading_more_list.dart';

class BigDataRow extends FlexGridRow {
  BigDataRow({this.name});
  final String name;

  @override
  List<Object> get columns =>
      List<String>.generate(columnCount, (int index) => 'Column:$index');
  static const int columnCount = 10000;
}

class BigData extends LoadingMoreBase<BigDataRow> {
  int _pageIndex = 1;

  void _load() {
    for (int i = 0; i < 15; i++) {
      add(BigDataRow(name: 'index:$_pageIndex-$i'));
    }
  }

  @override
  bool get hasMore => _pageIndex < 10000;

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    await Future<void>.delayed(const Duration(seconds: 0, milliseconds: 200));
    _load();
    _pageIndex++;
    return true;
  }

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _pageIndex = 1;
    return super.refresh(notifyStateChanged);
  }
}
