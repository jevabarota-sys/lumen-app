# Lumen: Your Personalized Growth Compass

A cross-platform mobile app built with Flutter that provides personalized spiritual guidance through numerology, tarot readings, AI-powered journaling, and community connection.

## Features

### 🏠 Dashboard
- Today's Focus with AI-generated daily activities
- Growth Paths showing module progress
- AI Reflection Journal preview
- Premium subscription management
- Quick actions for all features

### 🔢 Numerology Engine
- Life Path number calculation from date of birth
- Name number analysis using Pythagorean system
- Daily, monthly, and yearly forecasts
- Personalized insights based on numerological profiles

### 🔮 Tarot & Angel Cards
- Daily one-card draws or three-card spreads (Past/Present/Future)
- Deterministic card selection per user per day
- AI-generated reflective prompts and interpretations
- Complete Major Arcana deck with detailed meanings

### 📝 AI Reflection Journal
- Save and organize journal entries with tags
- AI-powered theme analysis and insights
- Personalized affirmations generation
- Entry history and progress tracking

### 👥 Community Spotlights
- Moderated community feed for sharing insights
- AI content moderation for safety
- Like and interact with community posts
- Optional opt-in participation

### 💳 Premium Subscriptions
- Stripe integration for secure payments
- Apple Pay and Google Pay support
- Free tier with premium upgrade ($9.99/month)
- Enhanced features for premium users

## Tech Stack

- **Frontend**: Flutter 3.24.3
- **Backend**: Supabase (Database, Auth, API)
- **Payments**: Stripe with native mobile integration
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Animations**: Flutter Animate
- **Design**: Material Design 3 with custom theme

## Architecture

```
lib/
├── core/
│   ├── constants/     # App constants and routes
│   ├── navigation/    # Router configuration
│   ├── services/      # Supabase and external services
│   ├── theme/         # App theme and styling
│   └── utils/         # Numerology and tarot engines
├── features/
│   ├── auth/          # Authentication pages
│   ├── dashboard/     # Main dashboard
│   ├── numerology/    # Numerology calculations
│   ├── tarot/         # Tarot card readings
│   ├── journal/       # AI reflection journal
│   └── community/     # Community features
└── shared/
    ├── models/        # Data models
    └── widgets/       # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter 3.24.3 or later
- Dart SDK
- Android Studio / Xcode for mobile development
- Supabase account
- Stripe account

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd lumen
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
```bash
export SUPABASE_URL="your_supabase_url"
export SUPABASE_ANON_KEY="your_supabase_anon_key"
export STRIPE_PUBLISHABLE_KEY="your_stripe_publishable_key"
export STRIPE_PRICE_ID="your_stripe_price_id"
```

4. Set up Supabase database:
```bash
# Run the SQL schema in your Supabase dashboard
cat supabase_schema.sql
```

5. Run the app:
```bash
flutter run
```

## Database Schema

The app uses Supabase with the following main tables:

- `users` - User profiles and subscription status
- `journal_entries` - AI reflection journal entries
- `tarot_draws` - Daily tarot card draws
- `growth_paths` - User progress tracking
- `subscriptions` - Stripe subscription management
- `community_posts` - Community feed content
- `daily_activities` - AI-generated daily activities

See `supabase_schema.sql` for the complete schema with RLS policies.

## Design System

The app uses a calming, trustworthy color palette:

- **Primary**: Deep blue (#1E3A8A)
- **Secondary**: Teal (#0D9488)
- **Accent**: Soft green (#10B981)
- **Neutral**: Warm gray (#6B7280)
- **Background**: Light gray (#F9FAFB)
- **Surface**: White (#FFFFFF)

## CI/CD Pipeline

GitHub Actions workflow includes:

- **Testing**: Flutter analyze, unit tests, formatting checks
- **Android Build**: APK generation with release signing
- **iOS Build**: IPA generation for App Store distribution
- **Artifact Upload**: Downloadable builds for each platform

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact Eva Barota (@jevabarota-sys).

---

Built with ❤️ using Flutter and Supabase
