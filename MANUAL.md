# CalcuttaNode Apps — Complete Setup & Operations Manual

---

## Table of Contents

1. [Project Structure Overview](#1-project-structure-overview)
2. [Prerequisites — What to Install](#2-prerequisites)
3. [Backend Setup (Node.js + MongoDB)](#3-backend-setup)
4. [React Native App — Run, Build APK, Change Code](#4-react-native-app)
5. [Flutter App — Run, Build APK, Change Code](#5-flutter-app)
6. [Database Integration & Data Management](#6-database)
7. [API Keys & Environment Configuration](#7-api-keys)
8. [How to Extract & Change Data](#8-data-management)
9. [How to Build APK Files](#9-build-apk)
10. [How to Publish to Play Store](#10-publishing)
11. [Common Troubleshooting](#11-troubleshooting)

---

## 1. Project Structure Overview

```
CalcuttaNode Apps/
├── app/                    ← React Native (Expo)
├── flutter_app/            ← Flutter (Dart)
└── backend/                ← (optional — mobile apps now use main project backend)
```

Both apps connect to the **main Calcutta Node project's backend** (`../Calcutta Node/server/`) which already has MongoDB Atlas configured. You do NOT need to run the `backend/` folder separately.

---

## 2. Prerequisites

Install these on your computer before starting:

### Required for All

| Tool | What It Does | Install Command / Link |
|------|-------------|----------------------|
| **Node.js 18+** | Runs backend | Download from https://nodejs.org |
| **MongoDB** | Database | https://mongodb.com/try (free Atlas) or local install |
| **Git** | Version control | https://git-scm.com |

### Required for React Native

| Tool | Install |
|------|---------|
| **Expo CLI** | `npm install -g expo-cli` |
| **Expo Go app** | Install from Play Store / App Store on your phone |

### Required for Flutter

| Tool | Install |
|------|---------|
| **Flutter SDK** | https://docs.flutter.dev/get-started/install |
| **Android Studio** | https://developer.android.com/studio (for emulator) |
| **VS Code + Flutter extension** | Recommended IDE |

### Verify Installation

```bash
node --version        # Should show v18+ 
npm --version         # Should show 9+
flutter --version     # Should show 3.x+
dart --version        # Should show 3.x+
mongod --version      # Any version
```

---

## 3. Backend Setup

The mobile apps use the **main Calcutta Node backend** (`../Calcutta Node/server/`) which already has MongoDB Atlas connected.

### 3.1 Start the Main Backend

```bash
cd "Calcutta Node/server"
npm install              # First time only
npm start                # Starts server on http://localhost:5000
```

MongoDB Atlas is already configured in `server/.env` — the connection string points to the free Atlas cluster.

### 3.2 Verify Backend Works

```bash
curl http://localhost:5000/api/health
→ {"status":"ok","timestamp":"..."}
```

### 3.3 Seed Data (Add Default Services)

The services must be added to the database. You can either:

**Option A — Use the website admin panel** (recommended):
1. Go to your website admin
2. Navigate to Admin → Seed
3. Click "Seed Services"

**Option B — Manual insert via MongoDB Compass:**
1. Open MongoDB Compass
2. Connect to your database
3. Create collection: `services`
4. Insert documents (JSON format)

**Option C — Create a seed script:**
```bash
# Create backend/src/seed.js with service data, then run:
node src/seed.js
```

---

## 4. React Native App

### 4.1 Install Dependencies

```bash
cd "CalcuttaNode Apps/app"
npm install
```

### 4.2 Configure API URL

The API URL is already set in `src/constants/config.js` — it auto-detects the right URL:

```javascript
// Platform-aware: Android emulator → 10.0.2.2, iOS simulator → localhost
// Production → https://calcuttanode-api.onrender.com/api
export const API_BASE_URL = __DEV__ ? DEV_API : PROD_API;
```

For **physical device testing**, if the auto IP doesn't work, edit `config.js` and replace with your computer's local IP:
```javascript
const DEV_API = Platform.select({
  android: 'http://YOUR_IP:5000/api',  // Replace YOUR_IP
  ios: 'http://YOUR_IP:5000/api',
});

### 4.3 Run on Phone (Development)

```bash
cd "CalcuttaNode Apps/app"
npx expo start
```

1. Install **Expo Go** on your phone
2. Scan the QR code shown in terminal
3. App loads on your phone

### 4.4 Run on Emulator

```bash
# Android emulator:
npx expo start --android

# iOS simulator (Mac only):
npx expo start --ios
```

### 4.5 Build APK (Android)

**Method 1 — EAS Build (Recommended, Cloud):**
```bash
# Install EAS CLI:
npm install -g eas-cli

# Login to Expo:
eas login

# Configure build:
eas build:configure

# Build APK:
eas build --platform android --profile preview
```

**Method 2 — Local Build:**
```bash
# Generate native Android project:
npx expo prebuild --platform android

# Build APK manually:
cd android
./gradlew assembleRelease

# APK location:
# android/app/build/outputs/apk/release/app-release.apk
```

### 4.6 Build IPA (iOS)

```bash
# Requires Apple Developer account ($99/year)
eas build --platform ios
```

---

## 5. Flutter App

### 5.1 Initialize Flutter Project

```bash
cd "CalcuttaNode Apps/flutter_app"

# First time — generate platform folders (android/, ios/):
flutter create .

# Install packages:
flutter pub get
```

### 5.2 Configure API URL

The API URL is already set in `lib/constants/config.dart` — it auto-detects the right URL:

```dart
class AppConfig {
  // Release → https://calcuttanode-api.onrender.com/api
  // Android emulator → http://10.0.2.2:5000/api
  // iOS simulator / desktop → http://localhost:5000/api
  static String get apiBaseUrl { ... }
}
```

For **physical device testing**, edit `config.dart` and override the dev URL with your computer's IP.

### 5.3 Run on Phone (Development)

```bash
cd "CalcuttaNode Apps/flutter_app"

# List connected devices:
flutter devices

# Run on connected phone:
flutter run

# Run on emulator:
flutter run --emulator
```

### 5.4 Run on Emulator

```bash
# Start Android emulator first from Android Studio
flutter run

# Or specify device:
flutter run -d emulator-5554
```

### 5.5 Build APK

```bash
cd "CalcuttaNode Apps/flutter_app"

# Debug APK (for testing):
flutter build apk --debug

# Release APK (for production):
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk
```

### 5.6 Build App Bundle (for Play Store)

```bash
flutter build appbundle --release

# Location:
# build/app/outputs/bundle/release/app-release.aab
```

### 5.7 Build IPA (iOS)

```bash
# Requires Xcode (Mac only) + Apple Developer account
flutter build ipa --release
```

---

## 6. Database Integration & Data Management

### 6.1 MongoDB Collections

The app uses these collections (auto-created by Mongoose):

| Collection | Purpose |
|-----------|---------|
| `users` | User accounts (name, email, password, wallet, loyalty) |
| `services` | Service listings (name, price, category, features) |
| `orders` | Customer orders (status, amount, notes) |
| `products` | Digital products (name, price, fileUrl) |
| `plans` | Subscription plans (price, features, badge) |
| `transactions` | Payment records |
| `blogs` | Blog posts |
| `reviews` | Customer reviews |
| `messages` | Contact form submissions |

### 6.2 Connect to Database (MongoDB Compass)

1. Download MongoDB Compass: https://www.mongodb.com/products/compass
2. Open Compass
3. Connect to: `mongodb://localhost:27017` (local) or paste Atlas URI
4. Browse `calcuttanode` database → collections → documents

### 6.3 Import/Export Data

```bash
# Export all data:
mongodump --db=calcuttanode --out=./backup

# Import data:
mongorestore --db=calcuttanode ./backup/calcuttanode

# Export single collection to JSON:
mongoexport --db=calcuttanode --collection=services --out=services.json

# Import from JSON:
mongoimport --db=calcuttanode --collection=services --file=services.json
```

### 6.4 Reset Database

```bash
# Drop entire database:
mongo
> use calcuttanode
> db.dropDatabase()

# Then re-seed via admin panel or seed script
```

---

## 7. API Keys & Environment Configuration

### 7.1 Razorpay (Payments)

1. Go to https://dashboard.razorpay.com
2. Create account / Login
3. Go to Settings → API Keys
4. Copy Key ID and Key Secret
5. Add to `backend/.env`:
```
RAZORPAY_KEY_ID=rzp_test_xxxxxxxxxxxxx
RAZORPAY_KEY_SECRET=xxxxxxxxxxxxxxxxxxxxxxxx
```

### 7.2 Google OAuth (Optional)

For Google login on the website:
1. Go to https://console.cloud.google.com
2. Create project → Enable Google+ API
3. Create OAuth 2.0 credentials
4. Add Client ID to website environment

### 7.3 JWT Secrets

Generate secure random strings:
```bash
# On Windows (PowerShell):
-join ((1..32) | ForEach-Object { [char](Get-Random -Minimum 97 -Maximum 123) })

# On Mac/Linux:
openssl rand -hex 32
```

Use one for `JWT_SECRET` and another for `JWT_REFRESH_SECRET` in `.env`.

### 7.4 Production Environment Variables

For deployed server (Render, Railway, Vercel, etc.), set these environment variables:
```
PORT=5000
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/calcuttanode
JWT_SECRET=your_production_secret
JWT_REFRESH_SECRET=your_production_refresh_secret
RAZORPAY_KEY_ID=rzp_live_xxxxx
RAZORPAY_KEY_SECRET=xxxxx
```

---

## 8. How to Extract & Change Data

### 8.1 Change Service Prices/Details

**Via Admin Panel (website):**
1. Login as admin on your website
2. Go to Admin Dashboard → Services
3. Edit service name, price, features
4. Save changes

**Via Database Directly:**
```javascript
// Connect to MongoDB, then:
db.services.updateOne(
  { name: "Website Development" },
  { $set: { price: 5999, description: "Updated description" } }
);
```

### 8.2 Change User Data

```javascript
// Find user by email:
db.users.findOne({ email: "user@example.com" });

// Update wallet balance:
db.users.updateOne(
  { email: "user@example.com" },
  { $set: { walletBalance: 500 } }
);

// Add loyalty points:
db.users.updateOne(
  { email: "user@example.com" },
  { $inc: { loyaltyPoints: 100 } }
);

// Change user role to admin:
db.users.updateOne(
  { email: "user@example.com" },
  { $set: { role: "admin" } }
);
```

### 8.3 Change Order Status

```javascript
db.orders.updateOne(
  { _id: ObjectId("ORDER_ID_HERE") },
  { $set: { status: "completed" } }
);
```

### 8.4 Extract All Orders to CSV

```javascript
// In MongoDB shell:
db.orders.find().forEach(function(doc) {
  print(doc.createdAt + "," + doc.status + "," + doc.amount);
});
```

### 8.5 Export All Users

```javascript
// Get all users as JSON:
db.users.find({}, { name: 1, email: 1, phone: 1, role: 1 }).toArray()
```

### 8.6 Change Subscription Plans

```javascript
db.plans.updateOne(
  { name: "Monthly Tune-Up" },
  { $set: { price: 1199, features: ["Updated feature 1", "Updated feature 2"] } }
);
```

---

## 9. How to Build APK Files

### 9.1 React Native — Step by Step

```bash
# Step 1: Navigate to app folder
cd "CalcuttaNode Apps/app"

# Step 2: Install dependencies (first time)
npm install

# Step 3: Configure API URL in src/constants/config.js
# Change API_BASE_URL to your server address

# Step 4: Install EAS CLI
npm install -g eas-cli

# Step 5: Login to Expo account (create one at expo.dev)
eas login

# Step 6: Configure build
eas build:configure

# Step 7: Build APK
eas build --platform android --profile preview

# Step 8: Wait for build (5-15 minutes)
# Download APK from the link provided in terminal
```

### 9.2 Flutter — Step by Step

```bash
# Step 1: Navigate to flutter app
cd "CalcuttaNode Apps/flutter_app"

# Step 2: Initialize (first time)
flutter create .
flutter pub get

# Step 3: Configure API URL in lib/constants/config.dart

# Step 4: Build APK
flutter build apk --release

# Step 5: APK is at:
# build/app/outputs/flutter-apk/app-release.apk
```

### 9.3 Sign APK for Release

For production release, you need to sign the APK:

```bash
# Create keystore (one time):
keytool -genkey -v -keystore calcuttanode-release.key \
  -alias calcuttanode -keyalg RSA -keysize 2048 -validity 10000

# React Native: Add signing config to android/app/build.gradle
# Flutter: Configure android/key.properties
```

---

## 10. How to Publish to Play Store

1. Create Google Play Developer account ($25 one-time): https://play.google.com/console
2. Create new app
3. Upload AAB file (not APK):
   - React Native: `eas build --platform android --profile production`
   - Flutter: `flutter build appbundle --release`
4. Fill in store listing, screenshots, description
5. Set pricing (free or paid)
6. Submit for review (takes 1-3 days)

---

## 11. Common Troubleshooting

### App won't connect to backend
- Check your computer and phone are on the **same WiFi network**
- Use your computer's **local IP** (not localhost) — run `ipconfig` to find it
- Check firewall isn't blocking port 5000
- Make sure backend is running: `npm start`

### MongoDB connection error
```bash
# Make sure MongoDB is running:
# Windows: Check Services → MongoDB
# Mac/Linux: sudo systemctl start mongod
```

### Flutter build error
```bash
flutter clean
flutter pub get
flutter run
```

### React Native Metro bundler error
```bash
npx expo start --clear
```

### Port 5000 already in use
```bash
# Windows:
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -ti:5000 | xargs kill -9
```

### APK not installing on phone
- Enable "Install from Unknown Sources" in phone settings
- Make sure you have enough storage
- Try uninstalling old version first

---

## Quick Reference — All Commands

```bash
# === BACKEND ===
cd backend
npm install                          # Install deps
npm start                            # Start server
npm run dev                          # Start with auto-reload

# === REACT NATIVE ===
cd app
npm install                          # Install deps
npx expo start                       # Start dev server
npx expo start --clear               # Clear cache & start
eas build --platform android --profile preview  # Build APK

# === FLUTTER ===
cd flutter_app
flutter create .                     # First time only
flutter pub get                      # Install packages
flutter run                          # Run on device
flutter run --release                # Run release mode
flutter build apk --release          # Build APK
flutter clean                        # Clean build cache
```

---

*Last updated: July 2026*
*Calcutta Node. — IT Services & Digital Growth Agency*
