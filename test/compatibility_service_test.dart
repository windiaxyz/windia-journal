import 'package:aurapal/models/models.dart';
import 'package:aurapal/services/compatibility_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compatibility score increases with aligned aura and traits', () {
    final service = CompatibilityService();
    final high = service.compute(
      userAura: AuraArchetype.green,
      friendAura: AuraArchetype.green,
      userPalm: PalmTraits(heartLine: 'Long', headLine: 'Straight', lifeLine: 'Deep', openness: 'Open', quality: 88, summary: ''),
      friendPalm: PalmTraits(heartLine: 'Long', headLine: 'Straight', lifeLine: 'Deep', openness: 'Open', quality: 70, summary: ''),
      userMoodTags: const ['Calm', 'Creative'],
      friendMoodTags: const ['Calm'],
    );

    final low = service.compute(
      userAura: AuraArchetype.red,
      friendAura: AuraArchetype.blue,
      userMoodTags: const ['Focused'],
      friendMoodTags: const ['Social'],
    );

    expect(high.score, greaterThan(low.score));
  });
}
