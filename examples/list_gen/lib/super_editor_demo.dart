import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:minimap_scrollbar/minimap_scrollbar.dart';

class SimpleDocumentEditor extends StatefulWidget {
  const SimpleDocumentEditor({super.key});

  @override
  State<SimpleDocumentEditor> createState() => _SimpleDocumentEditorState();
}

class _SimpleDocumentEditorState extends State<SimpleDocumentEditor> {
  late MutableDocument _document;

  @override
  void initState() {
    super.initState();
    _document = _createInitialDocument();
  }

  MutableDocument _createInitialDocument() {
    return MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText('Welcome to the Document Editor with Minimap'),
        ),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(
            'This is a sample document to demonstrate the scrolling and minimap functionality.',
          ),
        ),
        for (int i = 1; i <= 20; i++)
          ParagraphNode(
            id: DocumentEditor.createNodeId(),
            text: AttributedText(
              'Section $i - Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
              'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
              'nisi ut aliquip ex ea commodo consequat.',
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MinimapScrollbarWidget(
      child: Column(
        children: [
          SuperEditor(
            editor: DocumentEditor(document: _document),
            stylesheet: defaultStylesheet.copyWith(
              documentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              // paragraph: defaultStylesheet.paragraph?.copyWith(
              //   style: const TextStyle(
              //     fontSize: 16,
              //     height: 1.4,
              //   ),
              // ),
            ),
            componentBuilders: defaultComponentBuilders,
          ),
        ],
      ),
    );
  }
}