import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ai_advisor.dart';

class AskLumenPage extends StatefulWidget {
  const AskLumenPage({super.key});

  @override
  State<AskLumenPage> createState() => _AskLumenPageState();
}

class _AskLumenPageState extends State<AskLumenPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Hello! I\'m Lumen, your AI companion for personal growth and spiritual guidance. Ask me anything about:\n\n• Life path and numerology insights\n• Tarot and angel card meanings\n• Manifestation and goal setting\n• Relationships and communication\n• Self-care and emotional wellness\n• Spiritual practices and meditation\n\nHow can I support your journey today?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ask Lumen'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearConversation,
            tooltip: 'Start new conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.psychology,
                size: 60,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ask Lumen Anything',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI companion for personal growth, spiritual guidance, and life insights.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.onBackground.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message, index);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppTheme.primary
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isUser)
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 16,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lumen',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  if (!message.isUser) const SizedBox(height: 8),
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: message.isUser
                              ? AppTheme.white
                              : AppTheme.onSurface,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 50),
        );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask me anything...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                        ),
                      )
                    : const Icon(Icons.send, color: AppTheme.white),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Generate AI response
      final response = await _generateAIResponse(text);

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'I apologize, but I\'m having trouble responding right now. Please try again in a moment.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }
  }

  Future<String> _generateAIResponse(String userMessage) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final lowerMessage = userMessage.toLowerCase();

    // Numerology questions
    if (lowerMessage.contains('life path') || lowerMessage.contains('numerology')) {
      return 'Your life path number is a powerful guide to understanding your soul\'s purpose. It\'s calculated from your birth date and reveals your natural talents, challenges, and the lessons you\'re here to learn.\n\nTo discover your life path number, visit the Numerology section in the app menu. Once you know your number, I can provide deeper insights about your unique journey and how to align with your highest potential.';
    }

    // Tarot questions
    if (lowerMessage.contains('tarot') || lowerMessage.contains('card')) {
      return 'Tarot cards are a beautiful tool for self-reflection and guidance. Each card carries archetypal wisdom that can illuminate your path forward.\n\nI recommend doing a 3-card spread when you\'re seeking clarity on a situation. The cards represent past influences, present energy, and future potential. Visit the Tarot section to draw your cards, and I\'ll help you interpret their deeper meaning in the context of your life.';
    }

    // Manifestation questions
    if (lowerMessage.contains('manifest') || lowerMessage.contains('369')) {
      return 'The 369 manifestation method is a powerful practice based on Nikola Tesla\'s belief in the significance of these numbers. Here\'s how it works:\n\n• Write your manifestation 3 times in the morning\n• Write it 6 times in the afternoon\n• Write it 9 times in the evening\n\nDo this for 33 or 45 days consistently. The key is to write with intention and feeling, as if your desire has already manifested. Visit the 369 Manifestation section to set up your daily reminders and track your practice.';
    }

    // Relationship questions
    if (lowerMessage.contains('relationship') || lowerMessage.contains('partner') || lowerMessage.contains('love')) {
      return 'Relationships are mirrors that reflect our inner world and offer opportunities for profound growth. Whether you\'re navigating challenges or deepening connection, remember:\n\n• Communication starts with understanding yourself first\n• Healthy boundaries honor both people\'s needs\n• Love is both a feeling and a daily choice\n• Compatibility includes shared values and mutual respect\n\nWhat specific aspect of your relationship would you like guidance on? I\'m here to help you navigate with wisdom and compassion.';
    }

    // Self-care and wellness
    if (lowerMessage.contains('self-care') || lowerMessage.contains('wellness') || lowerMessage.contains('stress') || lowerMessage.contains('anxiety')) {
      return 'Self-care isn\'t selfish—it\'s essential. When you\'re feeling overwhelmed, try this grounding practice:\n\n1. Take 5 deep breaths, focusing on the exhale\n2. Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste\n3. Place your hand on your heart and say: "I am safe, I am enough, I am worthy of rest"\n\nRemember, you can\'t pour from an empty cup. Check your Today\'s Focus card for personalized daily guidance, and visit the Journal to process your feelings with AI-powered insights.';
    }

    // Meditation and spiritual practice
    if (lowerMessage.contains('meditat') || lowerMessage.contains('spiritual') || lowerMessage.contains('practice')) {
      return 'Meditation is a journey inward, a practice of coming home to yourself. There\'s no "perfect" way to meditate—what matters is consistency and self-compassion.\n\nFor beginners, I recommend:\n• Start with just 5 minutes daily\n• Focus on your breath or use a guided meditation\n• Notice thoughts without judgment, then return to your breath\n• Practice at the same time each day to build the habit\n\nYour spiritual practice is unique to you. Trust what resonates and let go of what doesn\'t. The path unfolds one mindful moment at a time.';
    }

    // Journal and reflection
    if (lowerMessage.contains('journal') || lowerMessage.contains('write') || lowerMessage.contains('reflect')) {
      return 'Journaling is a powerful tool for self-discovery and emotional processing. When you write, you create space between your thoughts and your reactions, allowing wisdom to emerge.\n\nTry these prompts:\n• What am I grateful for today?\n• What emotions am I feeling, and what are they trying to tell me?\n• What would I do if I trusted myself completely?\n• What lesson is this situation teaching me?\n\nUse the AI Reflection Journal in the app to receive personalized insights and affirmations based on your entries. Your words hold power—honor them.';
    }

    // Default response with general wisdom
    return AIAdvisor.generateAdvice(
      topic: 'general_guidance',
      context: userMessage,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConversation() {
    setState(() {
      _messages.clear();
      _addWelcomeMessage();
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
