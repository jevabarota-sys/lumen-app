import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../shared/models/journal_entry_model.dart';
import '../../../core/utils/sentiment_analyzer.dart';

class JournalService {
  static final SupabaseClient _supabase = SupabaseService.client;

  /// Fetch all journal entries for the current user
  static Future<List<JournalEntryModel>> fetchEntries() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('journal_entries')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => JournalEntryModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching journal entries: $e');
      rethrow;
    }
  }

  /// Fetch recent journal entries (last N days)
  static Future<List<JournalEntryModel>> fetchRecentEntries({int days = 7}) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final response = await _supabase
          .from('journal_entries')
          .select()
          .eq('user_id', userId)
          .gte('created_at', cutoffDate.toIso8601String())
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => JournalEntryModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching recent journal entries: $e');
      rethrow;
    }
  }

  /// Create a new journal entry with AI analysis
  static Future<JournalEntryModel> createEntry({
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Analyze sentiment
      final sentimentResult = SentimentAnalyzer.analyzeSentiment(content);
      
      // Generate AI summary
      final aiSummary = _generateAISummary(content, sentimentResult);
      
      // Generate AI affirmations
      final aiAffirmations = _generateAIAffirmations(content, sentimentResult);

      final now = DateTime.now();
      final entryData = {
        'user_id': userId,
        'title': title,
        'content': content,
        'tags': tags,
        'ai_summary': aiSummary,
        'ai_affirmations': aiAffirmations,
        'sentiment_score': sentimentResult['score'],
        'dominant_emotion': sentimentResult['dominantEmotion'],
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from('journal_entries')
          .insert(entryData)
          .select()
          .single();

      return JournalEntryModel.fromJson(response);
    } catch (e) {
      print('Error creating journal entry: $e');
      rethrow;
    }
  }

  /// Update an existing journal entry
  static Future<JournalEntryModel> updateEntry({
    required String id,
    String? title,
    String? content,
    List<String>? tags,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updateData['title'] = title;
      if (tags != null) updateData['tags'] = tags;
      
      if (content != null) {
        updateData['content'] = content;
        
        // Re-analyze sentiment if content changed
        final sentimentResult = SentimentAnalyzer.analyzeSentiment(content);
        updateData['ai_summary'] = _generateAISummary(content, sentimentResult);
        updateData['ai_affirmations'] = _generateAIAffirmations(content, sentimentResult);
        updateData['sentiment_score'] = sentimentResult['score'];
        updateData['dominant_emotion'] = sentimentResult['dominantEmotion'];
      }

      final response = await _supabase
          .from('journal_entries')
          .update(updateData)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      return JournalEntryModel.fromJson(response);
    } catch (e) {
      print('Error updating journal entry: $e');
      rethrow;
    }
  }

  /// Delete a journal entry
  static Future<void> deleteEntry(String id) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('journal_entries')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      print('Error deleting journal entry: $e');
      rethrow;
    }
  }

  /// Get sentiment analysis for recent entries
  static Future<Map<String, dynamic>> getSentimentAnalysis({int days = 30}) async {
    try {
      final entries = await fetchRecentEntries(days: days);
      
      if (entries.isEmpty) {
        return {
          'averageScore': 0.0,
          'trend': 'neutral',
          'dominantEmotions': <String>[],
          'entryCount': 0,
        };
      }

      // Calculate average sentiment
      double totalScore = 0;
      final emotions = <String>[];
      
      for (final entry in entries) {
        final sentiment = SentimentAnalyzer.analyzeSentiment(entry.content);
        totalScore += sentiment['score'] as double;
        final emotion = sentiment['dominantEmotion'] as String?;
        if (emotion != null) emotions.add(emotion);
      }

      final averageScore = totalScore / entries.length;
      
      // Determine trend (compare first half vs second half)
      String trend = 'stable';
      if (entries.length >= 4) {
        final midpoint = entries.length ~/ 2;
        final recentEntries = entries.sublist(0, midpoint);
        final olderEntries = entries.sublist(midpoint);
        
        double recentScore = 0;
        double olderScore = 0;
        
        for (final entry in recentEntries) {
          final sentiment = SentimentAnalyzer.analyzeSentiment(entry.content);
          recentScore += sentiment['score'] as double;
        }
        
        for (final entry in olderEntries) {
          final sentiment = SentimentAnalyzer.analyzeSentiment(entry.content);
          olderScore += sentiment['score'] as double;
        }
        
        recentScore /= recentEntries.length;
        olderScore /= olderEntries.length;
        
        if (recentScore > olderScore + 0.1) {
          trend = 'improving';
        } else if (recentScore < olderScore - 0.1) {
          trend = 'declining';
        }
      }

      // Get most common emotions
      final emotionCounts = <String, int>{};
      for (final emotion in emotions) {
        emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      }
      
      final sortedEmotions = emotionCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      final dominantEmotions = sortedEmotions
          .take(3)
          .map((e) => e.key)
          .toList();

      return {
        'averageScore': averageScore,
        'trend': trend,
        'dominantEmotions': dominantEmotions,
        'entryCount': entries.length,
      };
    } catch (e) {
      print('Error getting sentiment analysis: $e');
      return {
        'averageScore': 0.0,
        'trend': 'neutral',
        'dominantEmotions': <String>[],
        'entryCount': 0,
      };
    }
  }

  static String _generateAISummary(String content, Map<String, dynamic> sentiment) {
    final score = sentiment['score'] as double;
    final emotion = sentiment['dominantEmotion'] as String?;
    
    if (score > 0.3) {
      if (emotion == 'joy' || emotion == 'gratitude') {
        return 'This entry radiates positive energy and appreciation. You\'re experiencing a beautiful moment of gratitude and joy.';
      } else if (emotion == 'love') {
        return 'This entry reflects deep connection and love. Your heart is open and full.';
      } else {
        return 'This entry captures a positive and uplifting moment in your journey. Your energy is bright.';
      }
    } else if (score < -0.3) {
      if (emotion == 'sadness') {
        return 'This entry explores feelings of sadness. Remember, acknowledging these emotions is part of healing.';
      } else if (emotion == 'anxiety' || emotion == 'fear') {
        return 'This entry reveals some worry or concern. It\'s brave to face these feelings and write them down.';
      } else if (emotion == 'anger') {
        return 'This entry expresses frustration or anger. These feelings are valid and deserve to be heard.';
      } else {
        return 'This entry explores some challenging emotions. You\'re showing courage by processing these feelings.';
      }
    } else {
      if (content.toLowerCase().contains('meditation') || content.toLowerCase().contains('spiritual')) {
        return 'This entry reflects spiritual exploration and inner work. You\'re connecting with your deeper self.';
      } else if (content.toLowerCase().contains('goal') || content.toLowerCase().contains('plan')) {
        return 'This entry shows thoughtful planning and intention-setting. You\'re taking charge of your path.';
      } else {
        return 'This entry captures important reflections on your personal journey. Every thought matters.';
      }
    }
  }

  static List<String> _generateAIAffirmations(String content, Map<String, dynamic> sentiment) {
    final score = sentiment['score'] as double;
    final emotion = sentiment['dominantEmotion'] as String?;
    
    if (score > 0.3) {
      return [
        'I embrace the joy and positivity flowing through my life',
        'I am grateful for all the abundance surrounding me',
        'My positive energy attracts more blessings into my life',
      ];
    } else if (score < -0.3) {
      if (emotion == 'sadness') {
        return [
          'I allow myself to feel and heal at my own pace',
          'This too shall pass, and I am stronger than I know',
          'I am worthy of love and compassion, especially from myself',
        ];
      } else if (emotion == 'anxiety' || emotion == 'fear') {
        return [
          'I am safe, grounded, and capable of handling what comes',
          'I release worry and trust in the unfolding of my path',
          'I breathe deeply and find peace in this present moment',
        ];
      } else if (emotion == 'anger') {
        return [
          'I acknowledge my feelings and choose how to respond',
          'I release what no longer serves me with love and grace',
          'I am in control of my reactions and my peace',
        ];
      } else {
        return [
          'I am resilient and capable of navigating any challenge',
          'Every experience is teaching me and helping me grow',
          'I trust myself to handle whatever life brings',
        ];
      }
    } else {
      return [
        'I am exactly where I need to be on my journey',
        'I trust the process of my personal growth',
        'Every day I am becoming more aligned with my true self',
      ];
    }
  }
}
