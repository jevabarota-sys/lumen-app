# Lumen App Deployment Guide

This comprehensive guide covers deploying the Lumen mobile app to production with Supabase backend and Stripe payments.

## Prerequisites

- ✅ Supabase project configured (see `SUPABASE_SETUP.md`)
- ✅ Stripe account configured (see `STRIPE_SETUP.md`)
- ✅ Apple Developer Account (for iOS App Store)
- ✅ Google Play Console Account (for Android Play Store)
- ✅ GitHub repository with CI/CD pipeline

## Environment Configuration

### 1. GitHub Actions Secrets

Configure these secrets in your GitHub repository:

**Settings** → **Secrets and variables** → **Actions** → **Repository secrets**

```bash
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Stripe Configuration  
STRIPE_PUBLISHABLE_KEY=pk_live_your_live_publishable_key
STRIPE_PRICE_ID=price_your_live_price_id

# iOS Deployment (if using GitHub Actions for iOS)
IOS_CERTIFICATE_BASE64=your-base64-encoded-certificate
IOS_PROVISIONING_PROFILE_BASE64=your-base64-encoded-profile
IOS_CERTIFICATE_PASSWORD=your-certificate-password

# Android Deployment (if using GitHub Actions for Android)
ANDROID_KEYSTORE_BASE64=your-base64-encoded-keystore
ANDROID_KEYSTORE_PASSWORD=your-keystore-password
ANDROID_KEY_ALIAS=your-key-alias
ANDROID_KEY_PASSWORD=your-key-password
```

### 2. Local Development Environment

Create `.env` file in project root:

```bash
# Development Environment Variables
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
STRIPE_PUBLISHABLE_KEY=pk_test_your_test_publishable_key
STRIPE_PRICE_ID=price_your_test_price_id
```

## iOS Deployment

### 1. Xcode Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Update **Bundle Identifier**: `com.lumen.app.lumen`
3. Configure **Signing & Capabilities**:
   - Select your development team
   - Enable automatic signing or configure manual signing
   - Add capabilities: In-App Purchase, Push Notifications

### 2. App Store Connect Setup

1. Create new app in App Store Connect
2. Configure app information:
   - **Name**: Lumen: Your Personalized Growth Compass
   - **Bundle ID**: com.lumen.app.lumen
   - **SKU**: lumen-app-ios
   - **Category**: Health & Fitness / Lifestyle

3. Set up In-App Purchases:
   - Create subscription product matching your Stripe price
   - Configure subscription groups
   - Add localized descriptions

### 3. Build and Upload

```bash
# Build for release
flutter build ios --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY --dart-define=STRIPE_PRICE_ID=$STRIPE_PRICE_ID

# Archive and upload via Xcode or use fastlane
```

## Android Deployment

### 1. Generate Signing Key

```bash
keytool -genkey -v -keystore ~/lumen-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias lumen-key
```

### 2. Configure Signing

Create `android/key.properties`:

```properties
storePassword=your-keystore-password
keyPassword=your-key-password  
keyAlias=lumen-key
storeFile=../lumen-release-key.keystore
```

Update `android/app/build.gradle`:

```gradle
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

### 3. Google Play Console Setup

1. Create new app in Google Play Console
2. Configure app information:
   - **App name**: Lumen: Your Personalized Growth Compass
   - **Package name**: com.lumen.app.lumen
   - **Category**: Health & Fitness

3. Set up In-App Products:
   - Create subscription product matching your Stripe price
   - Configure billing periods and pricing

### 4. Build and Upload

```bash
# Build release APK
flutter build apk --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY --dart-define=STRIPE_PRICE_ID=$STRIPE_PRICE_ID

