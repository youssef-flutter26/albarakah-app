# Platform setup

This source is intentionally focused on the application layer. Generate the standard
Flutter Android/iOS platform folders with the Flutter SDK:

```bash
flutter create --platforms=android,ios .
```

Then run:

```bash
flutter pub get
flutter run
```

For production, configure:
- Android applicationId
- iOS bundle identifier
- signing keys/certificates
- Firebase/FCM if push notifications are enabled
- payment provider credentials
- API base URL
- store privacy/terms URLs
