/// Sentiment analysis engine for journal entries
/// Uses heuristic-based analysis with keyword matching and pattern detection
class SentimentAnalyzer {
  /// Analyze the sentiment of a text and return a score from -1.0 (very negative) to 1.0 (very positive)
  static Map<String, dynamic> analyzeSentiment(String text) {
    final content = text.toLowerCase();

    // Count positive and negative words
    final positiveCount = _countPositiveWords(content);
    final negativeCount = _countNegativeWords(content);
    final neutralCount = _countNeutralWords(content);

    // Detect emotions
    final emotions = _detectEmotions(content);

    // Calculate sentiment score
    final totalWords = positiveCount + negativeCount + neutralCount;
    double score = 0.0;

    if (totalWords > 0) {
      score = (positiveCount - negativeCount) / totalWords;
      // Normalize to -1.0 to 1.0 range
      score = score.clamp(-1.0, 1.0);
    }

    // Determine sentiment category
    String sentiment;
    if (score > 0.3) {
      sentiment = 'positive';
    } else if (score < -0.3) {
      sentiment = 'negative';
    } else {
      sentiment = 'neutral';
    }

    // Detect intensity
    final intensity = _detectIntensity(content);

    return {
      'score': score,
      'sentiment': sentiment,
      'emotions': emotions,
      'intensity': intensity,
      'positiveCount': positiveCount,
      'negativeCount': negativeCount,
      'neutralCount': neutralCount,
    };
  }

  static int _countPositiveWords(String content) {
    final positiveWords = [
      // Joy and happiness
      'happy', 'joy', 'joyful', 'excited', 'thrilled', 'delighted', 'cheerful',
      'wonderful', 'amazing', 'fantastic', 'great', 'excellent', 'awesome',
      'beautiful', 'lovely', 'pleasant', 'enjoyable', 'fun', 'entertaining',

      // Love and affection
      'love', 'loving', 'loved', 'adore', 'cherish', 'treasure', 'appreciate',
      'grateful', 'thankful', 'blessed', 'fortunate', 'lucky',

      // Success and achievement
      'success', 'successful', 'achieve', 'achieved', 'accomplish',
      'accomplished',
      'win', 'won', 'victory', 'triumph', 'proud', 'pride', 'confident',

      // Peace and calm
      'peace', 'peaceful', 'calm', 'serene', 'tranquil', 'relaxed', 'content',
      'satisfied', 'comfortable', 'safe', 'secure',

      // Hope and optimism
      'hope', 'hopeful', 'optimistic', 'positive', 'bright', 'promising',
      'encouraged', 'inspired', 'motivated', 'energized',

      // Connection
      'connected', 'close', 'together', 'united', 'supported', 'understood',
      'accepted', 'belong', 'included',

      // Growth
      'growth', 'growing', 'learning', 'improving', 'better', 'progress',
      'forward', 'healing', 'recovered', 'stronger',
    ];

    int count = 0;
    for (final word in positiveWords) {
      count += RegExp('\\b$word\\b').allMatches(content).length;
    }
    return count;
  }

  static int _countNegativeWords(String content) {
    final negativeWords = [
      // Sadness
      'sad', 'sadness', 'unhappy', 'depressed', 'depression', 'miserable',
      'heartbroken', 'devastated', 'grief', 'sorrow', 'crying', 'tears',

      // Anger
      'angry', 'anger', 'mad', 'furious', 'rage', 'frustrated', 'frustration',
      'annoyed', 'irritated', 'upset', 'bothered',

      // Fear and anxiety
      'afraid', 'fear', 'scared', 'terrified', 'anxious', 'anxiety', 'worried',
      'worry', 'nervous', 'panic', 'stressed', 'stress', 'overwhelmed',

      // Pain and suffering
      'hurt', 'pain', 'painful', 'suffering', 'ache', 'aching', 'agony',

      // Loneliness
      'lonely', 'alone', 'isolated', 'abandoned', 'rejected', 'excluded',
      'disconnected', 'empty',

      // Failure and disappointment
      'fail', 'failed', 'failure', 'disappointed', 'disappointment', 'regret',
      'mistake', 'wrong', 'lost', 'losing',

      // Negativity
      'bad', 'terrible', 'awful', 'horrible', 'worst', 'hate', 'hated',
      'dislike', 'disgusted', 'sick', 'tired', 'exhausted', 'drained',

      // Conflict
      'fight', 'fighting', 'argue', 'argument', 'conflict', 'problem',
      'issue', 'difficult', 'hard', 'struggle', 'struggling',

      // Doubt and confusion
      'doubt', 'uncertain', 'confused', 'lost', 'stuck', 'helpless',
      'hopeless', 'worthless', 'useless',
    ];

    int count = 0;
    for (final word in negativeWords) {
      count += RegExp('\\b$word\\b').allMatches(content).length;
    }
    return count;
  }

