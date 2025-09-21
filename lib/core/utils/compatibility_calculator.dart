import 'numerology_calculator.dart';

class CompatibilityCalculator {
  static Map<String, dynamic> calculateRomanticCompatibility(
    String person1Name, DateTime person1Birth,
    String person2Name, DateTime person2Birth
  ) {
    final person1LifePath = NumerologyCalculator.calculateLifePath(person1Birth);
    final person1NameNumber = NumerologyCalculator.calculateNameNumber(person1Name);
    final person2LifePath = NumerologyCalculator.calculateLifePath(person2Birth);
    final person2NameNumber = NumerologyCalculator.calculateNameNumber(person2Name);
    
    final lifePathCompatibility = _calculateLifePathCompatibility(person1LifePath, person2LifePath);
    final nameCompatibility = _calculateNameCompatibility(person1NameNumber, person2NameNumber);
    final overallScore = ((lifePathCompatibility['score']! + nameCompatibility['score']!) / 2).round();
    
    return {
      'overallScore': overallScore,
      'lifePathCompatibility': lifePathCompatibility,
      'nameCompatibility': nameCompatibility,
      'insights': _generateRomanticInsights(person1LifePath, person2LifePath, overallScore),
      'advice': _generateRomanticAdvice(overallScore),
      'person1LifePath': person1LifePath,
      'person2LifePath': person2LifePath,
      'person1NameNumber': person1NameNumber,
      'person2NameNumber': person2NameNumber,
    };
  }

  static Map<String, dynamic> calculateFriendshipCompatibility(
    String person1Name, DateTime person1Birth,
    String person2Name, DateTime person2Birth
  ) {
    final person1LifePath = NumerologyCalculator.calculateLifePath(person1Birth);
    final person1NameNumber = NumerologyCalculator.calculateNameNumber(person1Name);
    final person2LifePath = NumerologyCalculator.calculateLifePath(person2Birth);
    final person2NameNumber = NumerologyCalculator.calculateNameNumber(person2Name);
    
    final lifePathCompatibility = _calculateLifePathCompatibility(person1LifePath, person2LifePath);
    final nameCompatibility = _calculateNameCompatibility(person1NameNumber, person2NameNumber);
    final overallScore = ((lifePathCompatibility['score']! + nameCompatibility['score']!) / 2).round();
    
    return {
      'overallScore': overallScore,
      'lifePathCompatibility': lifePathCompatibility,
      'nameCompatibility': nameCompatibility,
      'insights': _generateFriendshipInsights(person1LifePath, person2LifePath, overallScore),
      'advice': _generateFriendshipAdvice(overallScore),
      'person1LifePath': person1LifePath,
      'person2LifePath': person2LifePath,
      'person1NameNumber': person1NameNumber,
      'person2NameNumber': person2NameNumber,
    };
  }

  static Map<String, dynamic> _calculateLifePathCompatibility(int path1, int path2) {
    final compatibilityMatrix = {
      1: {1: 85, 2: 70, 3: 90, 4: 60, 5: 80, 6: 75, 7: 65, 8: 85, 9: 70},
      2: {1: 70, 2: 80, 3: 75, 4: 85, 5: 65, 6: 90, 7: 70, 8: 60, 9: 85},
      3: {1: 90, 2: 75, 3: 85, 4: 65, 5: 95, 6: 80, 7: 70, 8: 75, 9: 90},
      4: {1: 60, 2: 85, 3: 65, 4: 80, 5: 55, 6: 85, 7: 75, 8: 90, 9: 70},
      5: {1: 80, 2: 65, 3: 95, 4: 55, 5: 85, 6: 70, 7: 80, 8: 75, 9: 85},
      6: {1: 75, 2: 90, 3: 80, 4: 85, 5: 70, 6: 85, 7: 75, 8: 80, 9: 95},
      7: {1: 65, 2: 70, 3: 70, 4: 75, 5: 80, 6: 75, 7: 90, 8: 70, 9: 80},
      8: {1: 85, 2: 60, 3: 75, 4: 90, 5: 75, 6: 80, 7: 70, 8: 85, 9: 75},
      9: {1: 70, 2: 85, 3: 90, 4: 70, 5: 85, 6: 95, 7: 80, 8: 75, 9: 85},
    };

    final score = compatibilityMatrix[path1]?[path2] ?? 70;
    return {
      'score': score,
      'description': _getCompatibilityDescription(score),
    };
  }

  static Map<String, dynamic> _calculateNameCompatibility(int name1, int name2) {
    final difference = (name1 - name2).abs();
    int score;
    
    if (difference == 0) {
      score = 95;
    } else if (difference <= 2) {
      score = 85;
    } else if (difference <= 4) {
      score = 75;
    } else if (difference <= 6) {
      score = 65;
    } else {
      score = 55;
    }

    return {
      'score': score,
      'description': _getCompatibilityDescription(score),
    };
  }

