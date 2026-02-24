class EntryDraft {
  const EntryDraft({
    required this.situationTags,
    this.situationNote,
    required this.negativeTemplateId,
    required this.negativeText,
    this.negativeConfidence,
    this.negativeFrequency,
    required this.distortions,
    required this.balancedTemplateId,
    required this.balancedText,
    this.emotionBefore,
    this.emotionAfter,
    this.createdAt,
  });

  final List<String> situationTags;
  final String? situationNote;
  final String negativeTemplateId;
  final String negativeText;
  final int? negativeConfidence;
  final String? negativeFrequency;
  final List<String> distortions;
  final String balancedTemplateId;
  final String balancedText;
  final int? emotionBefore;
  final int? emotionAfter;
  final DateTime? createdAt;

  bool get hasMinimumRequirements {
    return situationTags.isNotEmpty &&
        negativeText.trim().isNotEmpty &&
        balancedText.trim().isNotEmpty;
  }
}
