import 'entry_draft.dart';

class WizardDraft {
  List<String> situationTags = <String>[];
  String? situationNote;
  String negativeTemplateId = 'FREE_TEXT';
  String negativeText = '';
  int? negativeConfidence;
  String? negativeFrequency;
  List<String> distortions = <String>[];
  String balancedTemplateId = 'FREE_TEXT';
  String balancedText = '';
  int? emotionBefore;
  int? emotionAfter;

  EntryDraft toEntryDraft() {
    return EntryDraft(
      situationTags: List<String>.unmodifiable(situationTags),
      situationNote: situationNote?.trim().isEmpty == true
          ? null
          : situationNote?.trim(),
      negativeTemplateId: negativeTemplateId.trim().isEmpty
          ? 'FREE_TEXT'
          : negativeTemplateId,
      negativeText: negativeText.trim(),
      negativeConfidence: negativeConfidence,
      negativeFrequency: negativeFrequency,
      distortions: List<String>.unmodifiable(distortions),
      balancedTemplateId: balancedTemplateId.trim().isEmpty
          ? 'FREE_TEXT'
          : balancedTemplateId,
      balancedText: balancedText.trim(),
      emotionBefore: emotionBefore,
      emotionAfter: emotionAfter,
    );
  }
}
