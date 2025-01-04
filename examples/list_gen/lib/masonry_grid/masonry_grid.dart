import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimap_scrollbar/minimap_scrollbar.dart';

/// Generates a random color using the [Random] class.
Color _getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

final _imageAssets = [
  'assets/memoji/1.png',
  'assets/memoji/2.png',
  'assets/memoji/4.png',
  'assets/memoji/7.png',
  'assets/memoji/9.png',
];

/// Builds a box with specified dimensions and a random background color.
Widget _buildBox(double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: _getRandomColor(),
    ),
    child: Center(
      child: _Avatar(
        image: _imageAssets[Random().nextInt(_imageAssets.length)],
      ),
    ),
  );
}

/// A widget that displays a mini masonry grid with random colors and a horizontal scrollbar.
class MiniMasonryGrid extends StatelessWidget {
  const MiniMasonryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mini Masonry Grid',
          style: GoogleFonts.lato(fontSize: 18),
        ),
      ),
      body: MinimapScrollbarWidget(
        position: MinimapPosition.bottom,
        miniSize: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                50,
                (index) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: index % 3 == 0
                        ? _ContainerMixer(isRotated: index % 2 == 0)
                        : _buildBox(250, 250)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a container with a combination of small and large boxes.
class _ContainerMixer extends StatelessWidget {
  const _ContainerMixer({
    this.isRotated = true,
  });

  final bool isRotated;

  @override
  Widget build(BuildContext context) {
    final baseContainer = _buildBox(250, 122.5);
    final rowWidget = Row(children: [
      _buildBox(122.5, 122.5),
      const SizedBox(width: 5),
      _buildBox(122.5, 122.5),
    ]);
    return SizedBox(
      height: 250,
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isRotated ? rowWidget : baseContainer,
          const SizedBox(height: 5),
          isRotated ? baseContainer : rowWidget,
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Image(
        height: 80,
        image: AssetImage(image),
      ),
    );
  }
}
