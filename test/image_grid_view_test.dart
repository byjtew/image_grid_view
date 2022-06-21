import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_grid_view/image_grid_view.dart';

void main() {
  test('Creates a simple 1x1 grid view with memory', () {
    final calculator = ImageGridView.memory(
        Uint8List.fromList(List<int>.generate(4000, (index) => 0)),
        verticalCount: 1,
        horizontalCount: 1,
        caseBuilder: (context, index, image) => Image.memory(image));
  });
}
