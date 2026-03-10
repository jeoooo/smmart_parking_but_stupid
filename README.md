# SM SmartParking

A Concept Flutter mobile app for managing parking at SM shopping malls — featuring QR-based entry/exit, real-time slot availability, and integrated payment processing.

## Features

- **QR Entry/Exit** — Scan QR codes to start and end parking sessions
- **Live Availability** — Real-time gate occupancy by branch and entry point
- **Fee Calculation** — Automatic computation based on duration (base rate for the first 3 hours + hourly overage)
- **Multiple Payment Methods** — GCash, Maya, and Credit/Debit Card
- **Session History** — View past sessions and receipts
- **Multi-Branch Support** — Switch between SM branches (SM City Davao, SM Lanang Premier)
- **Demo Mode** — Simulate the full parking flow without a real QR scan

## Screens

| Screen | Description |
|---|---|
| Splash | Animated intro with branch name, auto-navigates to Home |
| Home | Three tabs: Availability, Records, and Info |
| Entry | Session start confirmation |
| Session | Live timer showing elapsed parking time |
| Exit/Payment | Fee breakdown and session summary |
| Payment Method | Choose GCash, Maya, or Card |
| Payment Form | Enter wallet ID or card details |
| Payment Success | Confirmation with transaction ID |
| Receipt | Full receipt with session and payment details |

## Tech Stack

- **Framework:** Flutter (Material Design 3)
- **State Management:** Stateful widgets + singleton manager classes (`SessionManager`, `BranchManager`)
- **Navigation:** Named routes
- **Key Packages:**
  - `flutter_svg` — SVG logo rendering
  - `lucide_icons_flutter` — UI icons
  - `flutter_launcher_icons` — App icon generation

## Getting Started

**Prerequisites:** Flutter SDK 3.10.7+

```bash
# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Build release APK
flutter build apk --release
```

## Project Structure

```
lib/
├── main.dart               # Entry point and route definitions
├── models.dart             # Data models, manager classes, utilities
├── theme.dart              # App theme and color system
├── screens/
│   └── customer/           # All app screens
└── widgets/                # Reusable UI components
assets/
├── logos/                  # Brand and payment logos
└── fonts/                  # HenrySans custom font
```

## Parking Rate

- **Base rate:** Fixed fee covering the first 3 hours
- **Overage:** Per-hour fee applied after the base period

Rates are displayed in the **Info** tab of the app.
