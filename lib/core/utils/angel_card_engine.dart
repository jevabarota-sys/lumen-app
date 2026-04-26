import 'dart:math';

class AngelCardEngine {
  static final List<Map<String, String>> _angelCards = [
    {
      'name': 'Love',
      'message':
          'Divine love surrounds you. Open your heart to give and receive unconditional love.',
      'guidance':
          'The angels remind you that love is the highest vibration. Share your love freely and watch it multiply in your life.',
    },
    {
      'name': 'Peace',
      'message':
          'Inner peace is your natural state. Release worry and embrace tranquility.',
      'guidance':
          'Take time for quiet reflection. The angels are bringing you the gift of serenity and calm.',
    },
    {
      'name': 'Abundance',
      'message':
          'The universe is infinitely abundant. Open yourself to receive prosperity in all forms.',
      'guidance':
          'Your angels want you to know that you deserve abundance. Release scarcity thinking and embrace your birthright of prosperity.',
    },
    {
      'name': 'Healing',
      'message':
          'Divine healing energy flows through you now. Trust in your body\'s wisdom to restore balance.',
      'guidance':
          'The angels are working to heal you on all levels - physical, emotional, and spiritual. Allow this healing to unfold.',
    },
    {
      'name': 'Protection',
      'message':
          'You are divinely protected. Your angels surround you with white light and love.',
      'guidance':
          'Release all fear. You are safe and protected by your guardian angels at all times.',
    },
    {
      'name': 'Guidance',
      'message':
          'Clear guidance is available to you. Trust your intuition and inner knowing.',
      'guidance':
          'Your angels are speaking to you through your thoughts, feelings, and signs. Pay attention to the messages you receive.',
    },
    {
      'name': 'Faith',
      'message':
          'Have faith in the divine plan. Everything is unfolding perfectly for your highest good.',
      'guidance':
          'The angels ask you to trust the journey, even when you cannot see the destination. Your faith will be rewarded.',
    },
    {
      'name': 'Joy',
      'message':
          'Choose joy in this moment. Happiness is your divine birthright.',
      'guidance':
          'The angels want you to know that joy is a choice you can make right now. Find reasons to smile and celebrate life.',
    },
    {
      'name': 'Forgiveness',
      'message':
          'Release the past through forgiveness. Free yourself and others from old wounds.',
      'guidance':
          'Forgiveness is a gift you give yourself. The angels support you in letting go of resentment and embracing peace.',
    },
    {
      'name': 'Courage',
      'message':
          'You are braver than you know. Step forward with confidence and strength.',
      'guidance':
          'Your angels are giving you the courage to face any challenge. You have the strength within you to overcome obstacles.',
    },
    {
      'name': 'Clarity',
      'message':
          'Mental clarity is coming to you. The fog is lifting, revealing the truth.',
      'guidance':
          'The angels are helping you see situations clearly. Trust the insights and understanding that emerge.',
    },
    {
      'name': 'Gratitude',
      'message':
          'Count your blessings. Gratitude opens the door to more abundance.',
      'guidance':
          'The angels remind you that gratitude is a powerful magnet for miracles. Appreciate what you have and watch it grow.',
    },
    {
      'name': 'Hope',
      'message': 'Never lose hope. Miracles are on their way to you.',
      'guidance':
          'Your angels want you to maintain hope even in challenging times. Better days are ahead, and divine intervention is at work.',
    },
    {
      'name': 'Transformation',
      'message':
          'You are in a period of profound transformation. Embrace the changes.',
      'guidance':
          'The angels are guiding you through a metamorphosis. Trust the process and know that you are becoming your highest self.',
    },
    {
      'name': 'Wisdom',
      'message': 'Ancient wisdom flows through you. Trust your inner sage.',
      'guidance':
          'You have access to divine wisdom. The angels encourage you to trust your knowledge and share it with others.',
    },
    {
      'name': 'Balance',
      'message':
          'Seek balance in all areas of your life. Harmony brings peace.',
      'guidance':
          'The angels are helping you find equilibrium between work and rest, giving and receiving, action and stillness.',
    },
    {
      'name': 'Creativity',
      'message':
          'Your creative spirit is awakening. Express yourself freely and joyfully.',
      'guidance':
          'The angels are inspiring your creativity. Allow your unique gifts to flow through you and into the world.',
    },
    {
      'name': 'Purpose',
      'message':
          'You have a divine purpose. Trust that you are exactly where you need to be.',
      'guidance':
          'Your angels remind you that your life has meaning and purpose. Every experience is preparing you for your soul\'s mission.',
    },
    {
      'name': 'Patience',
      'message':
          'Divine timing is at work. Trust the process and practice patience.',
      'guidance':
          'The angels ask you to be patient. Everything is unfolding in perfect timing for your highest good.',
    },
    {
      'name': 'Strength',
      'message':
          'You are stronger than you realize. Draw upon your inner power.',
      'guidance':
          'Your angels are reminding you of your incredible strength. You have overcome challenges before and you will again.',
    },
    {
      'name': 'Trust',
      'message':
          'Trust in the divine plan. You are being guided and supported.',
      'guidance':
          'The angels ask you to surrender control and trust that everything is working out for your benefit.',
    },
    {
      'name': 'Compassion',
      'message':
          'Show compassion to yourself and others. Kindness heals all wounds.',
      'guidance':
          'Your angels encourage you to be gentle with yourself and others. Compassion creates miracles.',
    },
    {
      'name': 'Freedom',
      'message': 'You are free to choose your path. Release all limitations.',
      'guidance':
          'The angels remind you that you are a free spirit. Let go of anything that holds you back from your true self.',
    },
    {
      'name': 'Harmony',
      'message':
          'Harmony is restored. Peace flows through all your relationships.',
      'guidance':
          'Your angels are bringing harmony to your life. Conflicts are resolving and understanding is growing.',
    },
    {
      'name': 'Inspiration',
      'message':
          'Divine inspiration is flowing to you. Act on your inspired ideas.',
      'guidance':
          'The angels are sending you inspired thoughts and ideas. Trust these divine downloads and take action on them.',
    },
    {
      'name': 'Miracles',
      'message': 'Expect miracles. The impossible is becoming possible.',
      'guidance':
          'Your angels want you to know that miracles are natural. Open yourself to receive the extraordinary.',
    },
    {
      'name': 'New Beginnings',
      'message':
          'A fresh start awaits you. Embrace new opportunities with an open heart.',
      'guidance':
          'The angels are opening new doors for you. Step through them with confidence and excitement.',
    },
    {
      'name': 'Release',
      'message': 'Let go of what no longer serves you. Make space for the new.',
      'guidance':
          'Your angels are helping you release old patterns, beliefs, and situations. Trust that better things are coming.',
    },
    {
      'name': 'Serenity',
      'message': 'Find your center of calm. Serenity is available to you now.',
      'guidance':
          'The angels are bringing you the gift of serenity. Breathe deeply and feel their peaceful presence.',
    },
    {
      'name': 'Victory',
      'message':
          'Success is yours. Celebrate your victories, both big and small.',
      'guidance':
          'Your angels celebrate with you. You have overcome obstacles and achieved your goals. Acknowledge your success.',
    },
  ];

  static List<Map<String, String>> drawCards(
      {int count = 1, bool isRandom = true}) {
    if (count < 1 || count > _angelCards.length) {
      throw ArgumentError('Count must be between 1 and ${_angelCards.length}');
    }

    if (isRandom) {
      final random = Random();
      final shuffled = List<Map<String, String>>.from(_angelCards)
        ..shuffle(random);
      return shuffled.take(count).toList();
    } else {
      // Deterministic selection based on date
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = Random(seed);
      final shuffled = List<Map<String, String>>.from(_angelCards)
        ..shuffle(random);
      return shuffled.take(count).toList();
    }
  }

  static Map<String, String> drawSingleCard({bool isRandom = true}) {
    return drawCards(count: 1, isRandom: isRandom).first;
  }

  static List<Map<String, String>> getAllCards() {
    return List.unmodifiable(_angelCards);
  }

  static int get totalCards => _angelCards.length;
}