  static String _getCompatibilityDescription(int score) {
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Very Good';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Fair';
    return 'Challenging';
  }

  static List<String> _generateRomanticInsights(int path1, int path2, int score) {
    final insights = <String>[];
    
    if (score >= 85) {
      insights.add('You share a natural harmony and understanding that makes your relationship flow effortlessly.');
      insights.add('Your life paths complement each other beautifully, creating a strong foundation for love.');
    } else if (score >= 70) {
      insights.add('You have good compatibility with some areas that may need attention and communication.');
      insights.add('Your differences can actually strengthen your relationship when approached with understanding.');
    } else {
      insights.add('Your relationship may face challenges, but these can lead to significant growth for both partners.');
      insights.add('Focus on understanding and appreciating your different approaches to life.');
    }

    insights.add(_getLifePathCombinationInsight(path1, path2, 'romantic'));
    
    return insights;
  }

  static List<String> _generateFriendshipInsights(int path1, int path2, int score) {
    final insights = <String>[];
    
    if (score >= 85) {
      insights.add('You make excellent friends with natural understanding and shared interests.');
      insights.add('Your friendship is likely to be long-lasting and mutually supportive.');
    } else if (score >= 70) {
      insights.add('You have a solid friendship foundation with room for growth and deeper connection.');
      insights.add('Your different perspectives can enrich each other\'s lives when embraced.');
    } else {
      insights.add('Your friendship may require extra effort but can be very rewarding.');
      insights.add('Focus on finding common ground and respecting your differences.');
    }

    insights.add(_getLifePathCombinationInsight(path1, path2, 'friendship'));
    
    return insights;
  }

  static String _getLifePathCombinationInsight(int path1, int path2, String type) {
    final key = '${path1}_$path2';
    final reverseKey = '${path2}_$path1';
    
    final romanticInsights = {
      '1_1': 'Two leaders together create a powerful, ambitious partnership.',
      '1_2': 'The leader and peacemaker balance independence with cooperation.',
      '1_3': 'Leadership meets creativity in an inspiring and dynamic relationship.',
      '2_2': 'Two diplomatic souls create harmony and deep emotional connection.',
      '2_3': 'Cooperation and creativity blend beautifully for mutual support.',
      '3_3': 'Double creativity brings joy, expression, and artistic collaboration.',
      '6_9': 'The nurturer and humanitarian share a deep desire to help others.',
      '7_7': 'Two spiritual seekers find profound understanding and growth together.',
      '8_8': 'Ambitious achievers who can build an empire together.',
      '9_9': 'Humanitarian hearts united in service and compassion.',
    };

    final friendshipInsights = {
      '1_1': 'Two natural leaders who respect each other\'s independence and drive.',
      '1_2': 'The leader appreciates the peacemaker\'s diplomatic support.',
      '1_3': 'Leadership and creativity make for an inspiring and fun friendship.',
      '2_2': 'Two cooperative souls who create a harmonious and supportive bond.',
      '2_3': 'Diplomacy and creativity combine for a balanced and enriching friendship.',
      '3_3': 'Creative spirits who inspire and energize each other.',
      '6_9': 'Caring friends who support each other\'s desire to help others.',
      '7_7': 'Deep thinkers who enjoy philosophical conversations and spiritual growth.',
      '8_8': 'Ambitious friends who motivate each other toward success.',
      '9_9': 'Compassionate friends united by their desire to make the world better.',
    };

    final insights = type == 'romantic' ? romanticInsights : friendshipInsights;
    
    return insights[key] ?? insights[reverseKey] ?? 
           'Your unique combination brings special dynamics to your $type.';
  }

  static String _generateRomanticAdvice(int score) {
    if (score >= 85) {
      return 'Nurture your natural connection through open communication and shared experiences. Your compatibility is a gift - cherish it.';
    } else if (score >= 70) {
      return 'Focus on understanding each other\'s perspectives and communicating openly about your needs and differences.';
    } else {
      return 'Patience and understanding are key. Work on finding common ground and appreciating what makes each of you unique.';
    }
  }

  static String _generateFriendshipAdvice(int score) {
    if (score >= 85) {
      return 'Your friendship has excellent potential. Invest time in shared activities and be there for each other through life\'s ups and downs.';
    } else if (score >= 70) {
      return 'Build your friendship through regular communication and finding activities you both enjoy. Respect each other\'s differences.';
    } else {
      return 'Focus on finding common interests and being patient with each other\'s different approaches to life and friendship.';
    }
  }
}
