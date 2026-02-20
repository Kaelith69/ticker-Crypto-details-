# Nyx — Crypto Details App

<div align="center">

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 200" width="640" height="200">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#0f0c29"/>
      <stop offset="50%" style="stop-color:#302b63"/>
      <stop offset="100%" style="stop-color:#24243e"/>
    </linearGradient>
    <linearGradient id="accent" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#f7971e"/>
      <stop offset="100%" style="stop-color:#ffd200"/>
    </linearGradient>
  </defs>
  <rect width="640" height="200" rx="18" fill="url(#bg)"/>
  <circle cx="580" cy="100" r="70" fill="none" stroke="#ffffff10" stroke-width="1.5"/>
  <circle cx="580" cy="100" r="50" fill="none" stroke="#ffffff18" stroke-width="1.5"/>
  <circle cx="580" cy="100" r="30" fill="none" stroke="#ffffff22" stroke-width="1.5"/>
  <text x="568" y="114" font-family="Georgia,serif" font-size="48" fill="url(#accent)" opacity="0.8">&#8383;</text>
  <text x="48" y="90" font-family="'Helvetica Neue',Arial,sans-serif" font-size="52" font-weight="700" letter-spacing="12" fill="#ffffff">NYX</text>
  <text x="50" y="128" font-family="'Helvetica Neue',Arial,sans-serif" font-size="16" fill="url(#accent)" letter-spacing="4">CRYPTO DETAILS</text>
  <text x="50" y="162" font-family="'Helvetica Neue',Arial,sans-serif" font-size="12" fill="#ffffff66" letter-spacing="1">Real-time cryptocurrency rates • Built with Flutter</text>
