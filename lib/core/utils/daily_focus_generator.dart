import 'dart:math';

/// AI-powered daily focus generator that creates personalized suggestions
/// based on user patterns, day of week, and growth areas
class DailyFocusGenerator {
  /// Generate a personalized daily focus based on context
  static Map<String, String> generateDailyFocus({
    int? lifePathNumber,
    List<String>? recentJournalTopics,
    String? currentMood,
    DateTime? date,
  }) {
    final now = date ?? DateTime.now();
    final dayOfWeek = now.weekday;
    final dayOfMonth = now.day;
    
    // Analyze user context
    final context = _analyzeUserContext(
      lifePathNumber: lifePathNumber,
      recentJournalTopics: recentJournalTopics,
      currentMood: currentMood,
      dayOfWeek: dayOfWeek,
    );
    
    // Generate focus based on context
    return _generateContextualFocus(context, dayOfWeek, dayOfMonth);
  }
  
  static Map<String, dynamic> _analyzeUserContext({
    int? lifePathNumber,
    List<String>? recentJournalTopics,
    String? currentMood,
    int? dayOfWeek,
  }) {
    final context = <String, dynamic>{
      'needsGrounding': false,
      'needsCreativity': false,
      'needsConnection': false,
      'needsReflection': false,
      'needsAction': false,
      'primaryNeed': 'balance',
    };
    
    // Analyze mood
    if (currentMood != null) {
      final mood = currentMood.toLowerCase();
      if (mood.contains('anxious') || mood.contains('stressed') || mood.contains('overwhelmed')) {
        context['needsGrounding'] = true;
        context['primaryNeed'] = 'grounding';
      } else if (mood.contains('stuck') || mood.contains('bored') || mood.contains('uninspired')) {
        context['needsCreativity'] = true;
        context['primaryNeed'] = 'creativity';
      } else if (mood.contains('lonely') || mood.contains('isolated')) {
        context['needsConnection'] = true;
        context['primaryNeed'] = 'connection';
      }
    }
    
    // Analyze journal topics
    if (recentJournalTopics != null && recentJournalTopics.isNotEmpty) {
      final topics = recentJournalTopics.join(' ').toLowerCase();
      if (topics.contains('work') || topics.contains('career') || topics.contains('job')) {
        context['needsAction'] = true;
      }
      if (topics.contains('relationship') || topics.contains('family') || topics.contains('friend')) {
        context['needsConnection'] = true;
      }
      if (topics.contains('meaning') || topics.contains('purpose') || topics.contains('why')) {
        context['needsReflection'] = true;
      }
    }
    
    // Day of week patterns
    if (dayOfWeek != null) {
      if (dayOfWeek == DateTime.monday) {
        context['needsAction'] = true; // Monday motivation
      } else if (dayOfWeek == DateTime.wednesday) {
        context['needsReflection'] = true; // Mid-week reflection
      } else if (dayOfWeek == DateTime.friday) {
        context['needsConnection'] = true; // End of week connection
      } else if (dayOfWeek == DateTime.sunday) {
        context['needsGrounding'] = true; // Sunday self-care
      }
    }
    
    // Life path number influence
    if (lifePathNumber != null) {
      switch (lifePathNumber) {
        case 1:
          context['lifePathFocus'] = 'leadership and independence';
          break;
        case 2:
          context['lifePathFocus'] = 'harmony and cooperation';
          break;
        case 3:
          context['lifePathFocus'] = 'creativity and self-expression';
          break;
        case 4:
          context['lifePathFocus'] = 'stability and building foundations';
          break;
        case 5:
          context['lifePathFocus'] = 'freedom and adventure';
          break;
        case 6:
          context['lifePathFocus'] = 'nurturing and responsibility';
          break;
        case 7:
          context['lifePathFocus'] = 'inner wisdom and spiritual growth';
          break;
        case 8:
          context['lifePathFocus'] = 'abundance and personal power';
          break;
        case 9:
          context['lifePathFocus'] = 'compassion and completion';
          break;
      }
    }
    
    return context;
  }
  
  static Map<String, String> _generateContextualFocus(
    Map<String, dynamic> context,
    int dayOfWeek,
    int dayOfMonth,
  ) {
    final primaryNeed = context['primaryNeed'] as String;
    final lifePathFocus = context['lifePathFocus'] as String?;
    
    // Select focus based on primary need
    Map<String, String> focus;
    
    switch (primaryNeed) {
      case 'grounding':
        focus = _getGroundingFocus();
        break;
      case 'creativity':
        focus = _getCreativityFocus();
        break;
      case 'connection':
        focus = _getConnectionFocus();
        break;
      case 'reflection':
        focus = _getReflectionFocus();
        break;
      case 'action':
        focus = _getActionFocus();
        break;
      default:
        focus = _getBalanceFocus(dayOfMonth);
    }
    
    // Add life path personalization if available
    if (lifePathFocus != null) {
      focus['description'] = '${focus['description']}\n\nThis practice aligns with your life path\'s focus on $lifePathFocus.';
    }
    
    return focus;
  }
  
