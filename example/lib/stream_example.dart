import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_grid_view/image_grid_view.dart';

class StreamExamplePage extends StatelessWidget {
  final StreamController<Uint8List?> _selectionStream = StreamController();

  StreamExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImageGridView example app'),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          bool portrait = constraints.maxWidth < constraints.maxHeight;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: _orientedParent(context, [
                const SizedBox(width: 10, height: 10),
                ImageGridView.file(
                  File("assets/vertical.jpg"),
                  verticalCount: 5,
                  horizontalCount: 2,
                  caseBuilder: (context, int index, Uint8List image) =>
                      Image.memory(image),
                  height: (portrait
                          ? constraints.maxWidth
                          : constraints.maxHeight) *
                      .9,
                  selectionStream: _selectionStream,
                  notSelectedDecoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  selectedDecoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                ),
                const SizedBox(width: 16, height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87)),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text("Selection stream"),
                        Expanded(
                          child: Center(
                            child: StreamBuilder<Uint8List?>(
                              stream: _selectionStream.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Column(
                                    children: [
                                      Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Text("No selection");
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          );
        }),
      ),
    );
  }

  Widget _orientedParent(BuildContext context, List<Widget> children) {
    bool portrait =
        MediaQuery.of(context).size.width >= MediaQuery.of(context).size.height;
    return portrait
        ? Row(
            children: children,
          )
        : Column(
            children: children,
          );
  }
}