</svg>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-informational?style=flat-square)](pubspec.yaml)
[![API](https://img.shields.io/badge/API-CoinGecko-brightgreen?style=flat-square)](https://www.coingecko.com/en/api)

</div>

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Setup & Installation](#setup--installation)
6. [Usage](#usage)
7. [API Reference](#api-reference)
8. [Bugs Fixed](#bugs-fixed)
9. [License](#license)

---

## Overview

**Nyx** is a cross-platform Flutter application that delivers live cryptocurrency market data at a glance. Pick a coin from the scrollable list, tap the button, and instantly see the current price, 24-hour change, and market cap — all pulled from the free [CoinGecko API](https://www.coingecko.com/en/api).

> 🐦 *Why "Nyx"? In Greek mythology, Nyx is the goddess of the night — fitting for an app that never sleeps on price updates.*

---

## Features

| Feature | Details |
|---|---|
| 📈 Live Price | Fetches real-time USD prices via CoinGecko |
| 🔄 24h Change | Shows percentage gain/loss (green/red) |
| 🏦 Market Cap | Displays total market capitalisation |
| 🖼 Coin Logo | Loads each coin's official image |
| �� System Theme | Automatically follows device light/dark mode |
| ⚠️ Error Handling | Graceful messages on network failures |
| 📱 Cross-platform | Runs on Android, iOS, Web, Linux, macOS, Windows |

---

## Architecture

```
┌──────────────────────────────────────────────────┐
│                    Myapp (root)                   │
│  MaterialApp — system light/dark theme, no banner │
└────────────────────┬─────────────────────────────┘
                     │
              ┌──────▼──────┐
              │  Duck (page) │  StatefulWidget
              └──────┬──────┘
                     │
       ┌─────────────▼─────────────────┐
       │  _DuckState                   │
       │  ● selectedCoin: String        │
       │  ● coinData: Map<String,dyn>   │
       │  ● isLoading: bool             │
       │  ● errorMessage: String?       │
       └────────┬──────────────────────┘
                │  fetchCoinMarketData()  ──►  CoinGecko REST API
                │  (try/catch, async)         /coins/markets?ids=...
                ▼
         Scaffold ► AppBar + Body
                     ▼
              _buildRing() × 4     ← concentric card decoration
                     ▼
         CupertinoPicker + Button + CoinInfo
```

The app follows a simple **single-page stateful pattern**:
- All state lives in `_DuckState`.
- `fetchCoinMarketData` is the sole async data-fetching function; it wraps the HTTP call in a `try/catch` and always updates `isLoading` regardless of outcome.
- `_buildRing` is a private helper that removes repetition from the concentric-border decoration.

---

## Project Structure

```
ticker-Crypto-details-/
├── android/                    # Android host app
├── ios/                        # iOS host app
├── linux/                      # Linux desktop host
├── macos/                      # macOS desktop host
├── web/                        # Web host
├── windows/                    # Windows desktop host
├── lib/
│   └── main.dart               # ★ Entire app: root widget + Duck page
├── analysis_options.yaml       # Dart/Flutter lint rules
├── pubspec.yaml                # Dependencies & metadata (Dart ≥ 3.0)
├── pubspec.lock                # Dependency lock file
├── LICENSE                     # MIT licence
└── README.md                   # You are here
```

---

## Setup & Installation

### Prerequisites

| Tool | Minimum Version |
|---|---|
| Flutter SDK | 3.10+ |
| Dart SDK | 3.0+ |
| Android Studio / Xcode | Latest stable (for emulators) |

### 1. Clone the repo

```bash
git clone https://github.com/Kaelith69/ticker-Crypto-details-.git
cd ticker-Crypto-details-
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run on a device or emulator

```bash
# List available devices
flutter devices

# Run on the default device
flutter run

# Target a specific platform
flutter run -d chrome          # Web
flutter run -d linux           # Linux desktop
```

### 4. Build a release APK (Android)

```bash
flutter build apk --release
```

---

## Usage

1. **Launch** the app — it immediately loads live Bitcoin data.
2. **Scroll** the picker to choose a different cryptocurrency.
3. **Tap "Show Coin Data"** to refresh the data for the selected coin.
4. The card displays:
   - 🖼 Coin logo
   - 🏷 Name & ticker symbol
   - 💵 Current price in USD
   - 📊 24-hour percentage change (green = gain, red = loss)
   - 🏦 Total market cap

> 🐕 *Insert a quirky "Doge to the moon" GIF here to celebrate those green candles!*

---

## API Reference

The app uses the free, no-auth-required tier of the **CoinGecko v3 API**.

**Endpoint used:**

```
GET https://api.coingecko.com/api/v3/coins/markets
    ?vs_currency=usd
    &ids={coinId}
```

**Fields consumed:**

| Field | Type | Usage |
|---|---|---|
| `name` | String | Coin full name |
| `symbol` | String | Ticker symbol |
| `image` | String (URL) | Logo image |
| `current_price` | Number | Price in USD |
| `price_change_percentage_24h` | Number | 24h % change |
| `market_cap` | Number | Total market cap |

---

## Bugs Fixed

The following issues were identified and resolved during the refactor:

| # | Bug | Root Cause | Fix |
|---|---|---|---|
| 1 | App renders inside two navigator stacks | `WidgetsApp` incorrectly wrapping `MaterialApp` | Removed `WidgetsApp`; use `MaterialApp` directly |
| 2 | Light mode always shows dark theme | Both `theme` and `darkTheme` set to `ThemeData.dark()` | `theme` now uses `ThemeData.light()`; `themeMode: ThemeMode.system` |
| 3 | Memory leak | `scrollController` never disposed | Added `dispose()` override |
| 4 | App crashes on network error | No `try/catch` around HTTP call | Wrapped in `try/catch`; shows `errorMessage` |
| 5 | `CupertinoPicker` unbounded in Column | No height constraint | Wrapped in `SizedBox(height: 160)` |
| 6 | Null pointer on missing image | `coinData['image']` used directly without null check | Added `if (coinData['image'] != null)` guard |
| 7 | No data on launch | No `initState` call | Added `initState` → `fetchCoinMarketData('bitcoin')` |
| 8 | Deprecated constructor style | `Key? key` without `super.key` | Migrated to `super.key` |
| 9 | Unused variable warning | `isNightModeEnabled` declared but never read | Removed |
| 10 | Duplicated decoration code | 4 identical `Container` blocks | Extracted to `_buildRing()` helper |
| 11 | Non-`const` literals | `Offset(0,0)`, `SizedBox.square`, Shadow list | Replaced with `Offset.zero` and `const` |
| 12 | SDK too restrictive | `>=2.19.6 <3.0.0` blocked Dart 3 | Updated to `>=3.0.0 <4.0.0` |

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

*Built with ❤️ and Flutter*

---

**Footer Dad Joke 🥁**

> *Why did the programmer quit his job?*
> *Because he didn't get arrays.* 🥴

</div>