# Or build App Bundle (recommended)
flutter build appbundle --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY --dart-define=STRIPE_PRICE_ID=$STRIPE_PRICE_ID
```

## CI/CD Pipeline Enhancement

### Update GitHub Actions Workflow

Enhance `.github/workflows/ci.yml` to include deployment:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze --no-fatal-infos

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - run: flutter pub get
      - name: Build Android APK
        run: |
          flutter build apk --release \
            --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
            --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }} \
            --dart-define=STRIPE_PUBLISHABLE_KEY=${{ secrets.STRIPE_PUBLISHABLE_KEY }} \
            --dart-define=STRIPE_PRICE_ID=${{ secrets.STRIPE_PRICE_ID }}
      - name: Upload Android Artifact
        uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - run: flutter pub get
      - name: Build iOS
        run: |
          flutter build ios --release --no-codesign \
            --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
            --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }} \
            --dart-define=STRIPE_PUBLISHABLE_KEY=${{ secrets.STRIPE_PUBLISHABLE_KEY }} \
            --dart-define=STRIPE_PRICE_ID=${{ secrets.STRIPE_PRICE_ID }}

  deploy-android:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    needs: build-android
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Download Android Artifact
        uses: actions/download-artifact@v4
        with:
          name: android-apk
      - name: Deploy to Google Play
        # Add your Google Play deployment action here
        run: echo "Deploy to Google Play Console"
```

## Production Checklist

### Pre-Launch
- ✅ Supabase production database configured
- ✅ Stripe live mode enabled with real payment processing
- ✅ App store listings created (iOS App Store, Google Play)
- ✅ Privacy policy and terms of service published
- ✅ App icons and screenshots prepared
- ✅ In-app purchase products configured
- ✅ Push notification certificates configured
- ✅ Analytics and crash reporting set up

### Security
- ✅ All API keys are environment variables (never hardcoded)
- ✅ Supabase Row Level Security (RLS) enabled
- ✅ Stripe webhook endpoints secured
- ✅ App signing certificates secured
- ✅ ProGuard rules configured for Android release builds

### Testing
- ✅ End-to-end testing on physical devices
- ✅ Payment flow testing with real cards (small amounts)
- ✅ Subscription management testing
- ✅ Offline functionality testing
- ✅ Performance testing under load

### Monitoring
- ✅ Error tracking (Sentry, Crashlytics)
- ✅ Analytics (Firebase Analytics, Mixpanel)
- ✅ Performance monitoring
- ✅ Payment failure alerts
- ✅ User feedback collection

## Post-Launch

### App Store Optimization (ASO)
1. **Keywords**: numerology, tarot, personal growth, mindfulness, journal
2. **Screenshots**: Show key features and beautiful UI
3. **App Preview Videos**: Demonstrate core user flows
4. **Ratings & Reviews**: Encourage satisfied users to leave reviews

### Marketing & Growth
1. **Content Marketing**: Blog posts about numerology and personal growth
2. **Social Media**: Instagram, TikTok with spiritual/wellness content
3. **Influencer Partnerships**: Collaborate with spiritual/wellness influencers
4. **Email Marketing**: Newsletter with daily insights and tips

### Maintenance & Updates
1. **Regular Updates**: New features, bug fixes, content updates
2. **User Feedback**: Monitor reviews and implement requested features
3. **Performance Monitoring**: Track app performance and user engagement
4. **Security Updates**: Keep dependencies updated and secure

## Troubleshooting

### Common Deployment Issues

1. **Build Failures**
   - Check environment variables are set correctly
   - Verify all dependencies are compatible
   - Ensure ProGuard rules are configured for Android

2. **App Store Rejections**
   - Review App Store guidelines
   - Ensure privacy policy is accessible
   - Test in-app purchases thoroughly

3. **Payment Issues**
   - Verify Stripe webhook endpoints
   - Test subscription flows end-to-end
   - Monitor payment failure rates

4. **Performance Issues**
   - Profile app performance on target devices
   - Optimize images and animations
   - Monitor memory usage and crashes

## Support & Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Supabase Documentation**: https://supabase.com/docs
- **Stripe Documentation**: https://stripe.com/docs
- **App Store Guidelines**: https://developer.apple.com/app-store/guidelines/
- **Google Play Policies**: https://play.google.com/about/developer-content-policy/

---

**Ready for Launch!** 🚀

Your Lumen app is now ready for production deployment with a robust backend, secure payments, and comprehensive CI/CD pipeline.
