import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';

/// Renders Flo HTML snippets (`<b>`, `<span class="pos|neg">`) from briefing / text blocks.
class FloHtmlText extends StatelessWidget {
  const FloHtmlText(
    this.html, {
    super.key,
    this.style,
  });

  final String html;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style ??
            const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: FloTheme.ink2,
            ),
        children: parseFloHtml(html),
      ),
    );
  }
}

List<InlineSpan> parseFloHtml(String raw) {
  var html = raw
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&#8217;', "'")
      .replaceAll('\u2019', "'");

  final spans = <InlineSpan>[];
  final tagRe = RegExp(
    r'''<(/?)(b|span)(?:\s+class=(?:'|")?(pos|neg)(?:'|")?)?\s*>''',
    caseSensitive: false,
  );

  var pos = 0;
  var bold = false;
  Color? tone;

  void addText(String text) {
    if (text.isEmpty) return;
    spans.add(TextSpan(
      text: text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        color: tone ?? (bold ? FloTheme.ink1 : null),
      ),
    ));
  }

  for (final match in tagRe.allMatches(html)) {
    addText(html.substring(pos, match.start));
    pos = match.end;

    final closing = match.group(1) == '/';
    final tag = match.group(2);
    if (closing) {
      if (tag == 'b') bold = false;
      if (tag == 'span') tone = null;
    } else {
      if (tag == 'b') bold = true;
      if (tag == 'span') {
        final cls = match.group(3);
        tone = cls == 'neg'
            ? FloTheme.lossInk
            : cls == 'pos'
                ? FloTheme.gainInk
                : null;
        if (cls == 'neg' || cls == 'pos') bold = true;
      }
    }
  }
  addText(html.substring(pos));
  return spans.isEmpty ? [const TextSpan(text: '')] : spans;
}
