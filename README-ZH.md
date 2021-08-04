# flex_grid

[![pub package](https://img.shields.io/pub/v/flex_grid.svg)](https://pub.dartlang.org/packages/flex_grid) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/network) [![GitHub license](https://img.shields.io/github/license/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/flex_grid)](https://github.com/fluttercandies/flex_grid/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

Language: [English](README.md)| 中文简体

FlexGrid 可以帮助快速创建表格形式的视图。它支持锁定行列，增量加载，提供高性能，拥有在 TabbarView/PageView 中更好的滚动体验。


| |      |      |
| ---- | ---- | ---- |
|   ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/FrozenedRowColumn.gif)    |  ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/TabView.gif)     |  ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/HugeData.gif)     |
|  ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/Excel.gif)     |  ![](https://github.com/fluttercandies/flutter_candies/blob/master/gif/flex_grid/StockList.gif)    |      |




|  参数    |   描述   |   默认   |
| ---- | ---- | ---- |
|   frozenedColumnsCount   |   锁定列的个数   |    0  |
|   frozenedRowsCount   |   锁定行的个数   |    0  |
|   cellBuilder   |   用于创建表格的回调  |  required     |
|   headerBuilder   |   用于创建表头的回调  |  required     |
|   columnsCount   |   列的个数，必须大于0   |   required   |
|   [source](#source)   |  [FlexGrid] 的数据源   |   required   |
|   [rowWrapper](#rowWrapper)   |   在这个回调里面用于装饰 row Widget   |   null   |
|   rebuildCustomScrollView   |  当数据源改变的时候是否重新 build ， 它来自 [LoadingMoreCustomScrollView]   |  false    |
|   controller   |  垂直方向的 [ScrollController]    |   null   |
|   horizontalController   |   水平方向的 [SyncControllerMixin]   |  null    |
|   outerHorizontalSyncController   |   外部的 [SyncControllerMixin], 用在 [ExtendedTabBarView] 或者 [ExtendedPageView] 上面，让水平方法的滚动更连续   |   null   |
|   physics   |   水平和垂直方法的  [ScrollPhysics]  |   null   |
|   highPerformance   |   如果为true的话,  将强制水平和垂直元素的大小，以提高滚动的性能  |   false   |
|   headerStyle   |     样式用于来描述表头 |   CellStyle.header()   |
|   cellStyle   |  样式用于来描述表格    |  CellStyle.cell()     |
|  indicatorBuilder    |  用于创建不同加载状态的回调, 它来自  [LoadingMoreCustomScrollView]    |    null  |
|   extendedListDelegate   |  用于设置一些扩展功能的设置, 它来自  [LoadingMoreCustomScrollView]    |   null   |
|   [headersBuilder](#headersbuilder)   |   用于创建自定义的表头   |  null  |


## source

[FlexGrid.source] 来自组件 [loading_more_list](https://github.com/fluttercandies/loading_more_list), 你需要继承LoadingMoreBase 来实现加载更多的数据源. 通过重写 loadData 方法来加载数据. 当没有数据的时候记得把 hasMore 设置为 false.

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

在这个回调里面可以用于装饰每一行 Widget

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

用于创建自定义的表头

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