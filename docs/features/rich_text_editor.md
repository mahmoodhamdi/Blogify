# Rich Text Editor Feature

## Overview
The Rich Text Editor feature allows users to create and edit blog posts with formatted text including bold, italic, underline, headers, lists, code blocks, quotes, and links.

## Implementation Details

### Technology
Uses **flutter_quill** (v11.5.0) - a powerful rich text editor for Flutter that supports:
- Text formatting (bold, italic, underline)
- Headers (H1, H2, H3)
- Numbered and bulleted lists
- Code blocks (with syntax highlighting)
- Block quotes
- Links
- Undo/Redo

### Data Storage Format
Blog content is stored as Quill Delta JSON format in the database. The format looks like:
```json
[
  {"insert": "This is "},
  {"insert": "bold", "attributes": {"bold": true}},
  {"insert": " text.\n"}
]
```

### Backwards Compatibility
The RichTextHelper class handles both:
- Legacy plain text content (auto-converts to Quill document)
- New Quill Delta JSON content

### Application Architecture

#### RichTextEditor Widget (`rich_text_editor.dart`)
- Wraps QuillEditor and QuillSimpleToolbar
- Configurable toolbar with essential formatting buttons
- Supports read-only mode for viewing
- Theme-aware styling (light/dark mode)

#### RichTextHelper Utility Class
- `documentToJson()`: Convert Quill document to JSON for storage
- `jsonToDocument()`: Convert JSON to Quill document for editing
- `createController()`: Create QuillController from any content type
- `isQuillJson()`: Check if content is Quill delta format
- `documentToPlainText()`: Extract plain text from document

### UI Components

#### Create Blog Page (AddNewBlogPage)
- Rich text editor for content with toolbar
- Toolbar buttons: Bold, Italic, Underline, Headers, Lists, Code, Quote, Link, Undo, Redo
- Clear format option
- Validates content before submission

#### Edit Blog Page (EditBlogPage)
- Pre-loads existing content into rich text editor
- Same toolbar functionality as create page
- Preserves formatting on update

#### View Blog Page (BlogViewerPage)
- Renders rich text content with custom styling
- Theme-aware colors for text, code blocks, quotes
- Links are clickable and styled with accent color
- Read-only QuillEditor for viewing

### Styling Customization
The viewer page uses custom DefaultStyles for:
- **Paragraph**: 18px, 1.6 line height
- **Headers**: H1 (28px), H2 (24px), H3 (20px) - all bold
- **Code blocks**: Monospace font, green color, gray background
- **Quotes**: Italic, 4px accent-colored left border
- **Links**: Accent color with underline

## How to Use

### Creating Rich Text Content
1. Open "Create Blog" page
2. Use the toolbar to format text:
   - **B**: Bold text
   - **I**: Italic text
   - **U**: Underline text
   - **H1/H2/H3**: Header styles
   - **1.**: Numbered list
   - **•**: Bulleted list
   - **</>**: Inline code
   - **{ }**: Code block
   - **"**: Block quote
   - **🔗**: Insert link
   - **↩/↪**: Undo/Redo

### Editing Existing Blogs
1. Open the blog you want to edit
2. Tap the edit button
3. Modify content using the rich text editor
4. Tap "Update Blog" to save

### Keyboard Shortcuts (Desktop)
- **Ctrl+B**: Bold
- **Ctrl+I**: Italic
- **Ctrl+U**: Underline
- **Ctrl+Z**: Undo
- **Ctrl+Y**: Redo

## Files Created/Modified

### Created Files
- `lib/features/blog/presentation/widgets/rich_text_editor.dart`

### Modified Files
- `pubspec.yaml` (added flutter_quill dependency)
- `lib/features/blog/presentation/pages/add_new_blog_page.dart`
- `lib/features/blog/presentation/pages/edit_blog_page.dart`
- `lib/features/blog/presentation/pages/blog_viewer_page.dart`

## Dependencies
```yaml
flutter_quill: ^11.5.0
```

## Migration Notes
- Existing plain text blogs will automatically render correctly
- New blogs will be stored in Quill Delta JSON format
- No database schema changes required
- Content field remains TEXT type in the blogs table

## Architecture Flow
1. User writes content using QuillEditor with toolbar
2. On save, QuillController.document is converted to JSON
3. JSON string is stored in blog.content field
4. On view, content is checked for JSON format
5. If JSON, parsed into Quill Document
6. If plain text, converted to simple Document
7. QuillEditor renders the document (read-only mode)