  static int _countNeutralWords(String content) {
    // Count total words and subtract positive and negative
    final words = content.split(RegExp(r'\s+'));
    return words.length;
  }

  static List<String> _detectEmotions(String content) {
    final emotions = <String>[];

    // Joy
    if (content
        .contains(RegExp(r'\b(happy|joy|excited|thrilled|delighted)\b'))) {
      emotions.add('joy');
    }

    // Sadness
    if (content
        .contains(RegExp(r'\b(sad|depressed|heartbroken|crying|tears)\b'))) {
      emotions.add('sadness');
    }

    // Anger
    if (content.contains(RegExp(r'\b(angry|mad|furious|frustrated|rage)\b'))) {
      emotions.add('anger');
    }

    // Fear/Anxiety
    if (content.contains(
        RegExp(r'\b(afraid|scared|anxious|worried|panic|stressed)\b'))) {
      emotions.add('anxiety');
    }

    // Love
    if (content.contains(RegExp(r'\b(love|loving|adore|cherish|treasure)\b'))) {
      emotions.add('love');
    }

    // Gratitude
    if (content
        .contains(RegExp(r'\b(grateful|thankful|blessed|appreciate)\b'))) {
      emotions.add('gratitude');
    }

    // Hope
    if (content.contains(
        RegExp(r'\b(hope|hopeful|optimistic|encouraged|inspired)\b'))) {
      emotions.add('hope');
    }

    // Loneliness
    if (content.contains(
        RegExp(r'\b(lonely|alone|isolated|abandoned|disconnected)\b'))) {
      emotions.add('loneliness');
    }

    // Confusion
    if (content
        .contains(RegExp(r'\b(confused|uncertain|lost|stuck|doubt)\b'))) {
      emotions.add('confusion');
    }

    // Peace
    if (content.contains(RegExp(r'\b(peace|calm|serene|tranquil|relaxed)\b'))) {
      emotions.add('peace');
    }

    return emotions;
  }

  static String _detectIntensity(String content) {
    // Check for intensifiers
    final highIntensityWords = [
      'very',
      'extremely',
      'incredibly',
      'absolutely',
      'completely',
      'totally',
      'utterly',
      'so much',
      'really',
      'truly',
      'deeply',
      'profoundly',
    ];

    final exclamationCount = '!'.allMatches(content).length;
    final capsWords = RegExp(r'\b[A-Z]{2,}\b').allMatches(content).length;

    int intensityScore = 0;
    for (final word in highIntensityWords) {
      intensityScore += RegExp('\\b$word\\b').allMatches(content).length;
    }
    intensityScore += exclamationCount;
    intensityScore += capsWords;

    if (intensityScore >= 3) {
      return 'high';
    } else if (intensityScore >= 1) {
      return 'medium';
    } else {
      return 'low';
    }
  }

