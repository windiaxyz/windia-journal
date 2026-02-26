import '../models/models.dart';
import 'aura_service.dart';

class CompatibilityResult {
  CompatibilityResult({
    required this.score,
    required this.greatFor,
    required this.watchOutFor,
    required this.tryTogether,
  });

  final int score;
  final String greatFor;
  final String watchOutFor;
  final String tryTogether;
}

class CompatibilityService {
  final AuraService _auraService = AuraService();

  CompatibilityResult compute({
    required AuraArchetype userAura,
    required AuraArchetype friendAura,
    PalmTraits? userPalm,
    PalmTraits? friendPalm,
    List<String> userMoodTags = const [],
    List<String> friendMoodTags = const [],
  }) {
    final auraDistance = _auraService.auraDistance(userAura, friendAura);
    var score = 100 - auraDistance * 12;

    if (userPalm != null && friendPalm != null) {
      if (userPalm.headLine == friendPalm.headLine) score += 8;
      if (userPalm.lifeLine == friendPalm.lifeLine) score += 6;
      if (userPalm.openness == friendPalm.openness) score += 6;
    }

    final moodOverlap = userMoodTags.toSet().intersection(friendMoodTags.toSet()).length;
    score += moodOverlap * 4;

    score = score.clamp(0, 100);
    return CompatibilityResult(
      score: score,
      greatFor: score >= 75 ? 'Creative projects and meaningful conversations' : 'Light social plans and playful check-ins',
      watchOutFor: score < 50 ? 'Misaligned pacing—communicate expectations clearly' : 'Overextending your shared energy',
      tryTogether: score >= 70 ? 'Do a sunset walk and gratitude swap' : 'Try a short co-journaling session',
    );
  }
}
