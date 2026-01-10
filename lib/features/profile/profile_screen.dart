import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader().animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 32),

            // Achievements
            _buildAchievements()
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 24),

            // Settings Options
            _buildSettingsSection()
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms),

            const SizedBox(height: 24),

            // Upgrade Card
            _buildUpgradeCard()
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms),

            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton()
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Alex Sterling',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'alex.sterling@university.edu',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileStat('24', 'Topics'),
            Container(
              height: 30,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.surfaceLight,
            ),
            _buildProfileStat('10', 'Day Streak'),
            Container(
              height: 30,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.surfaceLight,
            ),
            _buildProfileStat('78%', 'Score'),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {'icon': '🏆', 'label': 'Top Scorer'},
      {'icon': '🔥', 'label': '10 Day Streak'},
      {'icon': '📚', 'label': 'Bookworm'},
      {'icon': '⭐', 'label': 'Quiz Master'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'VIEW ALL',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: achievements
              .map((achievement) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          achievement['icon'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          achievement['label'] as String,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    final settings = [
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'subtitle': 'Manage alerts'
      },
      {
        'icon': Icons.dark_mode_outlined,
        'title': 'Appearance',
        'subtitle': 'Dark mode'
      },
      {
        'icon': Icons.language_outlined,
        'title': 'Language',
        'subtitle': 'English'
      },
      {
        'icon': Icons.cloud_sync_outlined,
        'title': 'Cloud Sync',
        'subtitle': 'Connected'
      },
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Help & Support',
        'subtitle': 'FAQ, Contact'
      },
      {
        'icon': Icons.info_outline_rounded,
        'title': 'About',
        'subtitle': 'Version 1.0.0'
      },
    ];

    return GradientCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: settings
            .map((setting) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      setting['icon'] as IconData,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    setting['title'] as String,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    setting['subtitle'] as String,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                  ),
                  onTap: () {},
                ))
            .toList(),
      ),
    );
  }

  Widget _buildUpgradeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Unlimited AI processing & cloud sync',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'JOIN NOW',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, color: AppColors.accentRed),
        label: const Text(
          'Log Out',
          style: TextStyle(color: AppColors.accentRed),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accentRed),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
