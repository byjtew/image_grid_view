import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageGridCase extends StatefulWidget {
  final Uint8List image;
  final int index;
  final Widget Function(BuildContext, int, Uint8List) caseBuilder;
  final ValueNotifier<int> selectionNotifier;
  final BoxDecoration selectedDecoration;
  final BoxDecoration notSelectedDecoration;
  final Function(int, Uint8List) onCaseTap;
  final Function(int, Uint8List) onCaseLongPress;

  const ImageGridCase(this.image,
      {super.key,
      required this.index,
      required this.caseBuilder,
      required this.selectionNotifier,
      required this.selectedDecoration,
      required this.notSelectedDecoration,
      required this.onCaseTap,
      required this.onCaseLongPress});

  bool get selected => selectionNotifier.value == index;

  BoxDecoration get currentDecoration =>
      selected ? selectedDecoration : notSelectedDecoration;

  @override
  createState() => _ImageGridCaseState();
}

class _ImageGridCaseState extends State<ImageGridCase> {
  Widget? caseCache;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        // TODO: implement onEnter
      },
      onExit: (event) {
        // TODO: implement onExit
      },
      child: GestureDetector(
        onTap: () {
          widget.selectionNotifier.value = widget.index;
          widget.onCaseTap(widget.index, widget.image);
        },
        onLongPress: widget.onCaseLongPress(widget.index, widget.image),
        child: ValueListenableBuilder<int>(
            valueListenable: widget.selectionNotifier,
            child: caseCache ??=
                widget.caseBuilder(context, widget.index, widget.image),
            builder: (context, snapshot, w) {
              return Container(
                decoration: widget.currentDecoration,
                child: w,
              );
            }),
      ),
    );
  }
}
