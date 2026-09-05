class HtmlUtils {
  HtmlUtils._();

  /// Strips HTML tags and decodes common HTML entities for clean UI presentation
  static String stripHtml(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return '';

    // Replace common block tags with newlines
    String text = htmlString
        .replaceAll(RegExp(r'</p>|</div>|<br\s*/?>|</li>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false), '');

    // Decode common HTML entities
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—');

    // Clean up excessive blank lines
    text = text.replaceAll(RegExp(r'\n\s*\n+'), '\n\n').trim();

    return text;
  }
}
