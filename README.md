# AuraPal (iOS 17+, Swift 5.9)

AuraPal is an **entertainment / self-reflection only** app for aura and palm-inspired readings. It performs image analysis on-device and stores only derived reading data by default.

## Setup (Xcode)
1. Open Xcode 15+ and create/use an iOS App target named `AuraPal`.
2. Add the `AuraPal/` source folders from this repository to the app target.
3. Enable iOS 17 deployment target.
4. (Optional for CloudKit friends sync) Enable **iCloud > CloudKit** capability.
5. Build and run on a device for camera features.

## Required Permission Strings (Info.plist)
- `NSCameraUsageDescription`: “AuraPal uses the camera for selfie aura and palm scan readings.”
- `NSPhotoLibraryUsageDescription`: “AuraPal lets you choose photos for entertainment aura readings.”
- `NSPhotoLibraryAddUsageDescription`: “AuraPal saves optional derived summary cards when you share.”

## CloudKit Notes
- `FriendService` includes TODO markers for setting your CloudKit container ID and production schema.
- App ships with mock friend data fallback when CloudKit is unavailable.

## Privacy Defaults
- Raw photos are not uploaded.
- Derived readings only are persisted in local SwiftData.
- Optional thumbnail storage can be added behind user opt-in (stubbed via settings flags).

## Disclaimer
AuraPal content is for entertainment and personal reflection only. It is not medical, psychological, legal, or financial advice.
