# flex_grid

[![pub package](https://img.shields.io/pub/v/flex_grid.svg)](https://pub.dartlang.org/packages/flex_grid) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/network) [![GitHub license](https://img.shields.io/github/license/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/issues) <a href="https://qm.qq.com/q/ZyJbSVjfSU">![FlutterCandies QQ 群](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Ffluttercandies%2F.github%2Frefs%2Fheads%2Fmain%2Fdata.yml&query=%24.qq_group_number&label=QQ%E7%BE%A4&logo=qq&color=1DACE8)

Language: English| [中文简体](README-ZH.md)

The FlexGrid control provides a powerful and quickly way to display data in a tabular format. It is including that frozened column/row,loading more, high performance and better experience in TabBarView/PageView.


|                                                                                                        |                                                                                                |                                                                                               |
| ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/FrozenedRowColumn.gif) | ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/TabView.gif)   | ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/HugeData.gif) |
| ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/Excel.gif)             | ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/StockList.gif) |                                                                                               |




| parameter                                         | description                                                                                                                                            | default            |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------ |
| frozenedColumnsCount                              | The count of forzened columns                                                                                                                          | 0                  |
| frozenedRowsCount                                 | The count of forzened rows                                                                                                                             | 0                  |
| cellBuilder                                       | The builder to create cell                                                                                                                             | required           |
| cellBuilder                                       | The builder to create header                                                                                                                           | required           |
| columnsCount                                      | The count of columns, it should big than 0                                                                                                             | required           |
| [source](#source)                                 | The data source of [FlexGrid]                                                                                                                          | required           |
| [rowWrapper](#rowWrapper)                         | decorate row widget in this call back                                                                                                                  | null               |
| rebuildCustomScrollView                           | rebuild when source is changed, It's from [LoadingMoreCustomScrollView]                                                                                | false              |
| controller                                        | The [ScrollController] on vertical direction                                                                                                           | null               |
| horizontalController                              | The [SyncControllerMixin] for horizontal direction                                                                                                     | null               |
| outerHorizontalSyncController                     | The Outer [SyncControllerMixin], for example [ExtendedTabBarView] or [ExtendedPageView]. It make better experience when scroll on horizontal direction | null               |
| physics                                           | The physics on both horizontal and vertical direction                                                                                                  | null               |
| verticalHighPerformance/horizontalHighPerformance | If true, forces the children to have the given extent(Cell height/width) in the scroll direction.                                                      | false              |
| headerStyle                                       | An immutable style describing how to create header                                                                                                     | CellStyle.header() |
| cellStyle                                         | An immutable style describing how to create cell                                                                                                       | CellStyle.cell()   |
| indicatorBuilder                                  | Widget builder for different loading state, it's from [LoadingMoreCustomScrollView]                                                                    | null               |
| extendedListDelegate                              | A delegate that provides extensions, it's from [LoadingMoreCustomScrollView]                                                                           | null               |
| [headersBuilder](#headersbuilder)                 | The builder to custom the headers of [FlexGrid]                                                                                                        | null               |
| link                                              | if link is true, scroll parent [ExtendedTabView] when [FlexGrid] is over scroll                                                                        | false              |

## source

[FlexGrid.source] is form [loading_more_list](https://github.com/fluttercandies/loading_more_list), LoadingMoreBase is data collection for loading more. override loadData method to load your data. set hasMore to false when it has no more data.

```dart
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
```

## rowWrapper

decorate row widget in this call back.

``` dart
    FlexGrid(
      rowWrapper: (
        BuildContext context,
        T data,
        int row,
        Widget child,
      ) {
        return Column(
          children: <Widget>[
            child,
            const Divider(),
          ],
        );
      },
    );
```


## headersBuilder

you can add anyother headers in this call back.

``` dart
    FlexGrid(
      headersBuilder: (BuildContext b, Widget header) {
        return <Widget>[
          header,
          SliverToBoxAdapter(
            child: PullToRefreshContainer(
                (PullToRefreshScrollNotificationInfo info) {
              return PullToRefreshHeader(
                info,
                source.lastRefreshTime,
              );
            }),
          ),
        ];
      },
    );
``` 