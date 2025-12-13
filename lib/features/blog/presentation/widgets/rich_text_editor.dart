import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextEditor extends StatefulWidget {
  final QuillController controller;
  final String hintText;
  final bool readOnly;
  final double? minHeight;
  final FocusNode? focusNode;

  const RichTextEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    this.minHeight,
    this.focusNode,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.readOnly) {
      return QuillEditor.basic(
        controller: widget.controller,
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: widget.controller,
                config: QuillSimpleToolbarConfig(
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: false,
                  showInlineCode: true,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showClearFormat: true,
                  showAlignmentButtons: false,
                  showLeftAlignment: false,
                  showCenterAlignment: false,
                  showRightAlignment: false,
                  showJustifyAlignment: false,
                  showHeaderStyle: true,
                  showListNumbers: true,
                  showListBullets: true,
                  showListCheck: false,
                  showCodeBlock: true,
                  showQuote: true,
                  showIndent: false,
                  showLink: true,
                  showUndo: true,
                  showRedo: true,
                  showDirection: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showSmallButton: false,
                  showDividers: true,
                  showFontFamily: false,
                  showFontSize: false,
                  showClipboardCut: false,
                  showClipboardCopy: false,
                  showClipboardPaste: false,
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    base: QuillToolbarBaseButtonOptions(
                      iconTheme: QuillIconTheme(
                        iconButtonSelectedData: IconButtonData(
                          color: theme.colorScheme.primary,
                        ),
                        iconButtonUnselectedData: IconButtonData(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: widget.minHeight ?? 200,
                ),
                padding: const EdgeInsets.all(12),
                child: QuillEditor.basic(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  config: QuillEditorConfig(
                    placeholder: widget.hintText,
                    autoFocus: false,
                    padding: EdgeInsets.zero,
                    scrollable: true,
                    expands: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helper class for converting between Quill Delta and JSON string
class RichTextHelper {
  /// Convert Quill document to JSON string for storage
  static String documentToJson(Document document) {
    return jsonEncode(document.toDelta().toJson());
  }

  /// Convert JSON string to Quill document
  static Document jsonToDocument(String json) {
    try {
      final deltaJson = jsonDecode(json) as List;
      return Document.fromJson(deltaJson);
    } catch (e) {
      // If parsing fails, create a document with the string as plain text
      return Document()..insert(0, json);
    }
  }

  /// Convert plain text to Quill document
  static Document plainTextToDocument(String text) {
    return Document()..insert(0, text);
  }

  /// Get plain text from Quill document
  static String documentToPlainText(Document document) {
    return document.toPlainText().trim();
  }

  /// Check if content is Quill delta JSON
  static bool isQuillJson(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is List && decoded.isNotEmpty) {
        final first = decoded.first;
        return first is Map && first.containsKey('insert');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Create QuillController from content (handles both JSON and plain text)
  static QuillController createController(String? content) {
    if (content == null || content.isEmpty) {
      return QuillController.basic();
    }

    if (isQuillJson(content)) {
      return QuillController(
        document: jsonToDocument(content),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      return QuillController(
        document: plainTextToDocument(content),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }
}
