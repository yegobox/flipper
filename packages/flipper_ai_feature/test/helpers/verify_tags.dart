void main() {
  String cleanResponse(String text) {
    return text
        .replaceAll(
          RegExp(
            r'\{\{VISUALIZATION_DATA\}\}.*?\{\{/VISUALIZATION_DATA\}\}',
            dotAll: true,
          ),
          '',
        )
        .replaceAll(
          RegExp(r'\{\{REASONING\}\}.*?\{\{/REASONING\}\}', dotAll: true),
          '',
        )
        .replaceAll(RegExp(r'\{\{.*?\}\}'), '') // Remove any orphaned tags
        .trim();
  }

  final testCases = {
    "Hello {{REASONING}}thinking{{/REASONING}} World": "Hello  World",
    "Data {{VISUALIZATION_DATA}}json{{/VISUALIZATION_DATA}} end": "Data  end",
    "Both {{REASONING}}r{{/REASONING}} and {{VISUALIZATION_DATA}}v{{/VISUALIZATION_DATA}}":
        "Both  and",
    "Orphaned {{REASONING}} tag": "Orphaned  tag",
    "Nested {{REASONING}} {{VISUALIZATION_DATA}} {{/VISUALIZATION_DATA}} {{/REASONING}}":
        "Nested",
    "Title with {{REASONING}}": "Title with",
  };

  bool allPass = true;
  testCases.forEach((input, expected) {
    final result = cleanResponse(input);
    if (result == expected) {
      print("PASS: '$input' -> '$result'");
    } else {
      print("FAIL: '$input' -> '$result' (expected '$expected')");
      allPass = false;
    }
  });

  if (!allPass) {
    throw Exception("Some test cases failed");
  } else {
    print("\nALL TAG CLEANING TESTS PASSED");
  }
}
