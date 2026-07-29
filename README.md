# Spendly

A personal expense tracker for iOS built with Flutter. Reads bank notification
emails from Gmail, normalizes everything to USD using the historical rate for
the day of each transaction, and keeps your data 100 % local.

## Supported Banks

### Dominican Republic
| Bank          | Sender domain / email          |
| ------------- | ------------------------------ |
| Qik           | `qik.do`, `notificaciones@qik.do` |
| BHD           | `bhd.com.do`                   |
| Popular       | `popular.com.do`               |
| Banreservas   | `banreservas.com`              |
| Scotiabank    | `scotiabank.com`               |
| APAP          | `apap.com.do`                  |
| Promerica     | `promerica.com.do`             |
| Santa Cruz    | `bsc.com.do`                   |

### United States
| Bank            | Sender domain / email                        |
| --------------- | -------------------------------------------- |
| Bank of America | `ealerts.bankofamerica.com`, `onlinebanking@ealerts.bankofamerica.com` |
| Chase (JPMorgan)| `chase.com`, `alertsp.chase.com`             |
| Citibank        | `info3.citibank.com`, `citicards@info3.citibank.com`, `citi.com` |
| U.S. Bank       | `alerts@usbank.com`, `notifications.usbank.com` |
| Capital One     | `notification.capitalone.com`, `capitalone.com` |

> The parser handles both Spanish (RD$/DOP) and English (USD) email formats.
> You can add or remove senders on the Bank email import screen.

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

## Run On Mac (iOS)

Before running the app from macOS, complete this setup:

1. Install requirements:
   - Flutter SDK
   - Xcode (and Xcode Command Line Tools)
   - CocoaPods (`sudo gem install cocoapods` or Homebrew setup)
2. From project root, install dependencies:
   ```bash
   flutter pub get
   ```
3. Install iOS pods:
   ```bash
   cd ios && pod install && cd ..
   ```
4. If using Gmail sync on iOS, configure OAuth first:
   - Add `GIDClientID` and `CFBundleURLTypes` in `ios/Runner/Info.plist`
   - Keep OAuth plist files local (do not commit secrets)
5. Verify connected devices:
   ```bash
   flutter devices
   ```
6. Run:
   ```bash
   flutter run -d "iPhone_14"
   ```
   For a physical iPhone, use:
   ```bash
   flutter run --release -d "<Your iPhone Name>"
   ```
