# Lumen App - Complete Store Deployment Guide

This guide provides step-by-step instructions for deploying the Lumen app to both the Apple App Store and Google Play Store.

## Important Note About In-App Purchases

The app currently uses Stripe for payments. However, **Apple and Google require native in-app purchases (IAP) for digital subscriptions sold within mobile apps**. Before submitting to the stores, you must either:

1. **Implement native IAP** (recommended) - Use the `in_app_purchase` package already included in the app
2. **Remove purchase flows from mobile** - Direct users to purchase on the website only

This guide assumes you will implement native IAP as recommended.

## Prerequisites

- ✅ Apple Developer Account ($99/year)
- ✅ Google Play Console Account ($25 one-time)
- ✅ Supabase production credentials (provided)
- ✅ Stripe account (for web purchases)
- ✅ macOS computer with Xcode (for iOS builds)
- ✅ Flutter SDK installed

## Production Credentials

**Supabase Production:**
- URL: `https://slvwtiicaxkpvupbmbki.supabase.co`
- Anon Key: `YOUR_SUPABASE_ANON_KEY_HERE`

**App Identifiers:**
- iOS Bundle ID: `com.growwithlumen.app`
- Android Package Name: `com.growwithlumen.app`

## Part 1: Implement Native In-App Purchases

### Step 1: Complete IAP Service Implementation

The IAP service has been started in `lib/features/premium/services/iap_service.dart`. You need to:

1. Create a Riverpod provider for the IAP service
2. Update the premium/subscription UI to use native IAP instead of Stripe
3. Add proper error handling and loading states
4. Implement server-side receipt verification (recommended for production)

### Step 2: Define Product IDs

Use this product ID for both platforms:
- **Product ID:** `com.lumen.app.premium.monthly`
- **Price:** $9.99/month
- **Type:** Auto-renewable subscription

### Step 3: Update Android Manifest

Add billing permission to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

### Step 4: Update iOS Capabilities

In Xcode (`ios/Runner.xcworkspace`):
1. Select Runner target
2. Go to "Signing & Capabilities"
3. Click "+ Capability"
4. Add "In-App Purchase"

## Part 2: Configure Android Release Build

### Step 1: Generate Upload Keystore

```bash
keytool -genkey -v -keystore ~/lumen-upload-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias lumen-key
```

**Important:** Save the keystore file and passwords securely!

### Step 2: Create key.properties

Create `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=lumen-key
storeFile=/Users/YOUR_USERNAME/lumen-upload-key.keystore
```

**Important:** Add `android/key.properties` to `.gitignore`!

### Step 3: Update build.gradle

Update `android/app/build.gradle` to use the signing configuration:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 4: Build Android Release

```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://slvwtiicaxkpvupbmbki.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY_HERE
```

The AAB file will be at: `build/app/outputs/bundle/release/app-release.aab`

## Part 3: Google Play Console Setup

### Step 1: Create App

1. Go to https://play.google.com/console
2. Sign in with: `jevabarota@gmail.com`
3. Click "Create app"
4. Fill in:
   - **App name:** Lumen: Your Personalized Growth Compass
   - **Default language:** English (United States)
   - **App or game:** App
   - **Free or paid:** Free
   - **Category:** Health & Fitness

### Step 2: Set Up App Content

Complete all required sections:

**App access:**
- All functionality is available without restrictions

**Ads:**
- No, my app does not contain ads

**Content rating:**
- Complete the questionnaire (select "Lifestyle" category)

**Target audience:**
- Age group: 18+

**Data safety:**
- Collects: Email, Name, User-generated content
- Shares: None
- Security: Data is encrypted in transit and at rest

**Privacy policy:**
- URL: `https://growwithlumen.com/privacy-policy`

### Step 3: Set Up Store Listing

