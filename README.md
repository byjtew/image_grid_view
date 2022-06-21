<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Image Grid View

### Grid view widget for single images.

---

## Documentation

Using similar APIs as the core **Material** library:

- [X] GridImageView.memory
- [X] GridImageView.file
- [ ] GridImageView.network
- [ ] GridImageView.asset

### Parameters

- **width** / **height**: The width and height of the image (at least one of them must be specified).
- **verticalCount**: Number of images per row.
- **horizontalCount**: Number of images per column.
- **caseBuilder**: Function builder for the sub-image.
- placeholder: Placeholder widget for the whole grid view.
- selectedDecoration: BoxDecoration for the selected image.
- unselectedDecoration: BoxDecoration for the unselected image(s).
- onTap: Callback function when an image is tapped.
- onLongPress: Callback function when an image is long pressed.
- selectionStream: Stream of Uint8List of the selected image.
- tryThreading: Whether to try to use threads to load images (recommended to avoid UI blocking).
- quality: Quality (in %) of the image after resizing (if necessary). Default is 100.

### Specifications

- [X] Linux: Tested & stable
- [X] Web: Tested & stable
- [ ] Windows: Not tested yet
- [ ] MacOS: Not tested yet
- [ ] iOS: Not tested yet
- [ ] Android: Not tested yet

### Requirements

- [image](https://pub.dev/packages/image): Dart package used to resize & crop images
- [material](https://api.flutter.dev/flutter/material/material-library.html): Dart core package used to build the UI

## Quickstart

Download the [example app](https://github.com/byjtew/image_grid_view/example) and run it.

```bash
git clone https://github.com/byjtew/image_grid_view.git
cd image_grid_view/example
flutter pub get
flutter run
```

## Contributing

This development of this package is still active.\
Feel free to fork this repository and make a pull request. If you have any questions, please open an issue.