  /// Analyze sentiment trends over multiple journal entries
  static Map<String, dynamic> analyzeTrends(
      List<Map<String, dynamic>> entries) {
    if (entries.isEmpty) {
      return {
        'averageScore': 0.0,
        'trend': 'stable',
        'dominantEmotion': 'neutral',
        'emotionFrequency': <String, int>{},
        'weeklyAverages': <double>[],
      };
    }

    // Calculate average sentiment
    double totalScore = 0.0;
    final emotionFrequency = <String, int>{};
    final scores = <double>[];

    for (final entry in entries) {
      final analysis = analyzeSentiment(entry['content'] ?? '');
      final score = analysis['score'] as double;
      scores.add(score);
      totalScore += score;

      // Count emotions
      final emotions = analysis['emotions'] as List<String>;
      for (final emotion in emotions) {
        emotionFrequency[emotion] = (emotionFrequency[emotion] ?? 0) + 1;
      }
    }

    final averageScore = totalScore / entries.length;

    // Determine trend (comparing first half to second half)
    String trend = 'stable';
    if (scores.length >= 4) {
      final firstHalf = scores.sublist(0, scores.length ~/ 2);
      final secondHalf = scores.sublist(scores.length ~/ 2);

      final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
      final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

      if (secondAvg > firstAvg + 0.2) {
        trend = 'improving';
      } else if (secondAvg < firstAvg - 0.2) {
        trend = 'declining';
      }
    }

    // Find dominant emotion
    String dominantEmotion = 'neutral';
    int maxCount = 0;
    emotionFrequency.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantEmotion = emotion;
      }
    });

    return {
      'averageScore': averageScore,
      'trend': trend,
      'dominantEmotion': dominantEmotion,
      'emotionFrequency': emotionFrequency,
      'scores': scores,
      'entryCount': entries.length,
    };
  }

  /// Generate insights based on sentiment analysis
  static String generateInsight(Map<String, dynamic> analysis) {
    final score = analysis['score'] as double;
    final sentiment = analysis['sentiment'] as String;
    final emotions = analysis['emotions'] as List<String>;
    final intensity = analysis['intensity'] as String;

    String insight = '';

    // Sentiment-based insight
    if (sentiment == 'positive') {
      insight += 'Your entry reflects a positive emotional state. ';
      if (intensity == 'high') {
        insight +=
            'The strong positive energy in your words suggests you\'re experiencing significant joy or satisfaction. ';
      }
    } else if (sentiment == 'negative') {
      insight +=
          'Your entry shows you\'re working through some challenging emotions. ';
      if (intensity == 'high') {
        insight +=
            'The intensity of your feelings suggests this is weighing heavily on you. Remember, it\'s okay to feel this way. ';
      }
    } else {
      insight += 'Your entry shows a balanced emotional state. ';
    }

    // Emotion-specific insights
    if (emotions.contains('anxiety')) {
      insight +=
          'I notice anxiety present in your words. Consider grounding practices like deep breathing or connecting with nature. ';
    }
    if (emotions.contains('gratitude')) {
      insight +=
          'Your gratitude is beautiful and helps cultivate positive energy. ';
    }
    if (emotions.contains('loneliness')) {
      insight +=
          'Feelings of loneliness are valid. Consider reaching out to someone you trust or engaging in activities that bring you connection. ';
    }
    if (emotions.contains('hope')) {
      insight += 'Your hope is a powerful force for positive change. ';
    }
    if (emotions.contains('confusion')) {
      insight +=
          'When feeling confused, journaling more can help clarify your thoughts and feelings. ';
    }

    // Score-based encouragement
    if (score < -0.5) {
      insight +=
          'Remember, difficult times are temporary. You have the strength to navigate this.';
    } else if (score > 0.5) {
      insight += 'Keep nurturing this positive energy!';
    }

    return insight.trim();
  }

  /// Generate trend insight
  static String generateTrendInsight(Map<String, dynamic> trendAnalysis) {
    final trend = trendAnalysis['trend'] as String;
    final averageScore = trendAnalysis['averageScore'] as double;
    final dominantEmotion = trendAnalysis['dominantEmotion'] as String;
    final entryCount = trendAnalysis['entryCount'] as int;

    String insight = 'Based on your last $entryCount journal entries: ';

    if (trend == 'improving') {
      insight +=
          'Your emotional well-being shows a positive upward trend! This suggests your growth practices are working. ';
    } else if (trend == 'declining') {
      insight +=
          'I notice your mood has been trending downward. This might be a good time to focus on self-care and reach out for support if needed. ';
    } else {
      insight += 'Your emotional state has been relatively stable. ';
    }

    if (averageScore > 0.3) {
      insight +=
          'Overall, you\'ve been experiencing more positive than negative emotions. ';
    } else if (averageScore < -0.3) {
      insight +=
          'You\'ve been working through some challenging emotions. Be gentle with yourself. ';
    }

    if (dominantEmotion != 'neutral') {
      insight +=
          'The emotion that appears most frequently is $dominantEmotion. ';

      if (dominantEmotion == 'anxiety') {
        insight +=
            'Consider incorporating more grounding and calming practices into your routine.';
      } else if (dominantEmotion == 'gratitude') {
        insight += 'Your consistent gratitude practice is beautiful!';
      } else if (dominantEmotion == 'joy') {
        insight += 'Your joy is radiating through your entries!';
      } else if (dominantEmotion == 'sadness') {
        insight +=
            'It\'s important to honor these feelings while also nurturing hope.';
      }
    }

    return insight;
  }
}