**App details:**
- **Short description:** Discover your path to personal growth with AI-powered insights, numerology wisdom, and tarot guidance.
- **Full description:** 
```
Lumen is your personalized growth compass, combining ancient wisdom with modern AI technology to create a unique personal development experience.

KEY FEATURES:
• Smart Dashboard - Track your growth journey with personalized daily focus activities
• Numerology Engine - Discover your life path through advanced numerology calculations
• Tarot & Angel Cards - Daily card draws with AI-generated reflective prompts
• AI Reflection Journal - Save thoughts and receive personalized affirmations
• Relationship Insights - Calculate compatibility and get AI-powered advice
• 369 Manifestation Method - Harness Tesla's powerful manifestation technique
• Smart Affirmation Reminders - Personalized push notifications throughout your day

Whether you're seeking clarity through numerology, guidance through tarot, or insights through journaling, Lumen adapts to your unique path.

PREMIUM FEATURES:
• Unlimited tarot & angel card draws
• Advanced numerology forecasts
• Unlimited AI journal entries
• 369 manifestation method with daily reminders
• Personalized affirmation notifications
• Relationship compatibility calculator
• Priority support

Start your personal growth journey today with Lumen!
```

**Graphics:**
- **App icon:** 512x512 PNG (prepare from assets/icons/)
- **Feature graphic:** 1024x500 PNG (create promotional banner)
- **Screenshots:** Minimum 2, maximum 8 phone screenshots
  - Take screenshots from the app running on a device
  - Recommended sizes: 1080x1920 or 1440x2560

### Step 4: Set Up In-App Products

1. Go to "Monetize" > "Products" > "Subscriptions"
2. Click "Create subscription"
3. Fill in:
   - **Product ID:** `com.lumen.app.premium.monthly`
   - **Name:** Lumen Premium Monthly
   - **Description:** Unlock unlimited access to all Lumen features
4. Create Base Plan:
   - **Billing period:** 1 month
   - **Price:** $9.99 USD
5. Add prices for other countries
6. Save and activate

### Step 5: Upload App Bundle

1. Go to "Release" > "Production"
2. Click "Create new release"
3. Upload the AAB file from Step 4 of Part 2
4. Fill in release notes:
```
Initial release of Lumen - Your Personalized Growth Compass

Features:
- Personalized numerology insights
- Daily tarot and angel card readings
- AI-powered reflection journal
- 369 manifestation method
- Relationship compatibility tools
- Smart affirmation reminders
```
5. Review and roll out to production

## Part 4: iOS App Store Setup

### Step 1: Configure Xcode Project

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Update **General** tab:
   - **Display Name:** Lumen
   - **Bundle Identifier:** com.growwithlumen.app
   - **Version:** 1.0.0
   - **Build:** 1

4. Update **Signing & Capabilities:**
   - Select your development team
   - Enable "Automatically manage signing"
   - Add capability: "In-App Purchase"

### Step 2: Build iOS Release

```bash
flutter build ios --release \
  --dart-define=SUPABASE_URL=https://slvwtiicaxkpvupbmbki.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY_HERE
```

### Step 3: Archive and Upload

1. In Xcode, select "Product" > "Archive"
2. When archive completes, click "Distribute App"
3. Select "App Store Connect"
4. Select "Upload"
5. Follow the wizard to upload

### Step 4: App Store Connect Setup

1. Go to https://appstoreconnect.apple.com
2. Sign in with: `jevabarota@gmail.com`
3. Click "My Apps" > "+" > "New App"
4. Fill in:
   - **Platform:** iOS
   - **Name:** Lumen: Your Personalized Growth Compass
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** com.growwithlumen.app
   - **SKU:** lumen-app-ios
   - **User Access:** Full Access

### Step 5: Set Up App Information

**Category:**
- Primary: Health & Fitness
- Secondary: Lifestyle

**Privacy Policy URL:**
- `https://growwithlumen.com/privacy-policy`

**Support URL:**
- `https://growwithlumen.com/support`

**Marketing URL:**
- `https://growwithlumen.com`

### Step 6: Set Up In-App Purchases

1. Go to "Features" > "In-App Purchases"
2. Click "+" to create new
3. Select "Auto-Renewable Subscription"
4. Fill in:
   - **Reference Name:** Lumen Premium Monthly
   - **Product ID:** `com.lumen.app.premium.monthly`
5. Create Subscription Group:
   - **Group Name:** Lumen Premium
6. Add Subscription Duration:
   - **Duration:** 1 month
   - **Price:** $9.99 USD (Tier 10)
7. Add Localization:
   - **Display Name:** Lumen Premium
   - **Description:** Unlock unlimited access to all Lumen features including unlimited tarot readings, advanced numerology, AI journal, and more.
8. Submit for review

### Step 7: Prepare Screenshots

