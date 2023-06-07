import 'package:example/assets.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ExcelSource extends LoadingMoreBase<List<Data?>> {
  Sheet? _sheet;
  Sheet? get sheet => _sheet;
  Future<void> init() async {
    if (_sheet == null) {
      final ByteData data = await rootBundle.load(Assets.assets_flexgrid_xlsx);
      _sheet = Excel.decodeBytes(data.buffer.asUint8List()).sheets['Sheet1'];
      _rows = _sheet!.rows.skip(1).toList();
    }
  }

  bool _hasMore = true;
  @override
  bool get hasMore => _hasMore;
  int i = 0;
  int? get maxCols => _sheet?.maxCols;
  List<Data?>? get headers => _sheet?.rows.first;

  late List<List<Data?>> _rows;
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    if (_sheet != null) {
      for (int j = 0; j < 20 && i < _rows.length; j++, i++) {
        add(_rows[i]);
      }
      _hasMore = i < _rows.length;
    }

    return true;
  }

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    i = 0;
    return super.refresh(notifyStateChanged);
  }

  SortType _sortType = SortType.none;
  SortType get sortType => _sortType;
  SortType sortHeader(
    int index,
  ) {
    int type = SortType.values.indexOf(_sortType);
    type++;
    if (type == 3) {
      type = 0;
    }

    _sortType = SortType.values[type];
    switch (_sortType) {
      case SortType.none:
        _rows = _sheet!.rows.skip(1).toList();

        break;
      case SortType.ascending:
        _rows.sort((List<Data?> a, List<Data?> b) =>
            double.tryParse(a[index]!.value.toString())!
                .compareTo(double.tryParse(b[index]!.value.toString())!));

        break;
      case SortType.descending:
        _rows.sort((List<Data?> a, List<Data?> b) =>
            double.tryParse(b[index]!.value.toString())!
                .compareTo(double.tryParse(a[index]!.value.toString())!));

        break;
      default:
    }
    clear();
    onStateChanged(this);
    addAll(_rows.take(i));
    onStateChanged(this);

    return _sortType;
  }
}

enum SortType {
  none,
  ascending,
  descending,
}
