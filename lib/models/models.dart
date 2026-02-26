import 'dart:convert';

enum AuraArchetype { blue, green, purple, yellow, orange, red, indigo }

enum CloudMode { localOnly, firebase }

class AuraReading {
  AuraReading({
    required this.id,
    required this.createdAt,
    required this.archetype,
    required this.energyScore,
    required this.interpretation,
    required this.prompts,
    required this.avgHexColor,
    required this.brightness,
    required this.contrast,
    required this.warmth,
  });

  final String id;
  final DateTime createdAt;
  final AuraArchetype archetype;
  final int energyScore;
  final String interpretation;
  final List<String> prompts;
  final String avgHexColor;
  final double brightness;
  final double contrast;
  final double warmth;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'archetype': archetype.name,
        'energyScore': energyScore,
        'interpretation': interpretation,
        'prompts': prompts,
        'avgHexColor': avgHexColor,
        'brightness': brightness,
        'contrast': contrast,
        'warmth': warmth,
      };

  factory AuraReading.fromJson(Map<String, dynamic> json) => AuraReading(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        archetype: AuraArchetype.values.byName(json['archetype'] as String),
        energyScore: json['energyScore'] as int,
        interpretation: json['interpretation'] as String,
        prompts: (json['prompts'] as List).cast<String>(),
        avgHexColor: json['avgHexColor'] as String,
        brightness: (json['brightness'] as num).toDouble(),
        contrast: (json['contrast'] as num).toDouble(),
        warmth: (json['warmth'] as num).toDouble(),
      );
}

class PalmTraits {
  PalmTraits({
    required this.heartLine,
    required this.headLine,
    required this.lifeLine,
    required this.openness,
    required this.quality,
    required this.summary,
  });

  final String heartLine;
  final String headLine;
  final String lifeLine;
  final String openness;
  final int quality;
  final String summary;

  Map<String, dynamic> toJson() => {
        'heartLine': heartLine,
        'headLine': headLine,
        'lifeLine': lifeLine,
        'openness': openness,
        'quality': quality,
        'summary': summary,
      };

  factory PalmTraits.fromJson(Map<String, dynamic> json) => PalmTraits(
        heartLine: json['heartLine'] as String,
        headLine: json['headLine'] as String,
        lifeLine: json['lifeLine'] as String,
        openness: json['openness'] as String,
        quality: json['quality'] as int,
        summary: json['summary'] as String,
      );
}

class PalmReading {
  PalmReading({
    required this.id,
    required this.createdAt,
    required this.traits,
  });

  final String id;
  final DateTime createdAt;
  final PalmTraits traits;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'traits': traits.toJson(),
      };

  factory PalmReading.fromJson(Map<String, dynamic> json) => PalmReading(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        traits: PalmTraits.fromJson(json['traits'] as Map<String, dynamic>),
      );
}

class DailyHoroscope {
  DailyHoroscope({
    required this.date,
    required this.paragraph,
    required this.luckyColor,
    required this.focusTheme,
    required this.doItem,
    required this.dontItem,
  });

  final String date;
  final String paragraph;
  final String luckyColor;
  final String focusTheme;
  final String doItem;
  final String dontItem;

  Map<String, dynamic> toJson() => {
        'date': date,
        'paragraph': paragraph,
        'luckyColor': luckyColor,
        'focusTheme': focusTheme,
        'doItem': doItem,
        'dontItem': dontItem,
      };

  factory DailyHoroscope.fromJson(Map<String, dynamic> json) => DailyHoroscope(
        date: json['date'] as String,
        paragraph: json['paragraph'] as String,
        luckyColor: json['luckyColor'] as String,
        focusTheme: json['focusTheme'] as String,
        doItem: json['doItem'] as String,
        dontItem: json['dontItem'] as String,
      );
}

class UserProfile {
  UserProfile({
    required this.userId,
    required this.displayName,
    this.avatarPath,
    this.zodiac,
    this.shareEnabled = false,
    this.shareDerivedOnly = true,
    this.cloudMode = CloudMode.localOnly,
  });

  final String userId;
  final String displayName;
  final String? avatarPath;
  final String? zodiac;
  final bool shareEnabled;
  final bool shareDerivedOnly;
  final CloudMode cloudMode;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'avatarPath': avatarPath,
        'zodiac': zodiac,
        'shareEnabled': shareEnabled,
        'shareDerivedOnly': shareDerivedOnly,
        'cloudMode': cloudMode.name,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['userId'] as String,
        displayName: json['displayName'] as String,
        avatarPath: json['avatarPath'] as String?,
        zodiac: json['zodiac'] as String?,
        shareEnabled: json['shareEnabled'] as bool? ?? false,
        shareDerivedOnly: json['shareDerivedOnly'] as bool? ?? true,
        cloudMode: CloudMode.values.byName(
          (json['cloudMode'] as String?) ?? CloudMode.localOnly.name,
        ),
      );
}

class FriendSummary {
  FriendSummary({
    required this.friendUid,
    required this.displayName,
    required this.inviteCode,
    this.latestAura,
    this.latestPalm,
    this.latestHoroscope,
  });

  final String friendUid;
  final String displayName;
  final String inviteCode;
  final AuraArchetype? latestAura;
  final String? latestPalm;
  final String? latestHoroscope;

  Map<String, dynamic> toJson() => {
        'friendUid': friendUid,
        'displayName': displayName,
        'inviteCode': inviteCode,
        'latestAura': latestAura?.name,
        'latestPalm': latestPalm,
        'latestHoroscope': latestHoroscope,
      };

  factory FriendSummary.fromJson(Map<String, dynamic> json) => FriendSummary(
        friendUid: json['friendUid'] as String,
        displayName: json['displayName'] as String,
        inviteCode: json['inviteCode'] as String,
        latestAura: json['latestAura'] == null
            ? null
            : AuraArchetype.values.byName(json['latestAura'] as String),
        latestPalm: json['latestPalm'] as String?,
        latestHoroscope: json['latestHoroscope'] as String?,
      );
}

String encodeJsonList(List<Map<String, dynamic>> data) => jsonEncode(data);
List<Map<String, dynamic>> decodeJsonList(String raw) =>
    (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