Required screenshot sizes:
- **6.7" Display (iPhone 14 Pro Max):** 1290 x 2796
- **6.5" Display (iPhone 11 Pro Max):** 1242 x 2688
- **5.5" Display (iPhone 8 Plus):** 1242 x 2208

Take screenshots showing:
1. Dashboard with daily focus
2. Numerology insights
3. Tarot card reading
4. Journal entry with AI insights
5. 369 Manifestation method

### Step 8: App Review Information

**Contact Information:**
- **First Name:** Eva
- **Last Name:** Barota
- **Email:** jevabarota@gmail.com

**Demo Account (if needed):**
- Create a test account with premium access
- Provide credentials in the notes

**Notes:**
```
Lumen is a personal growth app that combines numerology, tarot, and AI-powered journaling.

Premium subscription unlocks:
- Unlimited tarot readings
- Advanced numerology forecasts
- Unlimited AI journal entries
- 369 manifestation method
- Personalized affirmations

The app uses Supabase for backend and implements native in-app purchases for subscriptions.
```

### Step 9: Submit for Review

1. Select the build you uploaded
2. Fill in "What's New in This Version":
```
Welcome to Lumen - Your Personalized Growth Compass!

Discover your path to personal growth with:
• Personalized numerology insights
• Daily tarot and angel card readings
• AI-powered reflection journal
• 369 manifestation method
• Relationship compatibility tools
• Smart affirmation reminders

Start your journey today!
```
3. Click "Submit for Review"

## Part 5: Testing Before Submission

### Android Testing

1. **Internal Testing:**
   - Upload AAB to Internal Testing track
   - Add your email as a tester
   - Install and test all features
   - Verify IAP purchases work

2. **Closed Testing:**
   - Promote to Closed Testing
   - Add beta testers
   - Collect feedback

### iOS Testing

1. **TestFlight:**
   - Upload build via Xcode
   - Add internal testers
   - Test all features including IAP
   - Verify on multiple devices

2. **External Testing:**
   - Submit for Beta App Review
   - Add external testers
   - Collect feedback

## Part 6: Post-Submission Checklist

### Monitor Review Status

- **Google Play:** Usually 1-3 days
- **App Store:** Usually 1-2 days (can be longer)

### Respond to Review Feedback

If rejected:
1. Read rejection reason carefully
2. Fix the issues
3. Increment version number
4. Resubmit

### Common Rejection Reasons

**Apple:**
- Missing privacy policy
- IAP not working correctly
- Misleading app description
- Crashes or bugs

**Google:**
- Missing content rating
- Incomplete data safety section
- Policy violations
- Technical issues

## Part 7: After Approval

### Marketing & Launch

1. **Announce on Social Media**
   - Share App Store and Play Store links
   - Create launch posts

2. **Update Website**
   - Add download buttons to https://growwithlumen.com
   - Link to both stores

3. **Monitor Analytics**
   - Track downloads and user engagement
   - Monitor crash reports
   - Review user feedback

### Ongoing Maintenance

1. **Regular Updates**
   - Bug fixes
   - New features
   - Performance improvements

2. **User Support**
   - Respond to reviews
   - Handle support emails
   - Update FAQ

3. **Subscription Management**
   - Monitor subscription metrics
   - Handle refund requests
   - Update pricing if needed

## Important Security Notes

1. **Never commit sensitive data:**
   - Add `android/key.properties` to `.gitignore`
   - Never commit keystores or certificates
   - Use environment variables for API keys

2. **Secure your accounts:**
   - Enable 2FA on Apple Developer and Google Play Console
   - Use strong passwords
   - Limit access to team members

3. **Protect your keys:**
   - Store keystores and certificates securely
   - Back up to encrypted storage
   - Never share publicly

## Support Resources

- **Flutter Documentation:** https://flutter.dev/docs
- **App Store Guidelines:** https://developer.apple.com/app-store/guidelines/
- **Google Play Policies:** https://play.google.com/about/developer-content-policy/
- **In-App Purchase Guide:** https://pub.dev/packages/in_app_purchase

## Need Help?

If you encounter issues:
1. Check the Flutter and platform documentation
2. Search for similar issues on Stack Overflow
3. Review Apple/Google developer forums
4. Consider hiring a Flutter developer for complex issues

---

**Good luck with your app launch! 🚀**
