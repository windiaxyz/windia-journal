import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/local_storage_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final aura = LocalStorageService.instance.getAuraReadings();
    final palm = LocalStorageService.instance.getPalmReadings();
    final fmt = DateFormat.yMMMd().add_jm();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Derived summaries only. Raw photos are not stored by default.'),
        const SizedBox(height: 12),
        const Text('Aura Readings', style: TextStyle(fontWeight: FontWeight.bold)),
        ...aura.map((r) => Card(
              child: ListTile(
                title: Text('${r.archetype.name.toUpperCase()} • Energy ${r.energyScore}'),
                subtitle: Text('${fmt.format(r.createdAt)}\n${r.interpretation}'),
                isThreeLine: true,
              ),
            )),
        const SizedBox(height: 12),
        const Text('Palm Readings', style: TextStyle(fontWeight: FontWeight.bold)),
        ...palm.map((p) => Card(
              child: ListTile(
                title: Text('Quality ${p.traits.quality}'),
                subtitle: Text('${fmt.format(p.createdAt)}\n${p.traits.summary}'),
                isThreeLine: true,
              ),
            )),
      ],
    );
  }
}
