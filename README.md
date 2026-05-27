# app_for_finance

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Update App Icon

Run these commands from the project root to regenerate `assets/icon/app_icon.png`
from `assets/icon/spendly_logo.svg` and update launcher icons:

```bash
magick -background "#0D9488" assets/icon/spendly_logo.svg -flatten -resize 1024x1024 assets/icon/app_icon.png
magick assets/icon/app_icon.png -background "#0D9488" -alpha remove -alpha off assets/icon/app_icon.png
dart run flutter_launcher_icons
```
