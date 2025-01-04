// import 'package:example/masonry_grid/masonry_grid.dart';
// import 'package:example/super_editor/super_editor_demo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'code_editor/mini_code_editor.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
    theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
        ),
      ),
   
    /// A widget that displays a mini code editor with a horizontal scrollbar.
    /// from examples/list_gen/lib/code_editor/mini_code_editor.dart
    /// [CodeEditor]
    home: const CodeEditor(),

    /// A widget that displays a simple document editor with a vertical scrollbar.
    /// from examples/list_gen/lib/super_editor/super_editor_demo.dart
    /// [SimpleDocumentEditor]
    // home: const SimpleDocumentEditor(),

    /// A widget that displays a mini masonry grid with random colors and a horizontal scrollbar.
    /// from examples/list_gen/lib/masonry_grid/masonry_grid.dart
    /// [MiniMasonryGrid]
    //  home: const MiniMasonryGrid(),
    debugShowCheckedModeBanner: false,
  ));
}

