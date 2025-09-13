class NumerologyCalculator {
  static int calculateLifePath(DateTime dateOfBirth) {
    int day = dateOfBirth.day;
    int month = dateOfBirth.month;
    int year = dateOfBirth.year;
    
    int sum = _reduceToSingleDigit(day) + 
              _reduceToSingleDigit(month) + 
              _reduceToSingleDigit(year);
    
    return _reduceToSingleDigit(sum);
  }
  
  static int calculateNameNumber(String name) {
    const Map<String, int> letterValues = {
      'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9,
      'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'O': 6, 'P': 7, 'Q': 8, 'R': 9,
      'S': 1, 'T': 2, 'U': 3, 'V': 4, 'W': 5, 'X': 6, 'Y': 7, 'Z': 8
    };
    
    int sum = 0;
    for (String char in name.toUpperCase().split('')) {
      if (letterValues.containsKey(char)) {
        sum += letterValues[char]!;
      }
    }
    
    return _reduceToSingleDigit(sum);
  }
  
  static int _reduceToSingleDigit(int number) {
    while (number > 9) {
      int sum = 0;
      while (number > 0) {
        sum += number % 10;
        number ~/= 10;
      }
      number = sum;
    }
    return number;
  }
  
  static String getLifePathDescription(int lifePathNumber) {
    switch (lifePathNumber) {
      case 1:
        return "The Leader - You are a natural born leader with strong independence and determination.";
      case 2:
        return "The Peacemaker - You are diplomatic, cooperative, and work well with others.";
      case 3:
        return "The Creative - You are artistic, expressive, and have a gift for communication.";
      case 4:
        return "The Builder - You are practical, hardworking, and create solid foundations.";
      case 5:
        return "The Explorer - You love freedom, adventure, and experiencing new things.";
      case 6:
        return "The Nurturer - You are caring, responsible, and focused on family and community.";
      case 7:
        return "The Seeker - You are introspective, spiritual, and seek deeper understanding.";
      case 8:
        return "The Achiever - You are ambitious, business-minded, and focused on material success.";
      case 9:
        return "The Humanitarian - You are compassionate, generous, and want to help others.";
      default:
        return "Your path is unique and holds special meaning.";
    }
  }
  
  static Map<String, dynamic> generateDailyForecast(int lifePathNumber, DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final personalDay = _reduceToSingleDigit(dayOfYear + lifePathNumber);
    
    final forecasts = {
      1: {
        'energy': 'Leadership Energy',
        'focus': 'Take initiative and start new projects',
        'advice': 'Trust your instincts and lead by example',
      },
      2: {
        'energy': 'Cooperative Energy',
        'focus': 'Collaborate and build relationships',
        'advice': 'Listen to others and find common ground',
      },
      3: {
        'energy': 'Creative Energy',
        'focus': 'Express yourself and share your ideas',
        'advice': 'Let your creativity flow freely',
      },
      4: {
        'energy': 'Practical Energy',
        'focus': 'Organize and build solid foundations',
        'advice': 'Focus on details and steady progress',
      },
      5: {
        'energy': 'Adventure Energy',
        'focus': 'Explore new opportunities and experiences',
        'advice': 'Embrace change and stay flexible',
      },
      6: {
        'energy': 'Nurturing Energy',
        'focus': 'Care for others and create harmony',
        'advice': 'Show compassion and offer support',
      },
      7: {
        'energy': 'Spiritual Energy',
        'focus': 'Seek inner wisdom and understanding',
        'advice': 'Take time for reflection and meditation',
      },
      8: {
        'energy': 'Achievement Energy',
        'focus': 'Work toward your material goals',
        'advice': 'Stay organized and think strategically',
      },
      9: {
        'energy': 'Humanitarian Energy',
        'focus': 'Help others and give back to community',
        'advice': 'Share your wisdom and be generous',
      },
    };
    
    return forecasts[personalDay] ?? forecasts[1]!;
  }
}
