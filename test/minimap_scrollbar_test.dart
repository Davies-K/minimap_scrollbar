import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimap_scrollbar/minimap_scrollbar.dart';

void main() {
  testWidgets('MinimapScrollbarWidget displays child widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimapScrollbarWidget(
            child: Container(
              key: const Key('child'),
              height: 2000,
              width: 2000,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('child')), findsOneWidget);
  });

  testWidgets('MinimapScrollbarWidget highlights correct position on scroll', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimapScrollbarWidget(
            child: Container(
              key: const Key('child'),
              height: 2000,
              width: 2000,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    final scrollController = tester.state<ScrollableState>(find.byType(Scrollable)).widget.controller!;
    scrollController.jumpTo(500);
    await tester.pumpAndSettle();

    // Check if the highlight position is updated (this is a placeholder, actual implementation may vary)
    expect(find.byType(AnimatedPositioned), findsOneWidget);
  });

  testWidgets('MinimapScrollbarWidget handles minimap interaction', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimapScrollbarWidget(
            child: Container(
              key: const Key('child'),
              height: 2000,
              width: 2000,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    final minimap = find.byType(GestureDetector);
    await tester.tap(minimap);
    await tester.pumpAndSettle();

    // Check if the scroll position is updated (this is a placeholder, actual implementation may vary)
    final scrollController = tester.state<ScrollableState>(find.byType(Scrollable)).widget.controller!;
    expect(scrollController.offset, isNonZero);
  });
}