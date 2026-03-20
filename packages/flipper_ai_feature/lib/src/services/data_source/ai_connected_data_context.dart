import 'data_source_manager.dart';

/// Result of gathering schema and sample rows for the AI prompt.
class AiConnectedDataContextResult {
  /// Markdown-style text appended to the model prompt, or null if nothing usable.
  final String? context;

  /// Display names of connections that contributed (for UI attribution).
  final List<String> sourceNames;

  const AiConnectedDataContextResult({
    this.context,
    this.sourceNames = const [],
  });
}

const _maxContextChars = 12000;
const _maxTablesPerSource = 8;
const _sampleRowLimit = 5;

/// Loads table lists and small samples from active [DataSourceManager] configs for AI context.
Future<AiConnectedDataContextResult> buildConnectedDataContextForAi(
  DataSourceManager manager,
) async {
  final configs = manager.getDataSources().where((c) => c.isActive).toList();
  if (configs.isEmpty) {
    return const AiConnectedDataContextResult();
  }

  final buf = StringBuffer();
  final names = <String>[];

  for (final config in configs) {
    if (buf.length >= _maxContextChars) break;

    try {
      final tables = await manager.getTables(config.id);
      if (tables.isEmpty) continue;

      var wroteForConfig = false;
      buf.writeln('## ${config.name} (${config.type.name})');

      for (final table in tables.take(_maxTablesPerSource)) {
        if (buf.length >= _maxContextChars) break;

        final schema = table.schema ?? 'public';
        final colSummary =
            table.columns.map((c) => '${c.name}: ${c.type}').join(', ');

        buf.writeln('### $schema.${table.name}');
        buf.writeln('Columns: $colSummary');

        final sample = await manager.getTableSample(
          config.id,
          table.name,
          schema: schema,
          limit: _sampleRowLimit,
        );

        if (!sample.isSuccess) {
          buf.writeln('Sample: unavailable (${sample.error})');
          wroteForConfig = true;
          buf.writeln();
          continue;
        }

        if (sample.data.isEmpty) {
          buf.writeln('Sample rows: (none)');
          wroteForConfig = true;
          buf.writeln();
          continue;
        }

        buf.writeln('Sample rows (${sample.data.length}):');
        final keys = sample.data.first.keys.toList();
        buf.writeln(keys.join('\t'));
        for (final row in sample.data) {
          buf.writeln(
            keys.map((k) => row[k]?.toString() ?? '').join('\t'),
          );
        }
        buf.writeln();
        wroteForConfig = true;
      }

      if (wroteForConfig && !names.contains(config.name)) {
        names.add(config.name);
      }
    } catch (_) {
      continue;
    }
  }

  final raw = buf.toString().trim();
  if (raw.isEmpty) {
    return const AiConnectedDataContextResult();
  }

  final truncated = raw.length <= _maxContextChars
      ? raw
      : '${raw.substring(0, _maxContextChars)}\n…(truncated)';

  return AiConnectedDataContextResult(
    context: truncated,
    sourceNames: names,
  );
}
