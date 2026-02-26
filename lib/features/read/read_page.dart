import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../services/aura_service.dart';
import '../../services/image_analysis_service.dart';
import '../../services/local_storage_service.dart';
import '../../services/palm_service.dart';
import '../horoscope/today_profile_card.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final ImagePicker _picker = ImagePicker();
  final _analysis = ImageAnalysisService();
  final _aura = AuraService();
  final _palm = PalmService();
  final _id = const Uuid();
  List<String> _moods = [];

  @override
  Widget build(BuildContext context) {
    final profile = LocalStorageService.instance.getProfile();
    final auraReadings = LocalStorageService.instance.getAuraReadings();
    final palmReadings = LocalStorageService.instance.getPalmReadings();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'For entertainment and self-reflection only. AuraPal does not provide medical, diagnostic, legal, or financial advice.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: ['Calm', 'Focused', 'Social', 'Creative'].map((m) {
            final selected = _moods.contains(m);
            return FilterChip(
              label: Text(m),
              selected: selected,
              onSelected: (v) => setState(() => v ? _moods.add(m) : _moods.remove(m)),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _runSelfieAura,
          icon: const Icon(Icons.face),
          label: const Text('Selfie Aura'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _runPalmScan,
          icon: const Icon(Icons.front_hand),
          label: const Text('Palm Scan'),
        ),
        const SizedBox(height: 16),
        TodayProfileCard(
          userId: profile.userId,
          aura: auraReadings.isEmpty ? null : auraReadings.last,
          palm: palmReadings.isEmpty ? null : palmReadings.last,
          zodiac: profile.zodiac,
        ),
      ],
    );
  }

  Future<void> _runSelfieAura() async {
    final photo = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (photo == null) return;

    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ScanningDialog(text: 'Scanning aura...'),
    );

    final bytes = await File(photo.path).readAsBytes();
    final metrics = _analysis.analyze(bytes);
    final archetype = _aura.auraFromMetrics(metrics.avgColor, metrics.brightness, metrics.contrast, metrics.warmth, _moods);
    final reading = AuraReading(
      id: _id.v4(),
      createdAt: DateTime.now(),
      archetype: archetype,
      energyScore: _aura.energyScore(metrics.brightness, metrics.contrast, metrics.warmth),
      interpretation: _aura.interpretation(archetype),
      prompts: _aura.prompts(archetype),
      avgHexColor: _aura.hexFromColor(metrics.avgColor),
      brightness: metrics.brightness,
      contrast: metrics.contrast,
      warmth: metrics.warmth,
    );
    await LocalStorageService.instance.saveAuraReading(reading);

    if (!mounted) return;
    Navigator.pop(context);
    _showReadingDialog('Aura Result', '${reading.archetype.name.toUpperCase()} aura\nEnergy ${reading.energyScore}\n\n${reading.interpretation}');
    setState(() {});
  }

  Future<void> _runPalmScan() async {
    final photo = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (photo == null || !mounted) return;
    final bytes = await File(photo.path).readAsBytes();
    final metrics = _analysis.analyze(bytes);

    final answers = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _PalmQuestionDialog(),
    );
    if (answers == null) return;

    final traits = _palm.analyze(
      heartLine: answers['heart']!,
      headLine: answers['head']!,
      lifeLine: answers['life']!,
      brightness: metrics.brightness,
      contrast: metrics.contrast,
      sharpness: metrics.sharpness,
    );

    final reading = PalmReading(id: _id.v4(), createdAt: DateTime.now(), traits: traits);
    await LocalStorageService.instance.savePalmReading(reading);
    if (!mounted) return;
    _showReadingDialog('Palm Result', '${traits.summary}\nQuality: ${traits.quality}');
    setState(() {});
  }

  void _showReadingDialog(String title, String body) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(title: Text(title), content: Text(body), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]),
    );
  }
}

class _ScanningDialog extends StatefulWidget {
  const _ScanningDialog({required this.text});
  final String text;

  @override
  State<_ScanningDialog> createState() => _ScanningDialogState();
}

class _ScanningDialogState extends State<_ScanningDialog> {
  bool glow = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 200), () => setState(() => glow = true));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: glow ? [Colors.deepPurple, Colors.transparent] : [Colors.blue, Colors.transparent]),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.text),
        ],
      ),
    );
  }
}

class _PalmQuestionDialog extends StatefulWidget {
  const _PalmQuestionDialog();

  @override
  State<_PalmQuestionDialog> createState() => _PalmQuestionDialogState();
}

class _PalmQuestionDialogState extends State<_PalmQuestionDialog> {
  String heart = 'Long Curved';
  String head = 'Straight';
  String life = 'Deep';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Palm Guide Questions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(value: heart, items: const ['Short Straight', 'Long Curved'].map((e) => DropdownMenuItem(value: e, child: Text('Heart line: $e'))).toList(), onChanged: (v) => setState(() => heart = v!)),
          DropdownButtonFormField<String>(value: head, items: const ['Straight', 'Curved'].map((e) => DropdownMenuItem(value: e, child: Text('Head line: $e'))).toList(), onChanged: (v) => setState(() => head = v!)),
          DropdownButtonFormField<String>(value: life, items: const ['Deep', 'Light'].map((e) => DropdownMenuItem(value: e, child: Text('Life line: $e'))).toList(), onChanged: (v) => setState(() => life = v!)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, {'heart': heart, 'head': head, 'life': life}), child: const Text('Analyze')),
      ],
    );
  }
}
