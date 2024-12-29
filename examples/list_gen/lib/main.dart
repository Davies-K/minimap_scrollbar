import 'dart:math';

import 'package:example/super_editor_demo.dart';
import 'package:flutter/material.dart';
import 'package:minimap_scrollbar/minimap_scrollbar.dart';

class MinimapListGenExample extends StatelessWidget {
  const MinimapListGenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimap Scrollbar Example'),
      ),
      //  body: const SimpleDocumentEditor(), 

      //  body: MinimapScrollbarWidget(
      //   position: MinimapPosition.bottom,
      //    child: SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child: Row(
      //       children: List.generate(
      //         50, // Number of containers
      //         (index) => Container(
      //           width: 500,
      //           height: 500,
      //           color: _getRandomColor(),
      //           alignment: Alignment.center,
      //           margin: const EdgeInsets.all(8),
      //           child: Text(
      //             'Container ${index + 1}',
      //             style: const TextStyle(
      //               color: Colors.white,
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //          ),
      //  ),
    


      body: MinimapScrollbarWidget(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              100,
              (index) => Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Section ${index + 1}\nThis is some sample content to demonstrate scrolling.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

   Color _getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
void main() {
  runApp(const MaterialApp(
    home: MinimapListGenExample(),
    debugShowCheckedModeBanner: false,
  ));
}