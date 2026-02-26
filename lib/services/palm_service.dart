import '../models/models.dart';

class PalmService {
  PalmTraits analyze({
    required String heartLine,
    required String headLine,
    required String lifeLine,
    required double brightness,
    required double contrast,
    required double sharpness,
  }) {
    final openness = (brightness + contrast) > 0.85 ? 'Open' : 'Reserved';
    final quality = ((sharpness * 70) + (contrast * 30)).clamp(0, 100).round();
    final summary =
        'Heart line: $heartLine • Head line: $headLine • Life line: $lifeLine • Openness: $openness.';

    return PalmTraits(
      heartLine: heartLine,
      headLine: headLine,
      lifeLine: lifeLine,
      openness: openness,
      quality: quality,
      summary: summary,
    );
  }
}
