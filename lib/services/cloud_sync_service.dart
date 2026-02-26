import '../models/models.dart';

/// Optional Firebase integration service.
/// TODO: Add firebase_options.dart and initialize in main.dart.
/// TODO: Place android/app/google-services.json.
/// TODO: Place ios/Runner/GoogleService-Info.plist.
class CloudSyncService {
  Future<void> syncProfile(UserProfile profile) async {
    // Intended Firestore path:
    // users/{uid}: profile + privacy settings + latestReadingSummary
  }

  Future<void> syncFriend(FriendSummary friend, String uid) async {
    // Intended Firestore path:
    // users/{uid}/friends/{friendUid}: friend relationship + shared status
  }

  Future<void> createInviteCode(String uid, String code) async {
    // Intended Firestore path:
    // invites/{code}: uid + expiresAt
  }
}
