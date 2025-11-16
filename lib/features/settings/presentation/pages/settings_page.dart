import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../premium/providers/iap_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdateController = TextEditingController();
  
  bool _isLoading = true;
  DateTime? _selectedBirthdate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      final supabase = SupabaseService.client;
      final user = supabase.auth.currentUser;
      
      if (user != null) {
        _emailController.text = user.email ?? '';
        
        // Load user profile data from database
        final response = await supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .maybeSingle();
        
        if (response != null) {
          _nameController.text = response['name'] ?? '';
          if (response['birthdate'] != null) {
            _selectedBirthdate = DateTime.parse(response['birthdate']);
            _birthdateController.text = _formatDate(_selectedBirthdate!);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.white,
              surface: AppTheme.surface,
              onSurface: AppTheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your name', isError: true);
      return;
    }

    if (_selectedBirthdate == null) {
      _showSnackBar('Please select your birthdate', isError: true);
      return;
    }

    try {
      final supabase = SupabaseService.client;
      final user = supabase.auth.currentUser;
      
      if (user != null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': user.email,
          'name': _nameController.text.trim(),
          'birthdate': _selectedBirthdate!.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        
        _showSnackBar('Profile updated successfully!');
      }
    } catch (e) {
      _showSnackBar('Failed to update profile: $e', isError: true);
    }
  }

  Future<void> _exportJournalToPDF() async {
    final isPremiumAsync = ref.read(isPremiumProvider);
    final isPremium = isPremiumAsync.value ?? false;
    
    if (!isPremium) {
      _showUpgradeDialog();
      return;
    }

    // TODO: Implement PDF export functionality
    _showSnackBar('PDF export feature coming soon!');
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and will permanently delete all your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final supabase = SupabaseService.client;
        final user = supabase.auth.currentUser;
        
        if (user != null) {
          // Delete user data from database
          await supabase.from('users').delete().eq('id', user.id);
          
          // Sign out
          await supabase.auth.signOut();
          
          if (mounted) {
            context.go(AppRoutes.auth);
          }
        }
      } catch (e) {
        _showSnackBar('Failed to delete account: $e', isError: true);
      }
    }
  }

  Future<void> _signOut() async {
    try {
      final supabase = SupabaseService.client;
      await supabase.auth.signOut();
      
      if (mounted) {
        context.go(AppRoutes.auth);
      }
    } catch (e) {
      _showSnackBar('Failed to sign out: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.error : AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'Journal PDF export is a Premium feature.\n\nUpgrade to Premium to export your journal entries as PDF files.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.premium);
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Settings & Profile'),
        backgroundColor: AppTheme.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Text(
                    'Profile Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _birthdateController,
                            decoration: const InputDecoration(
                              labelText: 'Birthdate',
                              prefixIcon: Icon(Icons.cake_outlined),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: _selectBirthdate,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: AppTheme.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Save Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Premium Status
                  isPremiumAsync.when(
                    data: (isPremium) => Card(
                      color: isPremium 
                          ? AppTheme.success.withOpacity(0.1)
                          : AppTheme.neutral.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              isPremium ? Icons.star : Icons.star_border,
                              color: isPremium ? AppTheme.success : AppTheme.neutral,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isPremium ? 'Premium Member' : 'Free Plan',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isPremium ? AppTheme.success : AppTheme.onSurface,
                                        ),
                                  ),
                                  Text(
                                    isPremium 
                                        ? 'You have access to all features'
                                        : 'Upgrade to unlock all features',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.neutral,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isPremium)
                              ElevatedButton(
                                onPressed: () => context.push(AppRoutes.premium),
                                child: const Text('Upgrade'),
                              ),
                          ],
                        ),
                      ),
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),

                  const SizedBox(height: 32),

                  // Data & Privacy Section
                  Text(
                    'Data & Privacy',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildSettingsItem(
                    icon: Icons.picture_as_pdf,
                    title: 'Export Journal to PDF',
                    subtitle: 'Download all your journal entries',
                    onTap: _exportJournalToPDF,
                    isPremiumFeature: true,
                  ),

                  const SizedBox(height: 32),

                  // Account Actions Section
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildSettingsItem(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'Sign out of your account',
                    onTap: _signOut,
                  ),

                  _buildSettingsItem(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    subtitle: 'Permanently delete your account and data',
                    onTap: _deleteAccount,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPremiumFeature = false,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppTheme.error.withOpacity(0.1)
                      : AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? AppTheme.error : AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDestructive ? AppTheme.error : null,
                              ),
                        ),
                        if (isPremiumFeature) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Premium',
                              style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutral,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.neutral,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
