import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LengthSelector extends StatelessWidget {
  final int end;
  final int start;

  final String unit;

  final TextStyle unitStyle;

  final TextStyle valueStyle;

  final CupertinoPickerDefaultSelectionOverlay selectionOverlay;
  final Function(String, int)? onSelectedItemChanged;
  final int initialItemIndex;

  final String identifier;

  const LengthSelector({
    Key? key,
    required this.end,
    required this.start,
    this.initialItemIndex = 0,
    this.unit = "",
    required this.identifier,
    this.onSelectedItemChanged,
    this.unitStyle = const TextStyle(color: Colors.grey),
    this.valueStyle = const TextStyle(color: Colors.grey),
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(
      capStartEdge: false,
      capEndEdge: false,
      background: Colors.transparent,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int range = end - start + 1;
    int currentNum = start;
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: CupertinoPicker.builder(
              scrollController:
                  FixedExtentScrollController(initialItem: initialItemIndex),
              itemExtent: 42,
              selectionOverlay: selectionOverlay,
              childCount: range,
              itemBuilder: (context, index) {
                return Text(
                  "${index + start}",
                  style: valueStyle,
                );
              },
              onSelectedItemChanged: (int _index) {
                if (end <= 0) return;
                var index = _index % end;
                currentNum = _index + 1;

                if (onSelectedItemChanged != null) {
                  onSelectedItemChanged!(identifier, _index);
                } else {
                  //do nothing
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              unit,
              style: unitStyle,
            ),
          )
        ],
      ),
    );
  }
}

class LengthSelectorGroup extends StatelessWidget {
  final List<LengthSelector> selectors;
  final Function(Map<String, int>) onItemsChanged;

  bool hidden;

  LengthSelectorGroup(
      {this.selectors = const [],
      required this.onItemsChanged,
      required this.hidden});

  @override
  Widget build(BuildContext context) {
    Map<String, int> values = {};

    selectors.forEach(((element) {
      values[element.identifier] = element.start + element.initialItemIndex;
    }));

    double? pollLengthHeight;

    if (hidden) {
      pollLengthHeight = 0;
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          height: pollLengthHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: selectors.map((widget) {
              returnFunction(String identifer, int value) {
                if (widget.onSelectedItemChanged != null) {
                  widget.onSelectedItemChanged!(identifer, value);
                } else {
                  //do nothing
                }
                values[identifer] = value;

                onItemsChanged(values);
              }

              LengthSelector widgetCopy = widget;

              return LengthSelector(
                end: widget.end,
                start: widget.start,
                identifier: widget.identifier,
                key: widget.key,
                initialItemIndex: widget.initialItemIndex,
                unit: widget.unit,
                onSelectedItemChanged: returnFunction,
                unitStyle: widget.unitStyle,
                valueStyle: widget.valueStyle,
                selectionOverlay: widget.selectionOverlay,
              );
            }).toList(),
          ),
        ),
        !hidden ? LengthSelectorOverlay() : Container()
      ],
    );
  }
}

class LengthSelectorOverlay extends StatelessWidget {
  final double height;

  final BoxDecoration decoration;

  const LengthSelectorOverlay({
    this.decoration = const BoxDecoration(
      color: Color.fromARGB(57, 73, 66, 66),
      borderRadius: BorderRadius.all(
        Radius.circular(3),
      ),
    ),
    this.height = 40,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: DecoratedBox(
          decoration: decoration,
          child: Container(),
        ),
      ),
    );
  }
}
