# Minimap Scrollbar

**Minimap Scrollbar** is a Flutter widget designed to enhance navigation in scrollable content areas by providing a miniature, synchronized overview of the content, enabling users to locate and jump to sections effortlessly. It allows users to quickly navigate large content by providing a scaled-down overview seamlessly integrated with Flutter's scrolling mechanisms. The movable highlight dynamically reflects the current viewport position, ensuring smooth and accurate navigation. This widget is ideal for applications with large content, such as code editors, document viewers, or data dashboards, enabling users to jump to specific sections via the minimap.

## Examples
| ![Mini Code Editor](doc/src/assets/example/mini_code_editor.gif) | ![Mini Document](doc/src/assets/example/min_doc.gif) |
|:------------------------------------------------------------------:|:------------------------------------------------------:|
| Mini Code Editor Example                                           | Mini Document Example                                   |

| ![Mini Masonry Grid](doc/src/assets/example/mini_masonry_grid.gif) |
|:--------------------------------------------------------------------:|
| Mini Masonry Grid Example                                            |


## Features

- **Interactive Minimap**: A real-time, scaled-down view of the child widget that reflects the current scroll position.
- **Viewport Highlight**: A movable highlight on the minimap that indicates the current visible area of the content.
- **Real-time Updates**: The minimap image is updated periodically to reflect the current state of the child widget.
- **Smooth Navigation**: Users can tap or drag on the minimap to quickly scroll and navigate through the content.


## Usage

To use the **Minimap Scrollbar** widget in your Flutter project, follow these steps:

1. Import the package:
  ```dart
  import 'package:minimap_scrollbar/minimap_scrollbar.dart';
  ```

2. Wrap your scrollable widget with `MinimapScrollbarWidget`:
  ```dart
  MinimapScrollbarWidget(
    child: SingleChildScrollView(
      child: Column(
        children: List.generate(100, (index) => Text('Item $index')),
      ),
    ),
  );
  ```

3. Customize the `MinimapScrollbarWidget` as needed:
  ```dart
  MinimapScrollbarWidget(
    width: 100,
    height: 200,
    highlightColor: Colors.blue.withOpacity(0.3),
    child: SingleChildScrollView(
      child: Column(
        children: List.generate(100, (index) => Text('Item $index')),
      ),
    ),
  );
  ```

### Properties

- **width**: The width of the minimap.
- **height**: The height of the minimap.
- **highlightColor**: The color of the viewport highlight.
- **updateInterval**: The interval at which the minimap is updated.
- **scrollController**: The scroll controller for the scrollable content.
- **minimapController**: The controller for the minimap.
- **child**: The scrollable widget to be displayed in the minimap.

## Maintainers
- [Davies Kwarteng](https://github.com/davies-k)


## Installation

To use **Minimap Scrollbar** in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  minimap_scrollbar: ^0.1.0
