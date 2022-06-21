import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_grid_view/src/_core_routines.dart';
import 'package:image_grid_view/src/_grid_case.dart';

class ImageGridView extends StatefulWidget {
  final Completer<List<Uint8List>> _cropsCompleter = Completer();

  late final int _verticalCount, _horizontalCount;
  late final Widget Function(BuildContext, int, Uint8List) _caseBuilder;
  late final Widget _placeholder;
  late final BoxDecoration _selectedDecoration;
  late final BoxDecoration _notSelectedDecoration;
  late final Function(int, Uint8List) _onTap;
  late final Function(int, Uint8List) _onLongPress;
  late final StreamController<Uint8List?>? _selectionStream;
  late final bool _tryThreading;
  late final double _width, _height;
  late final int _quality;

  ImageGridView._(
    Uint8List originalImageBytes, {
    super.key,
    required int verticalCount,
    required int horizontalCount,
    required Widget Function(BuildContext, int, Uint8List) caseBuilder,
    required Widget? placeholder,
    required BoxDecoration? selectedDecoration,
    required BoxDecoration? notSelectedDecoration,
    required Null Function(int, Uint8List)? onTap,
    required Null Function(int, Uint8List)? onLongPress,
    required StreamController<Uint8List?>? selectionStream,
    required bool tryThreading,
    required double? width,
    required double? height,
    required int quality,
  }) {
    if (verticalCount < 1 || horizontalCount < 1) {
      throw ArgumentError(
          'verticalCount and horizontalCount must be greater than 0');
    }

    _verticalCount = verticalCount;
    _horizontalCount = horizontalCount;
    _caseBuilder = caseBuilder;
    _placeholder =
        placeholder ?? const Center(child: CircularProgressIndicator());
    _selectedDecoration = selectedDecoration ?? _defaultSelectedDecoration;
    _notSelectedDecoration =
        notSelectedDecoration ?? _defaultNotSelectedDecoration;
    _onTap = onTap ?? (i, b) {};
    _onLongPress = onLongPress ?? (i, b) {};
    _selectionStream = selectionStream;
    _tryThreading = tryThreading;

    // Get the width and height of the originalImage.
    imglib.Image originalImage = CoreRoutines.decodeImage(originalImageBytes);
    double imageAspectRatio = originalImage.width / originalImage.height;
    if (width == null && height == null) {
      throw ArgumentError('Either width or height must be specified');
    } else if (width == null) {
      _width = height! * imageAspectRatio;
      _height = height;
    } else if (height == null) {
      _width = width;
      _height = width / imageAspectRatio;
    } else {
      _width = width;
      _height = height;
    }

    _quality = quality;

    _createCases(originalImage);
  }

  factory ImageGridView.memory(
    Uint8List bytes, {
    Key? key,
    required int verticalCount,
    required int horizontalCount,
    required Widget Function(BuildContext, int, Uint8List) caseBuilder,
    Widget? placeholder,
    BoxDecoration? selectedDecoration,
    BoxDecoration? notSelectedDecoration,
    Null Function(int, Uint8List)? onTap,
    Null Function(int, Uint8List)? onLongPress,
    StreamController<Uint8List?>? selectionStream,
    bool tryThreading = true,
    double? width,
    double? height,
    int quality = 100,
  }) =>
      ImageGridView._(bytes,
          key: key,
          verticalCount: verticalCount,
          horizontalCount: horizontalCount,
          caseBuilder: caseBuilder,
          placeholder: placeholder,
          selectedDecoration: selectedDecoration,
          notSelectedDecoration: notSelectedDecoration,
          onTap: onTap,
          onLongPress: onLongPress,
          selectionStream: selectionStream,
          tryThreading: tryThreading,
          width: width,
          height: height,
          quality: quality);

