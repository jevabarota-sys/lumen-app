import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: '1',
      authorName: 'Sarah M.',
      content: 'Just completed my first month of daily tarot draws and the insights have been incredible! The AI reflections really help me understand the deeper meanings.',
      likes: 24,
      timeAgo: '2 hours ago',
      isLiked: false,
    ),
    CommunityPost(
      id: '2',
      authorName: 'Michael R.',
      content: 'My life path number 7 reading was so accurate. The daily activities suggested really align with my spiritual journey. Grateful for this community! 🙏',
      likes: 18,
      timeAgo: '5 hours ago',
      isLiked: true,
    ),
    CommunityPost(
      id: '3',
      authorName: 'Emma L.',
      content: 'The journal feature with AI insights has helped me recognize patterns in my thoughts I never noticed before. This app is truly transformative.',
      likes: 31,
      timeAgo: '1 day ago',
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewPostDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _posts.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildWelcomeCard();
            }
            return _buildPostCard(_posts[index - 1], index - 1);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewPostDialog,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people,
                    color: AppTheme.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Welcome to the Community',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Share your journey, insights, and connect with others on their path of personal growth. All posts are moderated to ensure a safe and supportive environment.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutral,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  size: 16,
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'AI Moderated for Safety',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 600));
  }

  Widget _buildPostCard(CommunityPost post, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  child: Text(
                    post.authorName[0],
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: AppTheme.neutral),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'report',
                      child: Text('Report'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                InkWell(
                  onTap: () => _toggleLike(post),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? AppTheme.accent : AppTheme.neutral,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: post.isLiked ? AppTheme.accent : AppTheme.neutral,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: AppTheme.neutral,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reply',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutral,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().slideX(
      begin: index % 2 == 0 ? -0.3 : 0.3,
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: index * 100),
    );
  }

  void _toggleLike(CommunityPost post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
  }

  void _showNewPostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewPostSheet(
        onPost: (content) {
          final newPost = CommunityPost(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            authorName: 'You',
            content: content,
            likes: 0,
            timeAgo: 'Just now',
            isLiked: false,
          );
          
          setState(() {
            _posts.insert(0, newPost);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your post is being reviewed and will appear soon!'),
              backgroundColor: AppTheme.secondary,
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

class CommunityPost {
  final String id;
  final String authorName;
  final String content;
  int likes;
  final String timeAgo;
  bool isLiked;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.content,
    required this.likes,
    required this.timeAgo,
    required this.isLiked,
  });
}

class _NewPostSheet extends StatefulWidget {
  final Function(String content) onPost;

  const _NewPostSheet({required this.onPost});

  @override
  State<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<_NewPostSheet> {
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.neutral.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Share with Community',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _postContent,
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Posts are reviewed by AI moderation before appearing in the community feed.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Share your insights, experiences, or ask for guidance...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _postContent() {
    if (_contentController.text.trim().isNotEmpty) {
      widget.onPost(_contentController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
