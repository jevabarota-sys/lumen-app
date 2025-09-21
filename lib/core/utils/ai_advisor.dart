class AIAdvisor {
  static String generateConflictAdvice(String conflictDescription) {
    final content = conflictDescription.toLowerCase();

    if (content.contains('communication') ||
        content.contains('talking') ||
        content.contains('listen')) {
      return 'Focus on active listening and expressing your feelings with "I" statements. Clear communication is the foundation of resolving conflicts. Take turns speaking and really hear what the other person is saying.';
    } else if (content.contains('trust') ||
        content.contains('betrayal') ||
        content.contains('lie')) {
      return 'Rebuilding trust takes time and consistent actions. Be patient with the process and focus on transparency and reliability. Small, consistent gestures matter more than grand promises.';
    } else if (content.contains('jealous') ||
        content.contains('envy') ||
        content.contains('insecure')) {
      return 'Jealousy often stems from insecurity. Work on building self-confidence and communicate your needs openly with your partner. Focus on your own growth and self-worth.';
    } else if (content.contains('money') ||
        content.contains('financial') ||
        content.contains('spending')) {
      return 'Financial disagreements require open discussion about values and goals. Create a budget together and establish clear agreements about spending and saving priorities.';
    } else if (content.contains('family') ||
        content.contains('in-laws') ||
        content.contains('parents')) {
      return 'Family conflicts require setting healthy boundaries while maintaining respect. Discuss your needs privately first, then present a united front when addressing family issues.';
    } else if (content.contains('time') ||
        content.contains('attention') ||
        content.contains('neglect')) {
      return 'Quality time is essential for relationships. Schedule regular one-on-one time and be fully present. Discuss how you both prefer to give and receive attention.';
    } else if (content.contains('chores') ||
        content.contains('housework') ||
        content.contains('cleaning')) {
      return 'Household responsibilities should be shared fairly. Create a clear division of tasks based on preferences and schedules. Appreciate each other\'s contributions.';
    } else if (content.contains('intimacy') ||
        content.contains('physical') ||
        content.contains('affection')) {
      return 'Physical and emotional intimacy require open communication about needs and boundaries. Create a safe space to discuss desires and concerns without judgment.';
    } else if (content.contains('future') ||
        content.contains('goals') ||
        content.contains('plans')) {
      return 'Align your future visions through honest conversation about individual and shared goals. Find compromises that honor both of your dreams and aspirations.';
    } else if (content.contains('angry') ||
        content.contains('fight') ||
        content.contains('argument')) {
      return 'When emotions run high, take a break to cool down before continuing the discussion. Focus on the issue, not personal attacks. Remember you\'re on the same team.';
    }

    return 'Take time to understand both perspectives. Approach the situation with empathy and focus on finding solutions together. Remember that conflicts can strengthen relationships when handled with care and respect.';
  }

  static List<String> generateSelfGrowthSuggestions(String growthArea) {
    final area = growthArea.toLowerCase();

    if (area.contains('confidence') ||
        area.contains('self-esteem') ||
        area.contains('worth')) {
      return [
        'Practice daily affirmations that reinforce your worth and capabilities',
        'Set small, achievable goals to build momentum and celebrate wins',
        'Challenge negative self-talk by questioning its validity',
        'Keep a success journal to track your accomplishments',
        'Surround yourself with supportive people who believe in you'
      ];
    } else if (area.contains('relationship') ||
        area.contains('social') ||
        area.contains('communication')) {
      return [
        'Practice active listening in your daily interactions',
        'Express gratitude to people who matter to you regularly',
        'Set healthy boundaries to protect your energy and well-being',
        'Learn to say no without guilt when necessary',
        'Practice empathy by trying to understand others\' perspectives'
      ];
    } else if (area.contains('anxiety') ||
        area.contains('stress') ||
        area.contains('worry')) {
      return [
        'Practice deep breathing exercises when feeling overwhelmed',
        'Challenge anxious thoughts by examining evidence for and against them',
        'Create a daily mindfulness or meditation practice',
        'Limit exposure to stress triggers when possible',
        'Focus on what you can control and let go of what you cannot'
      ];
    } else if (area.contains('career') ||
        area.contains('work') ||
        area.contains('professional')) {
      return [
        'Set clear professional goals and create action plans to achieve them',
        'Seek feedback regularly to understand your strengths and growth areas',
        'Invest in continuous learning and skill development',
        'Build meaningful professional relationships and networks',
        'Find ways to align your work with your values and passions'
      ];
    } else if (area.contains('health') ||
        area.contains('fitness') ||
        area.contains('wellness')) {
      return [
        'Start with small, sustainable changes to your daily routine',
        'Focus on progress, not perfection, in your health journey',
        'Find physical activities you genuinely enjoy',
        'Prioritize sleep and create a consistent sleep schedule',
        'Practice self-compassion when you have setbacks'
      ];
    } else if (area.contains('creativity') ||
        area.contains('artistic') ||
        area.contains('expression')) {
      return [
        'Set aside regular time for creative pursuits without judgment',
        'Experiment with different forms of creative expression',
        'Join communities of like-minded creative individuals',
        'Embrace imperfection and focus on the joy of creating',
        'Document your creative journey to see your growth over time'
      ];
    } else if (area.contains('spiritual') ||
        area.contains('meaning') ||
        area.contains('purpose')) {
      return [
        'Explore different spiritual practices to find what resonates with you',
        'Spend time in nature to connect with something greater than yourself',
        'Practice gratitude daily to cultivate appreciation for life',
        'Engage in service to others to find meaning and purpose',
        'Reflect regularly on your values and how they guide your decisions'
      ];
    } else if (area.contains('emotional') ||
        area.contains('feelings') ||
        area.contains('mood')) {
      return [
        'Practice identifying and naming your emotions as they arise',
        'Keep an emotion journal to track patterns and triggers',
        'Learn healthy coping strategies for difficult emotions',
        'Practice self-compassion when experiencing challenging feelings',
        'Seek support from trusted friends or professionals when needed'
      ];
    }

    return [
      'Reflect on your values and align your actions with them',
      'Practice mindfulness to stay present and aware of your thoughts',
      'Embrace challenges as opportunities for growth and learning',
      'Cultivate a growth mindset that sees abilities as developable',
      'Be patient and kind with yourself throughout your growth journey'
    ];
  }

  static String generateRelationshipInsight(
      String relationshipType, int compatibilityScore) {
    if (relationshipType.toLowerCase().contains('romantic')) {
      if (compatibilityScore >= 85) {
        return 'Your romantic compatibility suggests a harmonious partnership with natural understanding. Focus on nurturing this connection through quality time and open communication.';
      } else if (compatibilityScore >= 70) {
        return 'Your romantic relationship has good potential with some areas for growth. Work on understanding each other\'s love languages and communication styles.';
      } else {
        return 'Your romantic relationship may face challenges that can lead to growth. Focus on patience, understanding, and finding common ground in your differences.';
      }
    } else {
      if (compatibilityScore >= 85) {
        return 'Your friendship compatibility is excellent! You likely share similar values and communication styles. Invest in this relationship through shared experiences.';
      } else if (compatibilityScore >= 70) {
        return 'Your friendship has solid potential. Focus on finding common interests and respecting each other\'s unique perspectives and approaches to life.';
      } else {
        return 'Your friendship may require extra understanding and patience. Focus on appreciating your differences and finding activities you both enjoy.';
      }
    }
  }

  static List<String> generateDailyRelationshipTips() {
    final tips = [
      'Express gratitude for something your partner or friend did today',
      'Practice active listening in your next conversation',
      'Share something you appreciate about your relationship',
      'Ask an open-ended question to learn something new about them',
      'Offer support without trying to fix or solve their problems',
      'Show affection in a way that matches their love language',
      'Take responsibility for your part in any recent conflicts',
      'Plan a special activity you can enjoy together',
      'Give them your full attention without distractions',
      'Compliment them on something beyond their appearance',
    ];

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return [tips[dayOfYear % tips.length]];
  }
}
