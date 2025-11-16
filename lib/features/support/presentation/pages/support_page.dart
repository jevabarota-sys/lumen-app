import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Support Center'),
        backgroundColor: AppTheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 16),
            _buildContactCard(context),
            const SizedBox(height: 24),
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              context,
              'How do I get started with Lumen?',
              'Download the app from the App Store or Google Play, create your account with your email, and complete the onboarding process. You\'ll be asked for your birth date to generate your personalized numerology profile.',
            ),
            _buildFAQItem(
              context,
              'What\'s included in the free version?',
              'The free version includes basic numerology calculations, one daily tarot card draw, limited journal entries, and access to community features. You can upgrade to Premium for unlimited access to all features.',
            ),
            _buildFAQItem(
              context,
              'How much does Premium cost?',
              'Premium subscription costs \$9.99 per month and includes unlimited tarot draws, advanced AI insights, detailed numerology forecasts, unlimited journal entries, and priority support.',
            ),
            _buildFAQItem(
              context,
              'Can I cancel my subscription anytime?',
              'Yes, you can cancel your Premium subscription at any time through your app store account settings (iOS Settings > Apple ID > Subscriptions, or Google Play Store > Subscriptions). Your access continues until the end of your billing period.',
            ),
            _buildFAQItem(
              context,
              'How accurate are the numerology and tarot readings?',
              'Our content is designed for entertainment and self-reflection purposes. While we use traditional numerology and tarot principles, readings should not be considered as professional advice or predictions of future events.',
            ),
            _buildFAQItem(
              context,
              'Is my personal data secure?',
              'Yes, we take data security seriously. All personal information is encrypted and stored securely. We never share your personal data with third parties without your consent. Read our Privacy Policy for full details.',
            ),
            _buildFAQItem(
              context,
              'Can I export my journal entries?',
              'Yes, Premium users can export their journal entries in PDF format. Go to Settings > Data Export in the app to download your personal growth history.',
            ),
            _buildFAQItem(
              context,
              'How do I delete my account?',
              'To delete your account, go to Settings > Account > Delete Account in the app, or email us at support@growwithlumen.com. This will permanently remove all your data from our servers.',
            ),
            _buildFAQItem(
              context,
              'The app is crashing or not working properly',
              'Try these steps: 1) Force close and restart the app, 2) Check for app updates in your app store, 3) Restart your device, 4) Ensure you have a stable internet connection. If issues persist, contact support with your device model and iOS/Android version.',
            ),
            _buildFAQItem(
              context,
              'How do I restore my Premium subscription on a new device?',
              'Log in with the same email address you used for your original purchase. Your Premium subscription will automatically restore. If you have issues, contact support with your purchase receipt.',
            ),
            const SizedBox(height: 24),
            _buildTipsSection(context),
            const SizedBox(height: 24),
            _buildTechnicalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Welcome to Support',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'We\'re here to help you on your personal growth journey. Find answers to common questions below or contact our support team directly.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutral,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Immediate Help?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, color: AppTheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _launchEmail(),
                    child: Text(
                      'support@growwithlumen.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'We typically respond within 24 hours',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.neutral,
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Getting the Most from Lumen',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildTipItem(context, 'Morning Routine',
                'Check your daily focus and draw a tarot card to set intentions'),
            _buildTipItem(context, 'Evening Reflection',
                'Use the journal to reflect on your day and insights gained'),
            _buildTipItem(context, 'Weekly Review',
                'Review your numerology forecast and journal themes'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutral,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technical Support',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'System Requirements',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            _buildTechItem(context, 'iOS: iPhone/iPad running iOS 12.0 or later'),
            _buildTechItem(context, 'Android: Android 6.0 (API level 23) or later'),
            _buildTechItem(context, 'Storage: 100MB free space'),
            _buildTechItem(context, 'Internet: Required for AI features and syncing'),
          ],
        ),
      ),
    );
  }

  Widget _buildTechItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: AppTheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@growwithlumen.com',
      query: 'subject=Lumen Support Request',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
