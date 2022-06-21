import 'package:flutter/material.dart';
import 'package:image_grid_view_example/stream_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'ImageGridView',
        home: MyHome(),
      );
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ImageGridView example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select an example:',
                  style: Theme.of(context).textTheme.headline3),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StreamExamplePage(),
                  ),
                ),
                child: const Text('Selection stream example'),
              ),
              const SizedBox(height: 16),
              TextButton(
                child: const Text('State example'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => throw UnimplementedError()),
                ),
              ),
            ],
          ),
        ),
      );
}
