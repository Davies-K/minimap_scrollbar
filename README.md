# Minimap Scrollbar

**Minimap Scrollbar** is a Flutter widget that creates a miniature, synchronized view (minimap) of a scrollable content area. It allows users to quickly navigate large content by providing a scaled-down overview, along with a movable highlight that indicates the current viewport position. This widget is ideal for applications with large content, enabling users to jump to specific sections via the minimap.

## Features

- **Interactive Minimap**: A real-time, scaled-down view of the child widget that reflects the current scroll position.
- **Viewport Highlight**: A movable highlight on the minimap that indicates the current visible area of the content.
- **Real-time Updates**: The minimap image is updated periodically to reflect the current state of the child widget.
- **Smooth Navigation**: Users can tap or drag on the minimap to quickly scroll and navigate through the content.
  
## Installation

To use **Minimap Scrollbar** in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  minimap_scrollbar: ^1.0.0# minimap_scrollbar
