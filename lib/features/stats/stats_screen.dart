import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Statistics',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 8),

            Text(
              'Track your learning progress',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 24),

            // Overall Progress Card
            _buildOverallProgressCard()
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 24),

            // Weekly Activity
            _buildWeeklyActivity()
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms),

            const SizedBox(height: 24),

            // Stats Grid
            _buildStatsGrid().animate().fadeIn(duration: 400.ms, delay: 400.ms),

            const SizedBox(height: 24),

            // Subject Performance
            _buildSubjectPerformance()
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    return GradientCard(
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 10,
            percent: 0.78,
            center: const Text(
              '78%',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.surfaceLight,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re doing great! Keep up the momentum.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMiniStat('📚', '24', 'Topics'),
                    const SizedBox(width: 20),
                    _buildMiniStat('⏱️', '48h', 'Study Time'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String emoji, String value, String label) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyActivity() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final heights = [0.6, 0.8, 0.4, 0.9, 0.7, 0.3, 0.5];

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Activity',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final isToday = index == 4;
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 100 * heights[index],
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? AppColors.primaryGradient
                          : LinearGradient(
                              colors: [
                                AppColors.surfaceLight,
                                AppColors.surfaceLight,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isToday ? AppColors.primary : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'icon': Icons.local_fire_department_rounded,
        'value': '10',
        'label': 'Day Streak',
        'color': AppColors.accentOrange
      },
      {
        'icon': Icons.quiz_rounded,
        'value': '45',
        'label': 'Quizzes Done',
        'color': AppColors.accentPink
      },
      {
        'icon': Icons.style_rounded,
        'value': '120',
        'label': 'Cards Reviewed',
        'color': AppColors.accentCyan
      },
      {
        'icon': Icons.timer_rounded,
        'value': '8.5h',
        'label': 'This Week',
        'color': AppColors.primary
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: stats
          .map((stat) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (stat['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        color: stat['color'] as Color,
                        size: 20,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat['value'] as String,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stat['label'] as String,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSubjectPerformance() {
    final subjects = [
      {'name': 'Physics', 'progress': 0.85, 'color': AppColors.cardPink},
      {'name': 'Biology', 'progress': 0.72, 'color': AppColors.cardCyan},
      {'name': 'Chemistry', 'progress': 0.68, 'color': AppColors.cardPurple},
      {'name': 'Mathematics', 'progress': 0.91, 'color': AppColors.accentGreen},
    ];

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subject Performance',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...subjects
              .map((subject) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subject['name'] as String,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${((subject['progress'] as double) * 100).toInt()}%',
                              style: TextStyle(
                                color: subject['color'] as Color,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomProgressBar(
                          progress: subject['progress'] as double,
                          progressColor: subject['color'] as Color,
                          height: 6,
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
