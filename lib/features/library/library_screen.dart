import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/theme/app_theme.dart';
import '../summarizer/summarizer_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../flashcards/flashcard_deck_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

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
              'Library',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 8),

            Text(
              'Your study materials in one place',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 24),

            // Search Bar
            _buildSearchBar().animate().fadeIn(duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 28),

            // Categories
            _buildCategories(context)
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms),

            const SizedBox(height: 28),

            // Recent Files
            _buildRecentFiles(context)
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms),

            const SizedBox(height: 28),

            // Study Collections
            _buildStudyCollections(context)
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 56,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search notes, quizzes, flashcards...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  border: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      {
        'icon': Icons.description_rounded,
        'label': 'Notes',
        'count': 24,
        'color': AppColors.primary
      },
      {
        'icon': Icons.quiz_rounded,
        'label': 'Quizzes',
        'count': 12,
        'color': AppColors.accentPink
      },
      {
        'icon': Icons.style_rounded,
        'label': 'Flashcards',
        'count': 8,
        'color': AppColors.accentOrange
      },
      {
        'icon': Icons.summarize_rounded,
        'label': 'Summaries',
        'count': 15,
        'color': AppColors.accentCyan
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: categories
              .map((cat) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: categories.indexOf(cat) < categories.length - 1
                            ? 12
                            : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (cat['label'] == 'Quizzes') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const QuizListScreen()),
                            );
                          } else if (cat['label'] == 'Flashcards') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const FlashcardDeckScreen()),
                            );
                          } else if (cat['label'] == 'Notes' ||
                              cat['label'] == 'Summaries') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SummarizerScreen()),
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GlassmorphicContainer(
                            width: double.infinity,
                            height: 0,
                            borderRadius: 16,
                            blur: 10,
                            alignment: Alignment.center,
                            border: 1,
                            linearGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Icon(
                                    cat['icon'] as IconData,
                                    color: cat['color'] as Color,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cat['label'] as String,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${cat['count']}',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecentFiles(BuildContext context) {
    final recentFiles = [
      {'name': 'Quantum Physics Notes', 'type': 'PDF', 'date': '2 days ago'},
      {'name': 'Biology Quiz #3', 'type': 'Quiz', 'date': 'Yesterday'},
      {'name': 'Chemistry Flashcards', 'type': 'Flashcards', 'date': 'Today'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Files',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'SEE ALL',
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
        ...recentFiles
            .map((file) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: 0,
                      borderRadius: 16,
                      blur: 10,
                      alignment: Alignment.center,
                      border: 1,
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getFileIcon(file['type'] as String),
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file['name'] as String,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${file['type']} • ${file['date']}',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.more_vert,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildStudyCollections(BuildContext context) {
    final collections = [
      {'name': 'Physics Semester 1', 'items': 15, 'color': AppColors.cardPink},
      {'name': 'Biology Finals', 'items': 22, 'color': AppColors.cardCyan},
      {'name': 'Chemistry Lab', 'items': 8, 'color': AppColors.cardPurple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Study Collections',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (collection['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (collection['color'] as Color).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.folder_rounded,
                      color: collection['color'] as Color,
                      size: 32,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collection['name'] as String,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${collection['items']} items',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'Quiz':
        return Icons.quiz_rounded;
      case 'Flashcards':
        return Icons.style_rounded;
      default:
        return Icons.description_rounded;
    }
  }
}
