/// Utility to validate that required imports are present in model files.
library;

/// List of required imports for generated Ditto sync adapter files.
const List<String> requiredImports = [
  'package:brick_core/query.dart',
  'package:brick_offline_first/brick_offline_first.dart',
  'package:flipper_services/proxy.dart',
  'package:flutter/foundation.dart',
  'package:supabase_models/sync/ditto_sync_adapter.dart',
  'package:supabase_models/sync/ditto_sync_coordinator.dart',
  'package:supabase_models/sync/ditto_sync_generated.dart',
  'package:supabase_models/brick/repository.dart',
];

/// Validates that a Dart file contains all required imports for Ditto sync.
/// 
/// Returns a list of missing import statements.
/// Returns an empty list if all imports are present.
List<String> validateImports(String fileContent) {
  final missingImports = <String>[];
  
  for (final import in requiredImports) {
    // Check for both single and double quotes
    final hasSingleQuote = fileContent.contains("import '$import'");
    final hasDoubleQuote = fileContent.contains('import "$import"');
    
    if (!hasSingleQuote && !hasDoubleQuote) {
      missingImports.add("import '$import';");
    }
  }
  
  return missingImports;
}

/// Generates a formatted error message for missing imports.
String formatMissingImportsError(String fileName, List<String> missingImports) {
  if (missingImports.isEmpty) {
    return '';
  }
  
  final buffer = StringBuffer();
  buffer.writeln('❌ Missing required imports in $fileName:');
  buffer.writeln('');
  for (final import in missingImports) {
    buffer.writeln('  $import');
  }
  buffer.writeln('');
  buffer.writeln('Add these imports to the top of your file to fix compilation errors.');
  
  return buffer.toString();
}

/// Generates the import block that should be added to model files.
String generateImportBlock() {
  return requiredImports.map((imp) => "import '$imp';").join('\n');
}
