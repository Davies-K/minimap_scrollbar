// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimap_scrollbar/minimap_scrollbar.dart';

void main() {
  testWidgets('MinimapScrollbar displays correctly',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimapScrollbarWidget(
            child: SizedBox(
              width: tester.binding.window.physicalSize.width,
              height: tester.binding.window.physicalSize.height,
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Verify if the MinimapScrollbar is present
    expect(find.byType(MinimapScrollbarWidget), findsOneWidget);

    // Verify if the ListView is present
    expect(find.byType(ListView), findsOneWidget);

    // Verify if the ListTiles are present
    expect(find.byType(ListTile), findsWidgets);
  });
}
