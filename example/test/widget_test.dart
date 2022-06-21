// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_grid_view_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate((Widget widget) {
        var isTextButton = widget is TextButton;
        if (!isTextButton) return false;
        TextButton textButton = widget;
        var isTextButtonChildText = textButton.child is Text;
        if (!isTextButtonChildText) return false;
        Text text = textButton.child! as Text;
        return text.data?.startsWith('Selection stream example') ?? false;
      }),
      findsOneWidget,
    );
  });
}
