import 'package:aurapal/models/models.dart';
import 'package:aurapal/services/seeded_horoscope_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seeded generator is deterministic for same user/date', () {
    final service = SeededHoroscopeService();
    final a = service.generate(
      userId: 'u1',
      date: DateTime(2026, 1, 1),
      aura: AuraArchetype.blue,
    );
    final b = service.generate(
      userId: 'u1',
      date: DateTime(2026, 1, 1),
      aura: AuraArchetype.blue,
    );
    expect(a.paragraph, b.paragraph);
    expect(a.focusTheme, b.focusTheme);
  });
}
