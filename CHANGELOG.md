## 5.0.0

* Breaking Change: headersBuilder are not require a list of sliver now.
* add frozenedTrailingColumnsCount to support frozen column at the end of this row
* add showGlowLeading/showGlowTrailing/showHorizontalGlowLeading/showHorizontalGlowTrailing to control whether show the overscroll glow.
* add footerBuilder/footerStyle

## 4.0.0

* refactor code (sync_scroll_library)
* breaking change: SyncPageController to LinkPageController
* add getHeight and getWidth for [CellStyle] to override height and width base on row/column
* fix simulation scroll is not sync (sync_scroll_library)

## 3.0.1

* add cell height limit for rowWrapper callback
* fix cellstyle and headerstyle not working after they are changed

## 3.0.0

* Breaking Change: add horizontalHighPerformance and verticalHighPerformance instead of highPerformance

## 2.0.1

* Change default horizontal physics to NeverScrollableScrollPhysics
* Add [FlexGrid.horizontalPhysics]

## 2.0.0

* Add [FlexGrid.link] to link with [ExtendedTabView] when [FlexGrid] is overscroll
* Breaking Change: remove [FlexGrid.outerHorizontalSyncController]
* Implements with SyncControllerMixin, SyncScrollStateMinxin [sync_scroll_library]

## 1.0.0

* BreakingChange: remove [FlexGrid.rebuildCustomScrollView]

## 0.3.1

* Fix indicatorBuilder is not working.

## 0.3.0

* Public methods in HorizontalSyncScrollMinxin.

## 0.2.0

* Public classes.

## 0.1.0

* First Release.
