class AIAdvisor {
  /// Enhanced conflict advice with multi-pattern detection and context awareness
  static String generateConflictAdvice(String conflictDescription) {
    final content = conflictDescription.toLowerCase();
    final patterns = _detectConflictPatterns(content);
    final severity = _assessConflictSeverity(content);
    final emotionalTone = _detectEmotionalTone(content);
    
    // Multi-pattern conflicts get more nuanced advice
    if (patterns.length > 1) {
      return _generateMultiPatternAdvice(patterns, severity, emotionalTone);
    }
    
    // Single pattern conflicts
    if (patterns.isNotEmpty) {
      return _generateSinglePatternAdvice(patterns.first, severity, emotionalTone);
    }

    // Default advice with emotional awareness
    if (emotionalTone == 'distressed') {
      return 'I can sense this situation is causing you distress. Take a moment to breathe and center yourself. When you\'re ready, approach the conversation with curiosity rather than judgment. Ask yourself: "What is this conflict trying to teach me?" Remember, you have the strength to navigate this challenge.';
    }
    
    return 'Take time to understand both perspectives. Approach the situation with empathy and focus on finding solutions together. Remember that conflicts can strengthen relationships when handled with care and respect.';
  }
  
  static List<String> _detectConflictPatterns(String content) {
    final patterns = <String>[];
    
    if (content.contains(RegExp(r'\b(communication|talking|listen|hear|speak|say|tell)\b'))) {
      patterns.add('communication');
    }
    if (content.contains(RegExp(r'\b(trust|betrayal|lie|lying|lied|cheat|honest)\b'))) {
      patterns.add('trust');
    }
    if (content.contains(RegExp(r'\b(jealous|envy|insecure|compare|comparing)\b'))) {
      patterns.add('jealousy');
    }
    if (content.contains(RegExp(r'\b(money|financial|spending|budget|debt|bills)\b'))) {
      patterns.add('financial');
    }
    if (content.contains(RegExp(r'\b(family|in-laws|parents|mother|father|sibling)\b'))) {
      patterns.add('family');
    }
    if (content.contains(RegExp(r'\b(time|attention|neglect|ignore|busy|priority)\b'))) {
      patterns.add('attention');
    }
    if (content.contains(RegExp(r'\b(chores|housework|cleaning|cook|dishes|laundry)\b'))) {
      patterns.add('household');
    }
    if (content.contains(RegExp(r'\b(intimacy|physical|sex|affection|touch|close)\b'))) {
      patterns.add('intimacy');
    }
    if (content.contains(RegExp(r'\b(future|goals|plans|marriage|children|career)\b'))) {
      patterns.add('future');
    }
    if (content.contains(RegExp(r'\b(angry|mad|fight|argument|yell|scream|rage)\b'))) {
      patterns.add('anger');
    }
    if (content.contains(RegExp(r'\b(respect|disrespect|value|appreciate|dismiss)\b'))) {
      patterns.add('respect');
    }
    if (content.contains(RegExp(r'\b(control|controlling|manipulate|power|dominate)\b'))) {
      patterns.add('control');
    }
    
    return patterns;
  }
  
  static String _assessConflictSeverity(String content) {
    final highSeverityWords = ['abuse', 'violence', 'dangerous', 'threat', 'harm', 'scared', 'afraid', 'terrified'];
    final mediumSeverityWords = ['always', 'never', 'hate', 'can\'t stand', 'unbearable', 'breaking up', 'divorce'];
    
    for (final word in highSeverityWords) {
      if (content.contains(word)) return 'high';
    }
    for (final word in mediumSeverityWords) {
      if (content.contains(word)) return 'medium';
    }
    return 'low';
  }
  
  static String _detectEmotionalTone(String content) {
    if (content.contains(RegExp(r'\b(hurt|pain|sad|cry|devastated|heartbroken)\b'))) {
      return 'distressed';
    }
    if (content.contains(RegExp(r'\b(frustrated|annoyed|irritated|fed up)\b'))) {
      return 'frustrated';
    }
    if (content.contains(RegExp(r"\b(confused|lost|don't know|uncertain|unclear)\b"))) {
      return 'confused';
    }
    if (content.contains(RegExp(r'\b(hopeful|trying|want to|willing|open)\b'))) {
      return 'hopeful';
    }
    return 'neutral';
  }
  
