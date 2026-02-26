import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../services/compatibility_service.dart';
import '../../services/local_storage_service.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _codeCtrl = TextEditingController();
  final _compat = CompatibilityService();

  @override
  Widget build(BuildContext context) {
    final profile = LocalStorageService.instance.getProfile();
    final friends = LocalStorageService.instance.getFriends();
    final codeLength = profile.userId.length < 6 ? profile.userId.length : 6;
    final myCode = profile.userId.substring(0, codeLength).toUpperCase();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Invite code: $myCode'),
        const SizedBox(height: 8),
        QrImageView(data: myCode, size: 120),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'Add by invite code'))),
          IconButton(onPressed: _addFriend, icon: const Icon(Icons.person_add)),
        ]),
        const SizedBox(height: 16),
        ...friends.map((f) => Card(
              child: ListTile(
                title: Text(f.displayName),
                subtitle: Text('${f.latestAura?.name ?? 'No aura yet'} • ${f.latestPalm ?? 'No palm summary'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    final auras = LocalStorageService.instance.getAuraReadings();
                    if (auras.isEmpty || f.latestAura == null) return;
                    final result = _compat.compute(userAura: auras.last.archetype, friendAura: f.latestAura!);
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Compatibility ${result.score}'),
                        content: Text('Great for: ${result.greatFor}\nWatch out: ${result.watchOutFor}\nTry: ${result.tryTogether}'),
                      ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }

  Future<void> _addFriend() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    final friends = LocalStorageService.instance.getFriends();
    friends.add(
      FriendSummary(
        friendUid: const Uuid().v4(),
        displayName: 'Friend ${friends.length + 1}',
        inviteCode: code,
        latestAura: AuraArchetype.values[friends.length % AuraArchetype.values.length],
        latestPalm: 'Balanced and curious',
        latestHoroscope: 'Today favors patience and small wins.',
      ),
    );
    await LocalStorageService.instance.saveFriends(friends);
    _codeCtrl.clear();
    setState(() {});
  }
}
