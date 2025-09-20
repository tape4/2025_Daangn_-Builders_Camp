import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FaqPage extends ConsumerWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('FAQ', style: ShadTheme.of(context).textTheme.h3),
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: ShadTheme.of(context).textTheme.h4,
            ),
            const SizedBox(height: 8),
            Text(
              'Find answers to common questions about our application',
              style: ShadTheme.of(context).textTheme.muted,
            ),
            const SizedBox(height: 24),
            _buildFaqSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final faqCategories = [
      FaqCategory(
        title: 'Getting Started',
        icon: Symbols.rocket_launch,
        questions: [
          FaqItem(
            question: 'How do I create an account?',
            answer:
                'To create an account, tap on the "Sign Up" button on the welcome screen. Enter your email address, create a secure password, and follow the verification steps. You\'ll receive a confirmation email to verify your account.',
          ),
          FaqItem(
            question: 'What are the system requirements?',
            answer:
                'Our application runs on iOS 12.0+ and Android 5.0+. You need an active internet connection for most features. We recommend at least 100MB of free storage space for optimal performance.',
          ),
          FaqItem(
            question: 'Is the app free to use?',
            answer:
                'Yes, the basic version is completely free. We also offer premium features through optional in-app purchases that enhance your experience with additional functionality.',
          ),
        ],
      ),
      FaqCategory(
        title: 'Account & Security',
        icon: Symbols.security,
        questions: [
          FaqItem(
            question: 'How do I reset my password?',
            answer:
                'Go to the login screen and tap "Forgot Password". Enter your registered email address, and we\'ll send you a password reset link. Follow the instructions in the email to create a new password.',
          ),
          FaqItem(
            question: 'Is my data secure?',
            answer:
                'Yes, we use industry-standard encryption to protect your data. All communications are secured with SSL/TLS, and sensitive information is encrypted at rest. We never share your personal data with third parties without your consent.',
          ),
          FaqItem(
            question: 'Can I delete my account?',
            answer:
                'Yes, you can delete your account at any time from Settings > Account > Delete Account. Please note that this action is irreversible and will permanently delete all your data.',
          ),
        ],
      ),
      FaqCategory(
        title: 'Features & Usage',
        icon: Symbols.widgets,
        questions: [
          FaqItem(
            question: 'How do I customize my profile?',
            answer:
                'Navigate to My Page and tap the edit icon next to your profile. You can update your name, profile picture, bio, and other preferences. Changes are saved automatically.',
          ),
          FaqItem(
            question: 'Can I use the app offline?',
            answer:
                'Some features are available offline, including viewing cached content and accessing downloaded data. However, features requiring server synchronization need an internet connection.',
          ),
          FaqItem(
            question: 'How do notifications work?',
            answer:
                'You can manage notifications in Settings > Notifications. Choose which types of alerts you want to receive and set quiet hours. Push notifications require permission from your device settings.',
          ),
        ],
      ),
      FaqCategory(
        title: 'Troubleshooting',
        icon: Symbols.build,
        questions: [
          FaqItem(
            question: 'The app is running slowly. What can I do?',
            answer:
                'Try these steps: 1) Clear the app cache in Settings, 2) Ensure you have the latest version, 3) Restart your device, 4) Check your internet connection, 5) Free up device storage if needed.',
          ),
          FaqItem(
            question: 'I\'m not receiving notifications',
            answer:
                'Check that notifications are enabled in both the app settings and your device settings. Also verify that Do Not Disturb mode is off and that the app has the necessary permissions.',
          ),
          FaqItem(
            question: 'How do I report a bug?',
            answer:
                'Go to Settings > Help & Support > Report a Bug. Describe the issue in detail, including steps to reproduce it. Screenshots are helpful. Our team will investigate and respond within 48 hours.',
          ),
        ],
      ),
    ];

    return Column(
      children: faqCategories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildCategorySection(context, category),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(BuildContext context, FaqCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              category.icon,
              size: 20,
              color: ShadTheme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              category.title,
              style: ShadTheme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ShadAccordion<String>(
          children: category.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return ShadAccordionItem(
              value: '${category.title}_$index',
              title: Text(
                item.question,
                style: ShadTheme.of(context).textTheme.p,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  item.answer,
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        color:
                            ShadTheme.of(context).colorScheme.mutedForeground,
                        height: 1.5,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FaqCategory {
  final String title;
  final IconData icon;
  final List<FaqItem> questions;

  FaqCategory({
    required this.title,
    required this.icon,
    required this.questions,
  });
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    required this.question,
    required this.answer,
  });
}