  static Map<String, String> _getGroundingFocus() {
    final focuses = [
      {
        'title': 'Mindful Breathing Practice',
        'description': 'Take 10 minutes today to focus on your breath. Inhale for 4 counts, hold for 4, exhale for 4. This practice will help center your energy and calm your nervous system.',
        'action': 'Practice mindful breathing',
      },
      {
        'title': 'Nature Connection',
        'description': 'Spend 15 minutes in nature today, even if it\'s just sitting by a window or tending to a plant. Ground yourself by feeling the earth beneath your feet.',
        'action': 'Connect with nature',
      },
      {
        'title': 'Body Scan Meditation',
        'description': 'Take 10 minutes to scan your body from head to toe, releasing tension in each area. This practice brings you back into your body and the present moment.',
        'action': 'Complete body scan',
      },
    ];
    return focuses[Random().nextInt(focuses.length)];
  }
  
  static Map<String, String> _getCreativityFocus() {
    final focuses = [
      {
        'title': 'Creative Expression Time',
        'description': 'Dedicate 20 minutes to any creative activity without judgment - draw, write, dance, or create something with your hands. The goal is joy, not perfection.',
        'action': 'Create something',
      },
      {
        'title': 'Explore New Perspectives',
        'description': 'Take a different route today, try a new food, or approach a familiar task in a new way. Small changes spark creativity and fresh thinking.',
        'action': 'Try something new',
      },
      {
        'title': 'Inspiration Gathering',
        'description': 'Collect 3-5 things that inspire you today - quotes, images, sounds, or ideas. Create a mini inspiration board to fuel your creative energy.',
        'action': 'Gather inspiration',
      },
    ];
    return focuses[Random().nextInt(focuses.length)];
  }
  
  static Map<String, String> _getConnectionFocus() {
    final focuses = [
      {
        'title': 'Meaningful Conversation',
        'description': 'Have a genuine conversation with someone today. Ask open-ended questions and truly listen to their answers. Connection deepens through authentic presence.',
        'action': 'Connect deeply with someone',
      },
      {
        'title': 'Express Gratitude',
        'description': 'Tell three people specifically what you appreciate about them. Authentic gratitude strengthens bonds and spreads positive energy.',
        'action': 'Express gratitude to 3 people',
      },
      {
        'title': 'Self-Connection Practice',
        'description': 'Spend 15 minutes checking in with yourself. Ask: "How am I really feeling?" and "What do I need right now?" Connection starts within.',
        'action': 'Check in with yourself',
      },
    ];
    return focuses[Random().nextInt(focuses.length)];
  }
  
  static Map<String, String> _getReflectionFocus() {
    final focuses = [
      {
        'title': 'Values Reflection',
        'description': 'Identify your top 3 values and reflect on how your recent actions align with them. This practice brings clarity and intentional living.',
        'action': 'Reflect on your values',
      },
      {
        'title': 'Gratitude Journaling',
        'description': 'Write about 3 things you\'re grateful for today and why they matter. Gratitude shifts perspective and reveals abundance.',
        'action': 'Journal about gratitude',
      },
      {
        'title': 'Life Lessons Review',
        'description': 'Reflect on a recent challenge and ask: "What is this teaching me?" Every experience offers wisdom when we\'re willing to see it.',
        'action': 'Find the lesson',
      },
    ];
    return focuses[Random().nextInt(focuses.length)];
  }
  
  static Map<String, String> _getActionFocus() {
    final focuses = [
      {
        'title': 'Take One Bold Step',
        'description': 'Identify one action that would move you toward a goal and take it today. Small, consistent actions create momentum and transformation.',
        'action': 'Take action on a goal',
      },
      {
        'title': 'Complete Unfinished Business',
        'description': 'Choose one task you\'ve been avoiding and complete it today. Finishing what you start frees mental energy and builds confidence.',
        'action': 'Complete a pending task',
      },
      {
        'title': 'Set Clear Intentions',
        'description': 'Write down 3 specific intentions for this week. Clarity of intention directs your energy and attracts aligned opportunities.',
        'action': 'Set weekly intentions',
      },
    ];
    return focuses[Random().nextInt(focuses.length)];
  }
  
  static Map<String, String> _getBalanceFocus(int dayOfMonth) {
    final focuses = [
      {
        'title': 'Holistic Wellness Check',
        'description': 'Rate your satisfaction in 4 areas: physical health, emotional well-being, relationships, and purpose. Focus on the area that needs attention today.',
        'action': 'Assess your wellness',
      },
      {
        'title': 'Energy Management',
        'description': 'Notice what gives you energy and what drains it today. Make one choice to protect your energy and one to replenish it.',
        'action': 'Manage your energy',
      },
      {
        'title': 'Present Moment Practice',
        'description': 'Set 3 reminders throughout the day to pause and fully experience the present moment. Balance comes from being here, now.',
        'action': 'Practice presence',
      },
    ];
    return focuses[dayOfMonth % focuses.length];
  }
  
  /// Generate a quick daily tip based on the day
  static String generateDailyTip(DateTime date) {
    final tips = [
      'Start your day with intention, not obligation.',
      'Your thoughts create your reality. Choose them wisely.',
      'Small acts of kindness create ripples of positive change.',
      'Progress, not perfection, is the goal.',
      'Listen to your intuition - it knows the way.',
      'Gratitude transforms what we have into enough.',
      'You are exactly where you need to be right now.',
      'Challenges are opportunities in disguise.',
      'Self-care is not selfish, it\'s essential.',
      'Your energy is precious. Protect it.',
      'Comparison is the thief of joy. Focus on your own journey.',
      'Forgiveness frees you more than the other person.',
      'Trust the timing of your life.',
      'You are stronger than you think.',
      'Every ending is a new beginning.',
    ];
    
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  }
}
