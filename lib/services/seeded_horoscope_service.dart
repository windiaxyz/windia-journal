import 'dart:math';

import '../models/models.dart';

class SeededHoroscopeService {
  static final Map<AuraArchetype, List<String>> _templates = {
    AuraArchetype.blue: [
      'Your words carry soothing power today; one honest conversation opens a door.',
      'A calm pace helps you notice hidden support around you.',
    ],
    AuraArchetype.green: [
      'A practical step in the morning creates growth through the afternoon.',
      'Nurture one routine and it will return energy quickly.',
    ],
    AuraArchetype.purple: [
      'Creative insight appears when you stop forcing a result.',
      'Your imagination is strongest when paired with structure today.',
    ],
    AuraArchetype.yellow: [
      'Joy multiplies when you share encouragement with someone close.',
      'Curiosity guides you toward a meaningful new perspective.',
    ],
    AuraArchetype.orange: [
      'A bold but measured choice helps you gain momentum.',
      'Your confidence inspires teamwork and fresh collaboration.',
    ],
    AuraArchetype.red: [
      'Focused action beats scattered effort; pick one priority and commit.',
      'Your drive is high—balance it with hydration and breaks.',
    ],
    AuraArchetype.indigo: [
      'Quiet reflection reveals the answer you were searching for.',
      'Trust your intuition, then confirm it with one grounded action.',
    ],
  };

  DailyHoroscope generate({
    required String userId,
    required DateTime date,
    required AuraArchetype aura,
    PalmTraits? palm,
    String? zodiac,
  }) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final seed = '$userId|$dateKey'.codeUnits.fold<int>(0, (a, b) => a + b);
    final random = Random(seed);
    final options = _templates[aura]!;
    final base = options[random.nextInt(options.length)];

    final focusThemes = ['Connection', 'Discipline', 'Rest', 'Creativity', 'Courage'];
    final luckyColors = ['Teal', 'Gold', 'Lavender', 'Coral', 'Sage'];
    final doItems = ['Take a mindful walk', 'Journal for 10 minutes', 'Reach out to a friend', 'Declutter one small area'];
    final dontItems = ['Overcommit your schedule', 'Ignore your limits', 'Compare your progress', 'Skip meals'];

    final palmFlavor = palm == null ? '' : ' Your ${palm.openness.toLowerCase()} openness energy suggests pacing yourself.';
    final zodiacFlavor = zodiac == null ? '' : ' As a $zodiac sign, trust balanced instincts.';

    return DailyHoroscope(
      date: dateKey,
      paragraph: '$base$palmFlavor$zodiacFlavor',
      luckyColor: luckyColors[random.nextInt(luckyColors.length)],
      focusTheme: focusThemes[random.nextInt(focusThemes.length)],
      doItem: doItems[random.nextInt(doItems.length)],
      dontItem: dontItems[random.nextInt(dontItems.length)],
    );
  }
}
