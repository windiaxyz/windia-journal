import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/local_storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserProfile profile;

  @override
  void initState() {
    super.initState();
    profile = LocalStorageService.instance.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Disclaimer: AuraPal is for entertainment and self-reflection only. It does not provide medical, diagnostic, treatment, legal, or financial advice.',
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          value: profile.shareEnabled,
          title: const Text('Share with friends'),
          subtitle: const Text('Only derived summaries can be shared.'),
          onChanged: (v) => _update(profile.copyWith(shareEnabled: v)),
        ),
        SwitchListTile(
          value: profile.shareDerivedOnly,
          title: const Text('Share derived results only'),
          onChanged: (v) => _update(profile.copyWith(shareDerivedOnly: v)),
        ),
        DropdownButtonFormField<CloudMode>(
          value: profile.cloudMode,
          decoration: const InputDecoration(labelText: 'Cloud mode'),
          items: const [
            DropdownMenuItem(value: CloudMode.localOnly, child: Text('Local-only (default)')),
            DropdownMenuItem(value: CloudMode.firebase, child: Text('Firebase (optional)')),
          ],
          onChanged: (v) => _update(profile.copyWith(cloudMode: v!)),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () async {
            final json = await LocalStorageService.instance.exportJson();
            if (!mounted) return;
            showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Export JSON'), content: SingleChildScrollView(child: Text(json))));
          },
          child: const Text('Export data (JSON)'),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () async {
            await LocalStorageService.instance.clearAll();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All local data deleted')));
            setState(() => profile = LocalStorageService.instance.getProfile());
          },
          child: const Text('Delete local data/account'),
        ),
      ],
    );
  }

  Future<void> _update(UserProfile value) async {
    profile = value;
    await LocalStorageService.instance.saveProfile(profile);
    setState(() {});
  }
}

extension on UserProfile {
  UserProfile copyWith({
    String? displayName,
    String? avatarPath,
    String? zodiac,
    bool? shareEnabled,
    bool? shareDerivedOnly,
    CloudMode? cloudMode,
  }) {
    return UserProfile(
      userId: userId,
      displayName: displayName ?? this.displayName,
      avatarPath: avatarPath ?? this.avatarPath,
      zodiac: zodiac ?? this.zodiac,
      shareEnabled: shareEnabled ?? this.shareEnabled,
      shareDerivedOnly: shareDerivedOnly ?? this.shareDerivedOnly,
      cloudMode: cloudMode ?? this.cloudMode,
    );
  }
}
