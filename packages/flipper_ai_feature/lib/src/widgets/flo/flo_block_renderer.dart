import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';
import 'flo_charts.dart';
import 'flo_icons.dart';

typedef FloAskCallback = void Function(String question);

const _swatchColors = [
  Color(0xFF2563EB),
  Color(0xFF22D3EE),
  Color(0xFF10B981),
  Color(0xFFFB9D00),
  Color(0xFFE5484D),
  Color(0xFF7C3AED),
];

/// Renders Flo answer blocks per Handover §8.
class FloBlockRenderer extends StatelessWidget {
  const FloBlockRenderer({
    super.key,
    required this.blocks,
    this.onAsk,
    this.isMobile = false,
  });

  final List<Map<String, dynamic>> blocks;
  final FloAskCallback? onAsk;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          _Block(
            block: blocks[i],
            onAsk: onAsk,
            isMobile: isMobile,
          ),
          if (i < blocks.length - 1) const SizedBox(height: 13),
        ],
      ],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.block,
    this.onAsk,
    required this.isMobile,
  });

  final Map<String, dynamic> block;
  final FloAskCallback? onAsk;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final type = block['type'] as String? ?? 'text';
    switch (type) {
      case 'text':
        return _TextBlock(html: block['html']?.toString() ?? '');
      case 'metrics':
        return _MetricsBlock(
          cols: (block['cols'] as num?)?.toInt() ?? (isMobile ? 2 : 4),
          items: (block['items'] as List?)?.cast<Map>() ?? const [],
          isMobile: isMobile,
        );
      case 'viz':
        return _VizBlock(block: block);
      case 'table':
        return _TableBlock(block: block);
      case 'callout':
        return _CalloutBlock(block: block);
      case 'source':
        return _SourceBlock(items: (block['items'] as List?)?.cast() ?? const []);
      case 'actions':
        return _ActionsBlock(items: (block['items'] as List?)?.cast() ?? const []);
      case 'followups':
        return _FollowupsBlock(
          items: (block['items'] as List?)?.cast() ?? const [],
          onAsk: onAsk,
        );
      default:
        return Text(block.toString(), style: const TextStyle(color: FloTheme.ink2));
    }
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.html});
  final String html;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 14.5,
          height: 1.6,
          color: FloTheme.ink1,
        ),
        children: _parseFloHtml(html),
      ),
    );
  }
}

List<InlineSpan> _parseFloHtml(String raw) {
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
        color: tone ?? FloTheme.ink1,
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

class _MetricsBlock extends StatelessWidget {
  const _MetricsBlock({
    required this.cols,
    required this.items,
    required this.isMobile,
  });

  final int cols;
  final List<Map> items;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final columnCount = isMobile ? 2 : cols.clamp(2, 4);
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (columnCount - 1) * 10) / columnCount;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                  decoration: BoxDecoration(
                    color: item['hl'] == true
                        ? const Color(0xFFF7FAFF)
                        : FloTheme.surface,
                    border: Border.all(
                      color: item['hl'] == true ? FloTheme.blueTint2 : FloTheme.line,
                    ),
                    borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item['k']?.toString() ?? '').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.05 * 10.5,
                          color: FloTheme.ink3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          style: FloTheme.mono(21).copyWith(
                            color: item['neg'] == true ? FloTheme.lossInk : FloTheme.ink1,
                          ),
                          children: [
                            if (item['unit'] != null)
                              TextSpan(
                                text: '${item['unit']} ',
                                style: FloTheme.mono(11, weight: FontWeight.w600)
                                    .copyWith(color: FloTheme.ink3),
                              ),
                            TextSpan(text: item['v']?.toString() ?? ''),
                          ],
                        ),
                      ),
                      if (item['delta'] != null) ...[
                        const SizedBox(height: 7),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item['dir'] == 'up')
                              FloIcons.up(size: 12, color: FloTheme.gainInk)
                            else if (item['dir'] == 'down')
                              FloIcons.down(size: 12, color: FloTheme.lossInk),
                            if (item['dir'] == 'up' || item['dir'] == 'down')
                              const SizedBox(width: 3),
                            Text(
                              item['delta'].toString(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: item['dir'] == 'down'
                                    ? FloTheme.lossInk
                                    : item['dir'] == 'up'
                                        ? FloTheme.gainInk
                                        : FloTheme.ink3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _VizBlock extends StatelessWidget {
  const _VizBlock({required this.block});
  final Map<String, dynamic> block;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        border: Border.all(color: FloTheme.line),
        borderRadius: BorderRadius.circular(FloTheme.radiusLg),
        color: FloTheme.surface,
        boxShadow: const [FloTheme.sh1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  block['title']?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.01,
                    color: FloTheme.ink1,
                  ),
                ),
              ),
              if (block['sub'] != null)
                Text(
                  block['sub'].toString(),
                  style: FloTheme.mono(11.5).copyWith(color: FloTheme.ink3),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (block['kind'] == 'bar')
            FloBarChart(
              data: (block['data'] as List?)
                      ?.whereType<Map>()
                      .map((e) => Map<String, dynamic>.from(e))
                      .toList() ??
                  const [],
            )
          else
            FloAreaChart(
              points: (block['points'] as List?)?.cast<num>() ?? const [],
              labels: (block['labels'] as List?)?.map((e) => e.toString()).toList() ??
                  const [],
              peak: (block['peak'] as num?)?.toInt() ?? 0,
            ),
        ],
      ),
    );
  }
}

