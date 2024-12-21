import 'package:example/super_editor_demo.dart';
import 'package:flutter/material.dart';

class MinimapListGenExample extends StatelessWidget {
  const MinimapListGenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimap Scrollbar Example'),
      ),
      body: SimpleDocumentEditor()
      // body: MinimapScrollbarWidget(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: List.generate(
      //         100,
      //         (index) => Container(
      //           margin: const EdgeInsets.all(8),
      //           padding: const EdgeInsets.all(16),
      //           decoration: BoxDecoration(
      //             color: Colors.blue.withOpacity(0.1),
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           child: Text(
      //             'Section ${index + 1}\nThis is some sample content to demonstrate scrolling.',
      //             style: const TextStyle(fontSize: 16),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
void main() {
  runApp(const MaterialApp(
    home: MinimapListGenExample(),
    debugShowCheckedModeBanner: false,
  ));
}