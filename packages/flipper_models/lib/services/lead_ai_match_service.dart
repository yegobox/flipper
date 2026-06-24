import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flipper_models/providers/unified_ai_input.dart';
import 'package:flipper_models/repositories/ai_model_repository.dart';
import 'package:flipper_models/services/lead_ai_catalog.dart';
import 'package:flipper_models/services/lead_ai_match_parser.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/supabase_models.dart';

/// Runs Groq/Gemini via [geminiResponseProvider] and returns [Lead] with
/// [aiExtracted] / [aiConfidence] set. Does not persist.
Future<Lead> enrichLeadWithCatalogAi({
  required ProviderContainer container,
  required Lead lead,
}) async {
  if (lead.aiExtracted?['source'] == 'manual_catalog') {
    return lead;
  }

  final repo = AIModelRepository();
  final bid = lead.businessId;
  if (bid != null && bid.isNotEmpty) {
    if (!await repo.isLeadsAiMatchEnabledForBusiness(bid)) {
      return lead;
    }
  }

  final model = await repo.getDefaultModel();
  if (model == null) {
    throw StateError('No default AI model configured in ai_models');
  }

  final paged = await ProxyService.getStrategy(Strategy.capella).variants(
    branchId: lead.branchId,
    itemsPerPage: 500,
    page: 0,
    fetchRemote: false,
  );
  final allVariants = List<Variant>.from(paged.variants as Iterable);
  final ranked = rankVariantsForLead(allVariants, lead);
  final catalogueById = catalogueMaps(ranked);

  final catalogueJson = catalogueJsonForPrompt(ranked);

  final interest = lead.productsInterestedIn?.trim() ?? '';
  final notes = lead.notes?.trim() ?? '';
  final est = lead.estimatedValue;

  final instructions = '''
You are matching a sales lead's free-text product interest to inventory variants.

Catalogue (JSON array; each item has id, name, sku, bcd, unitPrice). ONLY use variant ids from this list when you are confident of a match.
$catalogueJson

Lead:
- products_interested_in: ${interest.isEmpty ? '(none)' : interest}
- notes: ${notes.isEmpty ? '(none)' : notes}
- estimated_value: ${est?.toString() ?? '(unknown)'}

Return ONLY valid JSON (no markdown) with this shape:
{"matches":[{"query":"string from the lead describing one need","variantId":"<uuid from catalogue or null>","quantity":1,"confidence":0.0,"reason":"short"}]}

Rules:
- Use one match per distinct product need; duplicate catalogue lines if they asked for quantity in one phrase.
- confidence is 0..1 (how sure the variant fits).
- If nothing fits well, use "variantId": null and set query to the customer phrase.
- Prefer exact sku/bcd/name matches when present in the text.
''';

  final input = UnifiedAIInput(
    contents: [
      Content(role: 'user', parts: [Part.text(instructions)]),
    ],
    generationConfig: GenerationConfig(
      temperature: model.temperature,
      maxOutputTokens: model.maxTokens.clamp(256, 4096),
    ),
    model: model.modelId,
  );

  final raw = await container.read(
    geminiResponseProvider(input, model).future,
  );

  final decoded = decodeLeadAiJsonObject(raw);
  if (decoded == null) {
    throw FormatException('Lead AI match: could not parse JSON', raw);
  }

  final source = lead.source == LeadSource.gmail ? 'gmail' : 'manual';
  final built = buildAiExtractedFromModelJson(
    modelJson: decoded,
    catalogueById: catalogueById,
    sourceLabel: source,
    modelLabel: model.modelId,
  );

  final now = DateTime.now().toUtc();
  return lead.copyWith(
    aiExtracted: built.extracted,
    aiConfidence: built.confidence,
    updatedAt: now,
    lastTouched: now,
  );
}
