import 'package:aurapal/models/models.dart';
import 'package:aurapal/services/aura_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('maps warm bright image to yellow/orange family', () {
    final service = AuraService();
    final aura = service.auraFromMetrics(img.ColorRgb8(240, 200, 90), 0.8, 0.2, 0.7, ['Calm']);
    expect([AuraArchetype.yellow, AuraArchetype.orange], contains(aura));
  });

  test('maps low score to indigo', () {
    final service = AuraService();
    final aura = service.auraFromMetrics(img.ColorRgb8(20, 20, 30), 0.1, 0.05, 0.2, const []);
    expect(aura, AuraArchetype.indigo);
  });
}