  factory ImageGridView.file(
    File file, {
    Key? key,
    required int verticalCount,
    required int horizontalCount,
    required Widget Function(BuildContext, int, Uint8List) caseBuilder,
    Widget? placeholder,
    BoxDecoration? selectedDecoration,
    BoxDecoration? notSelectedDecoration,
    Null Function(int, Uint8List)? onTap,
    Null Function(int, Uint8List)? onLongPress,
    StreamController<Uint8List?>? selectionStream,
    bool tryThreading = true,
    double? width,
    double? height,
    int quality = 100,
  }) {
    if (kDebugMode && !file.existsSync()) {
      throw ArgumentError('File does not exist');
    }
    return ImageGridView._(file.readAsBytesSync(),
        key: key,
        verticalCount: verticalCount,
        horizontalCount: horizontalCount,
        caseBuilder: caseBuilder,
        placeholder: placeholder,
        selectedDecoration: selectedDecoration,
        notSelectedDecoration: notSelectedDecoration,
        onTap: onTap,
        onLongPress: onLongPress,
        selectionStream: selectionStream,
        tryThreading: tryThreading,
        width: width,
        height: height,
        quality: quality);
  }

  static const BorderSide _defaultSelectedBorderSide =
      BorderSide(color: Colors.white, width: 1);

  static const BoxDecoration _defaultSelectedDecoration = BoxDecoration(
      border: Border(
    top: _defaultSelectedBorderSide,
    left: _defaultSelectedBorderSide,
    right: _defaultSelectedBorderSide,
    bottom: _defaultSelectedBorderSide,
  ));

  static const BoxDecoration _defaultNotSelectedDecoration = BoxDecoration();

  void _internalOnTap(int index, Uint8List image) {
    _selectionStream?.add(image);
    _onTap.call(index, image);
  }

  void _internalOnLongPress(int index, Uint8List image) {
    _onLongPress.call(index, image);
  }

  void _createCases(imglib.Image originalImage) {
    var parameters = ScaleAndCropTaskParameters(originalImage, _width, _height,
        _horizontalCount, _verticalCount, _quality);
    if (_tryThreading) {
      _cropsCompleter
          .complete(compute(CoreRoutines.scaleAndCropTaskWorkflow, parameters));
    } else {
      _cropsCompleter
          .complete(CoreRoutines.scaleAndCropTaskWorkflow(parameters));
    }
  }

  @override
  State<StatefulWidget> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  final List<Widget> _cases = [];
  final ValueNotifier<int> _selectionNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width.toDouble(),
      height: widget._height.toDouble(),
      child: FutureBuilder<List<Uint8List>>(
          future: widget._cropsCompleter.future,
          builder: (context, AsyncSnapshot<List<Uint8List>> cropsSnapshot) {
            if (cropsSnapshot.hasError) {
              return Center(
                child: Text('Error: ${cropsSnapshot.error}'),
              );
            }
            if (!cropsSnapshot.hasData) return widget._placeholder;
            if (cropsSnapshot.data == null) {
              return const Center(
                child: Text('Error: crops are null'),
              );
            }

            return Column(
              children: List.generate(
                widget._verticalCount,
                (index) => SizedBox(
                  width: widget._width,
                  height: widget._height / widget._verticalCount,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(widget._horizontalCount, (y) {
                      int i = index * widget._horizontalCount + y;
                      if (_cases.length == i) {
                        _cases.add(SizedBox(
                          width: widget._width / widget._horizontalCount,
                          height: widget._height / widget._verticalCount,
                          child: ImageGridCase(
                            cropsSnapshot.data![i],
                            caseBuilder: widget._caseBuilder,
                            index: i,
                            onCaseTap: widget._internalOnTap,
                            onCaseLongPress: widget._internalOnLongPress,
                            notSelectedDecoration:
                                widget._notSelectedDecoration,
                            selectedDecoration: widget._selectedDecoration,
                            selectionNotifier: _selectionNotifier,
                          ),
                        ));
                      }
                      return _cases[i];
                    }),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
