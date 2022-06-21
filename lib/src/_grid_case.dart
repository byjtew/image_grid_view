import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageGridCase extends StatelessWidget {
  final Uint8List image;
  final int index;
  final Widget Function(BuildContext, int, Uint8List) caseBuilder;
  final ValueNotifier<int> selectionNotifier;
  final BoxDecoration selectedDecoration;
  final BoxDecoration notSelectedDecoration;
  final Function(int, Uint8List) onCaseTap;
  final Function(int, Uint8List) onCaseLongPress;

  Widget? caseCache;

  ImageGridCase(this.image,
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
          selectionNotifier.value = index;
          onCaseTap(index, image);
        },
        onLongPress: onCaseLongPress(index, image),
        child: ValueListenableBuilder<int>(
            valueListenable: selectionNotifier,
            child: caseCache ??= caseBuilder(context, index, image),
            builder: (context, snapshot, w) {
              return Container(
                decoration: currentDecoration,
                child: w,
              );
            }),
      ),
    );
  }
}
