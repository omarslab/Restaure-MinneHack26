# MinneHack2026

# Restaure (Flutter)

Restaure is a location-based mobile app designed to restore visibility and engagement for small businesses in Minneapolis.
Instead of letting struggling local businesses lose attention and revenue, our app highlights them and encourages real-world support through discovery, rewards, and community interaction.

Our project directly aligns with the “Mending Over Ending” theme by using technology to mend local economic engagement rather than allowing small businesses to be forgotten.

## Features
- Browse restaurants with photos and details
- Search by name or cuisine
- Leave reviews and earn points
- QR code rewards
- Map with restaurant markers and directions
- Profile with points, reviews, and check‑ins
- Heartbreak badge for low‑review restaurants
- Firebase Authentication for user login
- OpenStreetMap map tiles

## Run the App
```bash
flutter pub get
flutter run
## Firebase setup
1. Create your own Firebase project.
2. Download Android config as `google-services.json`.
3. Place it at `restaurant_discovery_flutter/android/app/google-services.json`.
4. Keep this file local and out of git, use `android/app/google-services.example.json` as a template.
