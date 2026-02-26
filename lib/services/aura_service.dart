import 'dart:math';

import 'package:image/image.dart' as img;

import '../models/models.dart';

class AuraService {
  AuraArchetype auraFromMetrics(
    img.Color avgColor,
    double brightness,
    double contrast,
    double warmth,
    List<String> moodTags,
  ) {
    final tagBias = moodTags.fold<int>(0, (sum, tag) => sum + tag.codeUnitAt(0));
    final score = ((avgColor.r * 0.2 + avgColor.g * 0.3 + avgColor.b * 0.1) /
            255 +
        brightness * 0.2 +
        contrast * 0.1 +
        warmth * 0.1 +
        (tagBias % 10) / 50);

    if (score < 0.35) return AuraArchetype.indigo;
    if (warmth > 0.62 && brightness > 0.60) return AuraArchetype.yellow;
    if (warmth > 0.57) return AuraArchetype.orange;
    if (avgColor.r > avgColor.g && avgColor.r > avgColor.b) return AuraArchetype.red;
    if (avgColor.b > avgColor.g && contrast > 0.22) return AuraArchetype.blue;
    if (avgColor.g > avgColor.r && brightness > 0.5) return AuraArchetype.green;
    if (contrast > 0.28) return AuraArchetype.purple;
    return AuraArchetype.blue;
  }

  int energyScore(double brightness, double contrast, double warmth) {
    return ((brightness * 45) + (contrast * 35) + (warmth * 20)).clamp(0, 100).round();
  }

  String interpretation(AuraArchetype archetype) {
    const copy = {
      AuraArchetype.blue:
          'Blue aura energy points to calm communication and emotional honesty. You may feel reflective yet ready to connect.',
      AuraArchetype.green:
          'Green aura energy highlights growth, healing, and practical progress. Your day favors steady momentum.',
      AuraArchetype.purple:
          'Purple aura energy suggests imagination and intuition. Make room for creative exploration and quiet thinking.',
      AuraArchetype.yellow:
          'Yellow aura energy indicates optimism, curiosity, and social spark. Lean into moments that lift your spirit.',
      AuraArchetype.orange:
          'Orange aura energy centers on motivation and confidence. Tackle one meaningful challenge with enthusiasm.',
      AuraArchetype.red:
          'Red aura energy reflects drive, courage, and action. Ground your intensity with one intentional pause.',
      AuraArchetype.indigo:
          'Indigo aura energy favors depth and introspection. Protect your focus and choose restorative habits today.',
    };
    return copy[archetype]!;
  }

  List<String> prompts(AuraArchetype archetype) {
    final defaults = [
      'What emotion is asking for your attention today?',
      'What tiny action would make tonight feel complete?',
    ];
    if (archetype == AuraArchetype.red) {
      return ['Where can I direct my energy constructively?', 'How can I avoid rushing an important decision?'];
    }
    if (archetype == AuraArchetype.indigo) {
      return ['What boundary would protect my peace?', 'What insight keeps repeating for me lately?'];
    }
    return defaults;
  }

  String hexFromColor(img.Color c) {
    String two(int n) => n.toRadixString(16).padLeft(2, '0');
    return '#${two(c.r)}${two(c.g)}${two(c.b)}';
  }

  int auraDistance(AuraArchetype a, AuraArchetype b) {
    if (a == b) return 0;
    const order = [
      AuraArchetype.red,
      AuraArchetype.orange,
      AuraArchetype.yellow,
      AuraArchetype.green,
      AuraArchetype.blue,
      AuraArchetype.indigo,
      AuraArchetype.purple,
    ];
    final ai = order.indexOf(a);
    final bi = order.indexOf(b);
    return min((ai - bi).abs(), order.length - (ai - bi).abs());
  }
}
