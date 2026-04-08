# Event Ease

**Event Ease** is a Flutter-based mobile application designed to streamline event management.

---

## Project Details

* **Project Name:** `event_ease`
* **Description:** A new Flutter project for event management
* **Version:** 1.1.0+1
* **Flutter SDK Version:** ^3.9.0

---

## Prerequisites

Before running the app, make sure your environment is set up:

1. **Flutter**: Install Flutter SDK ≥ 3.9.0
   [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
2. **Dart**: Installed with Flutter SDK
3. **Platform tools**:

   * Android Studio (for Android)
   * Xcode (for iOS)
4. **Connected devices or emulator/simulator**:

   * Android Emulator / iOS Simulator or a physical device

---

## Installation

1. Clone the project:

   ```bash
   git clone <repository_url>
   cd event_ease
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Ensure code generation and assets are updated (if using build_runner):

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

---

## Running the App

* **On Android Emulator / Device:**

  ```bash
  flutter run
  ```

* **On iOS Simulator / Device:**

  ```bash
  flutter run
  ```

* **For Web (optional):**

  ```bash
  flutter run -d chrome
  ```

---

## Build

* **Android APK:**

  ```bash
  flutter build apk --release
  ```

* **iOS IPA:**

  ```bash
  flutter build ios --release
  ```

* **Web Build:**

  ```bash
  flutter build web
  ```

---

## Dependencies

The project uses the following main Flutter packages:

* `get`, `flutter_screenutil`, `shared_preferences`, `image_picker`, `cached_network_image`
* `flutter_svg`, `shimmer`, `persistent_bottom_nav_bar`, `intl`, `font_awesome_flutter`
* `google_maps_flutter`, `google_sign_in`, `firebase_core`, `firebase_messaging`
* `flutter_local_notifications`, `webview_flutter`, `geolocator`, `photo_view`, `video_player`

> Full list is in `pubspec.yaml`

---

## Assets

Assets are located under the `assets/` directory:

* `assets/images/` – Images used in the app
* `assets/icons/` – App icons and category icons
* `assets/checklist/` – Checklist assets
* `assets/microcatagory/` – Subcategory assets

> All assets are already included in `pubspec.yaml` for use in the app.

---

## Notes

* The app uses **Firebase** for push notifications. Ensure Firebase is configured for both Android and iOS.
* The app requires **location permissions** for map features.
* Make sure to run `flutter pub get` after any dependency updates.