class _TableBlock extends StatelessWidget {
  const _TableBlock({required this.block});
  final Map<String, dynamic> block;

  @override
  Widget build(BuildContext context) {
    final cols = (block['cols'] as List?)?.cast<Map>() ?? const [];
    final rows = (block['rows'] as List?) ?? const [];

    return Container(
      decoration: BoxDecoration(
        color: FloTheme.surface,
        border: Border.all(color: FloTheme.line),
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: FloTheme.surface2,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                for (var i = 0; i < cols.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    flex: cols[i]['num'] == true ? 1 : 2,
                    child: Text(
                      (cols[i]['label']?.toString() ?? '').toUpperCase(),
                      textAlign:
                          cols[i]['num'] == true ? TextAlign.right : TextAlign.left,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05 * 10.5,
                        color: FloTheme.ink3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          for (var ri = 0; ri < rows.length; ri++)
            Container(
              decoration: BoxDecoration(
                border: ri < rows.length - 1
                    ? const Border(bottom: BorderSide(color: FloTheme.lineSoft))
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var ci = 0; ci < cols.length; ci++) ...[
                    if (ci > 0) const SizedBox(width: 8),
                    Expanded(
                      flex: cols[ci]['num'] == true ? 1 : 2,
                      child: _TableCell(
                        cell: _cellAt(rows[ri], ci),
                        isNum: cols[ci]['num'] == true,
                        isLeadCol: ci == 0,
                        rowIndex: ri,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  dynamic _cellAt(dynamic row, int index) {
    if (row is List) {
      return index < row.length ? row[index] : '';
    }
    if (row is Map) {
      final cells = row['cells'];
      if (cells is List && index < cells.length) return cells[index];
    }
    return '';
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.cell,
    required this.isNum,
    required this.isLeadCol,
    required this.rowIndex,
  });

  final dynamic cell;
  final bool isNum;
  final bool isLeadCol;
  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    if (cell is Map) {
      final map = Map<String, dynamic>.from(cell as Map);
      if (map.containsKey('lead')) {
        return _leadContent(
          map['lead']?.toString() ?? '',
          _parseColor(map['sw']?.toString()),
        );
      }
      if (map.containsKey('t')) {
        return _styledText(
          map['t']?.toString() ?? '',
          cls: map['cls']?.toString(),
          alignRight: isNum,
        );
      }
    }

    final text = cell?.toString() ?? '';
    if (isLeadCol && text.isNotEmpty) {
      return _leadContent(text, _swatchColors[rowIndex % _swatchColors.length]);
    }

    return _styledText(text, cls: _inferClass(text), alignRight: isNum);
  }

  Widget _leadContent(String label, Color? swatch) {
    return Row(
      mainAxisAlignment: isNum ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (swatch != null) ...[
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 9),
        ],
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: FloTheme.ink1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _styledText(String text, {String? cls, required bool alignRight}) {
    final color = cls == 'neg'
        ? FloTheme.lossInk
        : cls == 'pos'
            ? FloTheme.gainInk
            : FloTheme.ink1;
    return Text(
      text,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        fontSize: 13,
        fontWeight: isNum ? FontWeight.w600 : FontWeight.w500,
        color: color,
        fontFeatures: isNum ? const [FontFeature.tabularFigures()] : null,
      ),
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final value = hex.replaceFirst('#', '');
    if (value.length == 6) {
      return Color(int.parse('FF$value', radix: 16));
    }
    return null;
  }

  String? _inferClass(String text) {
    if (text.contains('-') &&
        (text.contains('%') || text.toUpperCase().contains('RWF'))) {
      return 'neg';
    }
    if (text.startsWith('+') || text.contains('+')) return 'pos';
    return null;
  }
}

class _CalloutBlock extends StatelessWidget {
  const _CalloutBlock({required this.block});
  final Map<String, dynamic> block;

  @override
  Widget build(BuildContext context) {
    final tone = block['tone']?.toString() ?? 'info';
    final isWarn = tone == 'warn';

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
      decoration: BoxDecoration(
        color: isWarn ? FloTheme.warnBg : const Color(0xFFF4F8FF),
        border: Border.all(
          color: isWarn ? const Color(0xFFFCEFD2) : FloTheme.blueTint2,
        ),
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isWarn ? const Color(0xFFFCEFD2) : FloTheme.blueTint,
              borderRadius: BorderRadius.circular(9),
            ),
            child: isWarn
                ? FloIcons.warn(size: 17, color: FloTheme.warnIco)
                : FloIcons.info(size: 17, color: FloTheme.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block['h']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isWarn ? const Color(0xFFB54708) : FloTheme.blue700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  block['p']?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: FloTheme.ink2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceBlock extends StatelessWidget {
  const _SourceBlock({required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: FloTheme.surface2,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
        border: Border.all(color: FloTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloIcons.database(size: 13, color: FloTheme.ink4),
          const SizedBox(width: 7),
          Flexible(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  Text(
                    items[i].toString(),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w600,
                      color: i == 0 ? FloTheme.ink2 : FloTheme.ink3,
                    ),
                  ),
                  if (i < items.length - 1)
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: FloTheme.ink4,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsBlock extends StatelessWidget {
  const _ActionsBlock({required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        for (final a in items)
          if (a is Map) _ActionButton(item: Map<String, dynamic>.from(a)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.item});
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final primary = item['primary'] == true;
    final iconName = item['icon']?.toString();
    final label = item['label']?.toString() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            gradient: primary ? FloTheme.gradBtn : null,
            color: primary ? null : FloTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: primary ? null : Border.all(color: FloTheme.lineStrong),
            boxShadow: primary ? const [FloTheme.shBlue] : const [FloTheme.sh1],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloIcons.byName(
                iconName,
                size: 15,
                color: primary ? Colors.white : FloTheme.ink2,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primary ? Colors.white : FloTheme.ink1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FollowupsBlock extends StatelessWidget {
  const _FollowupsBlock({required this.items, this.onAsk});
  final List<dynamic> items;
  final FloAskCallback? onAsk;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUGGESTED FOLLOW-UPS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05 * 11,
            color: FloTheme.ink4,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final f in items)
              if (f is Map)
                Material(
                  color: FloTheme.surface,
                  borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                  child: InkWell(
                    onTap: onAsk == null
                        ? null
                        : () => onAsk!(
                              f['q']?.toString() ?? f['label']?.toString() ?? '',
                            ),
                    borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                        border: Border.all(color: FloTheme.lineStrong),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloIcons.sparkle(size: 14, color: FloTheme.blue),
                          const SizedBox(width: 8),
                          Text(
                            f['label']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: FloTheme.ink2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}