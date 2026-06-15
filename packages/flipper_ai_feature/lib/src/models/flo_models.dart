import 'dart:convert';

/// Parsed Flo assistant message stored as JSON in Message.content.
class FloMessagePayload {
  const FloMessagePayload({required this.blocks});

  factory FloMessagePayload.fromJson(Map<String, dynamic> json) {
    final raw = json['blocks'];
    final blocks = raw is List
        ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : <Map<String, dynamic>>[];
    return FloMessagePayload(blocks: blocks);
  }

  factory FloMessagePayload.tryParse(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map && decoded['flo_v1'] == true) {
        return FloMessagePayload.fromJson(Map<String, dynamic>.from(decoded));
      }
      if (decoded is Map && decoded['blocks'] is List) {
        return FloMessagePayload.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return const FloMessagePayload(blocks: []);
  }

  static bool isFloMessage(String content) {
    if (content.trim().isEmpty) return false;
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map &&
          (decoded['flo_v1'] == true || decoded['blocks'] is List)) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  final List<Map<String, dynamic>> blocks;

  Map<String, dynamic> toStorageJson() => {'flo_v1': true, 'blocks': blocks};

  String toStorageString() => jsonEncode(toStorageJson());
}

class FloChatResponse {
  const FloChatResponse({
    required this.blocks,
    required this.modelUsed,
    required this.thinking,
  });

  factory FloChatResponse.fromJson(Map<String, dynamic> json) {
    final blocks = (json['blocks'] as List? ?? [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    return FloChatResponse(
      blocks: blocks,
      modelUsed: json['model_used'] as String? ?? '',
      thinking: (json['thinking'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  final List<Map<String, dynamic>> blocks;
  final String modelUsed;
  final List<String> thinking;
}

class FloWhatsAppDraft {
  const FloWhatsAppDraft({required this.src, required this.draft});

  factory FloWhatsAppDraft.fromJson(Map<String, dynamic> json) {
    return FloWhatsAppDraft(
      src: json['src'] as String? ?? 'MiniData',
      draft: json['draft'] as String? ?? '',
    );
  }

  final String src;
  final String draft;
}

class FloChatEvent {
  const FloChatEvent({required this.event, required this.data});

  final String event;
  final String data;
}

class FloBriefingStat {
  const FloBriefingStat({
    required this.label,
    this.unit,
    required this.value,
    this.delta,
    this.up,
    this.negative = false,
  });

  factory FloBriefingStat.fromJson(Map<String, dynamic> json) {
    return FloBriefingStat(
      label: json['label'] as String? ?? '',
      unit: json['unit'] as String?,
      value: json['value'] as String? ?? '',
      delta: json['delta'] as String?,
      up: json['up'] as bool?,
      negative: json['negative'] as bool? ?? false,
    );
  }

  final String label;
  final String? unit;
  final String value;
  final String? delta;
  final bool? up;
  final bool negative;
}

class FloDailyBriefing {
  const FloDailyBriefing({
    required this.dateLabel,
    required this.headline,
    required this.bodyHtml,
    required this.stats,
    this.empty = false,
  });

  factory FloDailyBriefing.fromJson(Map<String, dynamic> json) {
    final stats = (json['stats'] as List? ?? [])
        .whereType<Map>()
        .map((e) => FloBriefingStat.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return FloDailyBriefing(
      dateLabel: json['date_label'] as String? ?? '',
      headline: json['headline'] as String? ?? '',
      bodyHtml: json['body_html'] as String? ?? '',
      stats: stats,
      empty: json['empty'] as bool? ?? false,
    );
  }

  final String dateLabel;
  final String headline;
  final String bodyHtml;
  final List<FloBriefingStat> stats;
  final bool empty;
}
