import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class TarotEngine {
  static final List<TarotCardData> _majorArcana = [
    const TarotCardData('The Fool', 'New beginnings, innocence, spontaneity', 'assets/tarot/fool.png'),
    const TarotCardData('The Magician', 'Manifestation, resourcefulness, power', 'assets/tarot/magician.png'),
    const TarotCardData('The High Priestess', 'Intuition, sacred knowledge, divine feminine', 'assets/tarot/high_priestess.png'),
    const TarotCardData('The Empress', 'Femininity, beauty, nature, abundance', 'assets/tarot/empress.png'),
    const TarotCardData('The Emperor', 'Authority, structure, control, fatherhood', 'assets/tarot/emperor.png'),
    const TarotCardData('The Hierophant', 'Spiritual wisdom, religious beliefs, conformity', 'assets/tarot/hierophant.png'),
    const TarotCardData('The Lovers', 'Love, harmony, relationships, values alignment', 'assets/tarot/lovers.png'),
    const TarotCardData('The Chariot', 'Control, willpower, success, determination', 'assets/tarot/chariot.png'),
    const TarotCardData('Strength', 'Strength, courage, persuasion, influence', 'assets/tarot/strength.png'),
    const TarotCardData('The Hermit', 'Soul searching, introspection, inner guidance', 'assets/tarot/hermit.png'),
    const TarotCardData('Wheel of Fortune', 'Good luck, karma, life cycles, destiny', 'assets/tarot/wheel_of_fortune.png'),
    const TarotCardData('Justice', 'Justice, fairness, truth, cause and effect', 'assets/tarot/justice.png'),
    const TarotCardData('The Hanged Man', 'Suspension, restriction, letting go', 'assets/tarot/hanged_man.png'),
    const TarotCardData('Death', 'Endings, beginnings, change, transformation', 'assets/tarot/death.png'),
    const TarotCardData('Temperance', 'Balance, moderation, patience, purpose', 'assets/tarot/temperance.png'),
    const TarotCardData('The Devil', 'Bondage, addiction, sexuality, materialism', 'assets/tarot/devil.png'),
    const TarotCardData('The Tower', 'Sudden change, upheaval, chaos, revelation', 'assets/tarot/tower.png'),
    const TarotCardData('The Star', 'Hope, faith, purpose, renewal, spirituality', 'assets/tarot/star.png'),
    const TarotCardData('The Moon', 'Illusion, fear, anxiety, subconscious, intuition', 'assets/tarot/moon.png'),
    const TarotCardData('The Sun', 'Positivity, fun, warmth, success, vitality', 'assets/tarot/sun.png'),
    const TarotCardData('Judgement', 'Judgement, rebirth, inner calling, absolution', 'assets/tarot/judgement.png'),
    const TarotCardData('The World', 'Completion, accomplishment, travel, fulfillment', 'assets/tarot/world.png'),
  ];

  static List<TarotCardData> drawCards(String userId, DateTime date, int numberOfCards) {
    final seed = _generateDeterministicSeed(userId, date);
    final random = Random(seed);
    
    final shuffledCards = List<TarotCardData>.from(_majorArcana);
    shuffledCards.shuffle(random);
    
    return shuffledCards.take(numberOfCards).toList();
  }
  
  static int _generateDeterministicSeed(String userId, DateTime date) {
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final input = '$userId-$dateString';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    
    int seed = 0;
    for (int i = 0; i < 4; i++) {
      seed = (seed << 8) + digest.bytes[i];
    }
    return seed;
  }
  
  static String generateAIReflection(List<TarotCardData> cards, String spreadType) {
    if (cards.length == 1) {
      return _generateSingleCardReflection(cards.first);
    } else if (cards.length == 3) {
      return _generateThreeCardReflection(cards);
    }
    return 'Reflect on the messages these cards bring to your journey today.';
  }
  
  static String _generateSingleCardReflection(TarotCardData card) {
    final reflections = {
      'The Fool': 'Today is perfect for new beginnings. Trust in your journey and take that first step with confidence.',
      'The Magician': 'You have all the tools you need to manifest your desires. Focus your energy and take action.',
      'The High Priestess': 'Listen to your intuition today. The answers you seek lie within your inner wisdom.',
      'The Empress': 'Embrace your creative and nurturing side. Beauty and abundance surround you.',
      'The Emperor': 'Take charge of your situation with confidence and structure. Leadership is called for.',
      'The Hierophant': 'Seek wisdom from traditional sources or mentors. Learning and spiritual growth await.',
      'The Lovers': 'Important choices about relationships or values are before you. Choose with your heart.',
      'The Chariot': 'Victory is within reach through determination and focused willpower. Stay the course.',
      'Strength': 'Approach challenges with gentle strength and inner courage. You are more powerful than you know.',
      'The Hermit': 'Take time for introspection and soul-searching. The answers you seek come from within.',
      'Wheel of Fortune': 'Change is coming, and it brings good fortune. Trust in the cycles of life.',
      'Justice': 'Fairness and truth will prevail. Make decisions based on what is right and just.',
      'The Hanged Man': 'Sometimes we must pause and see things from a new perspective. Surrender brings wisdom.',
      'Death': 'A significant transformation is occurring. Embrace the change as it leads to renewal.',
      'Temperance': 'Balance and moderation are key today. Find the middle path in all things.',
      'The Devil': 'Examine what may be holding you back. Freedom comes from recognizing your chains.',
      'The Tower': 'Sudden revelations may shake your foundations, but they clear the way for truth.',
      'The Star': 'Hope and healing are flowing into your life. Your dreams are closer than you think.',
      'The Moon': 'Trust your intuition over illusions. What is hidden will soon be revealed.',
      'The Sun': 'Joy, success, and vitality shine upon you. Celebrate your achievements.',
      'Judgement': 'A time of reckoning and rebirth. Answer your inner calling with courage.',
      'The World': 'Completion and fulfillment are at hand. You have achieved something significant.',
    };
    
    return reflections[card.name] ?? 'This card brings important guidance for your journey today.';
  }
  
  static String _generateThreeCardReflection(List<TarotCardData> cards) {
    return 'Your past (${cards[0].name}) has shaped your current situation (${cards[1].name}), '
           'and this foundation guides you toward your future (${cards[2].name}). '
           'Reflect on how these energies connect in your life\'s journey.';
  }
}

class TarotCardData {
  final String name;
  final String description;
  final String imageUrl;
  
  const TarotCardData(this.name, this.description, this.imageUrl);
}