  static String _generateMultiPatternAdvice(List<String> patterns, String severity, String emotionalTone) {
    final primaryPattern = patterns.first;
    final secondaryPattern = patterns.length > 1 ? patterns[1] : null;
    
    String advice = '';
    
    // Add severity-based opening
    if (severity == 'high') {
      advice += 'This sounds like a serious situation that may benefit from professional support. ';
    } else if (severity == 'medium') {
      advice += 'I can see this is a significant challenge for you. ';
    }
    
    // Primary pattern advice
    advice += _getPatternAdvice(primaryPattern);
    
    // Add secondary pattern connection
    if (secondaryPattern != null) {
      advice += '\n\nI also notice ${_getPatternName(secondaryPattern)} is involved. ${_getPatternAdvice(secondaryPattern)}';
    }
    
    // Add emotional validation
    if (emotionalTone == 'distressed') {
      advice += '\n\nYour feelings are valid. Be gentle with yourself as you work through this.';
    } else if (emotionalTone == 'hopeful') {
      advice += '\n\nYour willingness to work on this shows strength and commitment.';
    }
    
    return advice;
  }
  
  static String _generateSinglePatternAdvice(String pattern, String severity, String emotionalTone) {
    String advice = '';
    
    if (severity == 'high') {
      advice += 'This sounds serious. Please consider reaching out to a professional counselor or therapist who can provide personalized support. ';
    }
    
    advice += _getPatternAdvice(pattern);
    
    if (emotionalTone == 'distressed') {
      advice += '\n\nRemember to take care of yourself during this challenging time.';
    }
    
    return advice;
  }
  
  static String _getPatternName(String pattern) {
    final names = {
      'communication': 'communication',
      'trust': 'trust',
      'jealousy': 'jealousy or insecurity',
      'financial': 'financial concerns',
      'family': 'family dynamics',
      'attention': 'time and attention',
      'household': 'household responsibilities',
      'intimacy': 'intimacy',
      'future': 'future planning',
      'anger': 'anger',
      'respect': 'respect',
      'control': 'control or power dynamics',
    };
    return names[pattern] ?? pattern;
  }
  
  static String _getPatternAdvice(String pattern) {
    final adviceMap = {
      'communication': 'Focus on active listening and expressing your feelings with "I" statements. Clear communication is the foundation of resolving conflicts. Take turns speaking and really hear what the other person is saying without planning your response.',
      'trust': 'Rebuilding trust takes time and consistent actions. Be patient with the process and focus on transparency and reliability. Small, consistent gestures matter more than grand promises. Consider what specific actions would help rebuild trust.',
      'jealousy': 'Jealousy often stems from insecurity or unmet needs. Work on building self-confidence and communicate your needs openly. Ask yourself what you truly need to feel secure, then express that clearly.',
      'financial': 'Financial disagreements often reflect different values and priorities. Create a budget together and establish clear agreements about spending and saving. Focus on shared goals rather than individual wants.',
      'family': 'Family conflicts require setting healthy boundaries while maintaining respect. Discuss your needs privately first, then present a united front when addressing family issues. Remember, you\'re building your own family unit.',
      'attention': 'Quality time is essential for relationships. Schedule regular one-on-one time and be fully present. Discuss how you both prefer to give and receive attention, as people have different needs.',
      'household': 'Household responsibilities should be shared fairly based on capacity and preference. Create a clear division of tasks and appreciate each other\'s contributions. Resentment builds when expectations aren\'t discussed.',
      'intimacy': 'Physical and emotional intimacy require open communication about needs and boundaries. Create a safe space to discuss desires and concerns without judgment. Intimacy includes emotional connection, not just physical.',
      'future': 'Align your future visions through honest conversation about individual and shared goals. Find compromises that honor both of your dreams. It\'s okay to have different timelines if you\'re moving in the same direction.',
      'anger': 'When emotions run high, take a 20-minute break to cool down before continuing the discussion. Focus on the issue, not personal attacks. Use "I feel" statements instead of "You always" accusations.',
      'respect': 'Mutual respect is non-negotiable in healthy relationships. Identify specific behaviors that feel disrespectful and communicate how they impact you. Model the respect you want to receive.',
      'control': 'Healthy relationships involve equal partnership, not control. If you feel controlled, set firm boundaries. If you\'re being controlling, examine what fear is driving that behavior and address it directly.',
    };
    
    return adviceMap[pattern] ?? 'Approach this challenge with empathy and openness to understanding.';
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
