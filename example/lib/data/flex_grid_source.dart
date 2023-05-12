import 'package:flex_grid/flex_grid.dart';
import 'package:loading_more_list/loading_more_list.dart';

class GridRow extends FlexGridRow {
  GridRow({this.name});
  final String? name;

  @override
  List<Object> get columns =>
      List<String>.generate(15, (int index) => 'Column:$index');

  static List<String> cloumnNames = List<String>.generate(
      15, (int index) => index == 0 ? 'ID' : 'Header:$index');

  static List<String> footerNames = List<String>.generate(
      15, (int index) => index == 0 ? 'ID' : 'Footer:$index');
}

class FlexGridSource extends LoadingMoreBase<GridRow> {
  int _pageIndex = 1;

  void _load() {
    for (int i = 0; i < 15; i++) {
      add(GridRow(name: 'index:$_pageIndex-$i'));
    }
  }

  @override
  bool get hasMore => _pageIndex < 4;

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    await Future<void>.delayed(const Duration(seconds: 2));
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
