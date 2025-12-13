import 'package:blogify/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  final String? replyToName;
  final String? initialContent;
  final bool isEditing;
  final Function(String content) onSubmit;
  final VoidCallback? onCancel;

  const CommentInput({
    super.key,
    this.replyToName,
    this.initialContent,
    this.isEditing = false,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);
    widget.onSubmit(content);
    _controller.clear();
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor =
        isDarkMode ? AppPalette.darkSurface : AppPalette.lightSurface;
    final textColor = isDarkMode ? AppPalette.darkText : AppPalette.lightText;
    final primaryColor =
        isDarkMode ? AppPalette.darkPrimary : AppPalette.lightPrimary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: textColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply indicator or editing indicator
          if (widget.replyToName != null || widget.isEditing) ...[
            Row(
              children: [
                Icon(
                  widget.isEditing ? Icons.edit : Icons.reply,
                  size: 16,
                  color: primaryColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.isEditing
                        ? 'Editing comment'
                        : 'Replying to ${widget.replyToName}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (widget.onCancel != null)
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: textColor.withValues(alpha: 0.6),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.isEditing
                        ? 'Edit your comment...'
                        : widget.replyToName != null
                            ? 'Write a reply...'
                            : 'Write a comment...',
                    hintStyle: TextStyle(
                      color: textColor.withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? AppPalette.darkBackground
                        : AppPalette.lightBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  maxLines: 3,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                icon: _isSubmitting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: primaryColor,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
