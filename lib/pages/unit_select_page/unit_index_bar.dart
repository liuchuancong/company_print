import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class UnitListIndexBar extends StatefulWidget {
  final GlobalKey parentKey;

  final List<String> symbols;

  final void Function(
    int index,
    Offset cursorOffset,
  )? onSelectionUpdate;

  final void Function()? onSelectionEnd;

  const UnitListIndexBar({
    super.key,
    required this.parentKey,
    required this.symbols,
    this.onSelectionUpdate,
    this.onSelectionEnd,
  });

  @override
  State<UnitListIndexBar> createState() => _UnitListIndexBarState();
}

class _UnitListIndexBarState extends State<UnitListIndexBar> {
  ListObserverController observerController = ListObserverController();

  double observeOffset = 0;

  ValueNotifier<int> selectedIndex = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = ListViewObserver(
      controller: observerController,
      dynamicLeadingOffset: () => observeOffset,
      child: buildListView(),
    );
    resultWidget = GestureDetector(
      onVerticalDragUpdate: _onGestureHandler,
      onVerticalDragDown: _onGestureHandler,
      onVerticalDragCancel: _onGestureEnd,
      onVerticalDragEnd: (DragEndDetails? details) {
        _onGestureEnd();
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  Widget buildListView() {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
      builder: (BuildContext context, int value, Widget? child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final isSelected = value == index;
            final scale = isSelected ? 1.3 : 1.0; // 放大倍数大小
            return GestureDetector(
              onTap: () {
                _onGestureHandler(DragDownDetails(localPosition: Offset(0, index * 20)));
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: scale,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.symbols[index],
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: widget.symbols.length,
        );
      },
    );
  }

  Future<void> _onGestureHandler(dynamic details) async {
    if (details is! DragUpdateDetails && details is! DragDownDetails) return;
    observeOffset = details.localPosition.dy;

    final result = await observerController.dispatchOnceObserve(
      isDependObserveCallback: false,
    );
    final observeResult = result.observeResult;
    // Nothing has changed.
    if (observeResult == null) return;

    final firstChildModel = observeResult.firstChild;
    if (firstChildModel == null) return;
    final firstChildIndex = firstChildModel.index;
    selectedIndex.value = firstChildIndex;

    // Calculate cursor offset.
    final firstChildRenderObj = firstChildModel.renderObject;
    final firstChildRenderObjOffset = firstChildRenderObj.localToGlobal(
      Offset.zero,
      ancestor: widget.parentKey.currentContext?.findRenderObject(),
    );
    final cursorOffset = Offset(
      firstChildRenderObjOffset.dx,
      firstChildRenderObjOffset.dy + firstChildModel.size.width * 0.5,
    );
    widget.onSelectionUpdate?.call(
      firstChildIndex,
      cursorOffset,
    );
  }

  void _onGestureEnd() {
    selectedIndex.value = -1;
    widget.onSelectionEnd?.call();
  }
}
