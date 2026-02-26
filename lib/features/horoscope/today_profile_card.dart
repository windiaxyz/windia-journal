import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/seeded_horoscope_service.dart';

class TodayProfileCard extends StatelessWidget {
  const TodayProfileCard({
    super.key,
    required this.userId,
    required this.aura,
    required this.palm,
    this.zodiac,
  });

  final String userId;
  final AuraReading? aura;
  final PalmReading? palm;
  final String? zodiac;

  @override
  Widget build(BuildContext context) {
    if (aura == null) {
      return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Take a selfie aura reading to generate your daily profile.')));
    }
    final horoscope = SeededHoroscopeService().generate(
      userId: userId,
      date: DateTime.now(),
      aura: aura!.archetype,
      palm: palm?.traits,
      zodiac: zodiac,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Today: ${aura!.archetype.name.toUpperCase()} • Energy ${aura!.energyScore}'),
          const SizedBox(height: 8),
          Text(horoscope.paragraph),
          const SizedBox(height: 8),
          Text('Lucky color: ${horoscope.luckyColor} • Focus: ${horoscope.focusTheme}'),
          Text('Do: ${horoscope.doItem}'),
          Text("Don’t: ${horoscope.dontItem}"),
        ]),
      ),
    );
  }
}
