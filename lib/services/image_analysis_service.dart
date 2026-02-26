import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageMetrics {
  ImageMetrics({
    required this.avgColor,
    required this.brightness,
    required this.contrast,
    required this.warmth,
    required this.sharpness,
  });

  final img.Color avgColor;
  final double brightness;
  final double contrast;
  final double warmth;
  final double sharpness;
}

class ImageAnalysisService {
  ImageMetrics analyze(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Unable to decode image bytes');
    }
    return ImageMetrics(
      avgColor: computeAverageColor(imageBytes),
      brightness: computeBrightness(imageBytes),
      contrast: computeContrast(imageBytes),
      warmth: computeWarmth(imageBytes),
      sharpness: computeSharpness(image),
    );
  }

  img.Color computeAverageColor(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;
    var r = 0.0, g = 0.0, b = 0.0, count = 0.0;
    for (var y = 0; y < image.height; y += 4) {
      for (var x = 0; x < image.width; x += 4) {
        final p = image.getPixel(x, y);
        r += p.r;
        g += p.g;
        b += p.b;
        count++;
      }
    }
    return img.ColorRgb8((r / count).round(), (g / count).round(), (b / count).round());
  }

  double computeBrightness(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;
    var total = 0.0;
    var count = 0;
    for (var y = 0; y < image.height; y += 4) {
      for (var x = 0; x < image.width; x += 4) {
        final p = image.getPixel(x, y);
        total += (0.2126 * p.r + 0.7152 * p.g + 0.0722 * p.b) / 255;
        count++;
      }
    }
    return total / count;
  }

  double computeContrast(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;
    final values = <double>[];
    for (var y = 0; y < image.height; y += 4) {
      for (var x = 0; x < image.width; x += 4) {
        final p = image.getPixel(x, y);
        values.add((0.299 * p.r + 0.587 * p.g + 0.114 * p.b) / 255);
      }
    }
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
    return sqrt(variance);
  }

  double computeWarmth(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;
    var total = 0.0;
    var count = 0;
    for (var y = 0; y < image.height; y += 4) {
      for (var x = 0; x < image.width; x += 4) {
        final p = image.getPixel(x, y);
        total += (p.r - p.b + 255) / 510;
        count++;
      }
    }
    return total / count;
  }

  double computeSharpness(img.Image image) {
    var edgeSum = 0.0;
    var count = 0;
    for (var y = 1; y < image.height - 1; y += 4) {
      for (var x = 1; x < image.width - 1; x += 4) {
        final c = image.getPixel(x, y).luminance;
        final right = image.getPixel(x + 1, y).luminance;
        final down = image.getPixel(x, y + 1).luminance;
        edgeSum += (c - right).abs() + (c - down).abs();
        count++;
      }
    }
    return (edgeSum / count) / 255;
  }
}
