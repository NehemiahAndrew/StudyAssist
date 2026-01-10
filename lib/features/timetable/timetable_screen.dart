import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/app_provider.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/models/models.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),

              // Week Days
              _buildWeekDays(timetableProvider)
                  .animate()
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // Today's Subjects Header
              _buildTodaysHeader(timetableProvider)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms),

              // Schedule List
              Expanded(
                child: timetableProvider.subjects.isEmpty
                    ? _buildEmptyState(timetableProvider)
                    : _buildScheduleList(timetableProvider)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(context, timetableProvider),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLANNER',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'My Schedule',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays(TimetableProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final dayIndex = index + 1; // 1=Monday, 5=Friday
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.setSelectedDay(dayIndex),
              child: Container(
                margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: provider.selectedDayIndex == dayIndex
                      ? AppColors.primaryGradient
                      : null,
                  color: provider.selectedDayIndex == dayIndex
                      ? null
                      : AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: provider.selectedDayIndex == dayIndex
                        ? AppColors.primary.withOpacity(0.5)
                        : Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _weekDays[index],
                      style: TextStyle(
                        color: provider.selectedDayIndex == dayIndex
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (provider.subjectsByDay[dayIndex]?.isNotEmpty ?? false)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: provider.selectedDayIndex == dayIndex
                              ? Colors.white
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTodaysHeader(TimetableProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${provider.getDayName(provider.selectedDayIndex)}'s Subjects",
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${provider.subjects.length} ${provider.subjects.length == 1 ? 'Lesson' : 'Lessons'}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TimetableProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No subjects for ${provider.getDayName(provider.selectedDayIndex)}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a subject',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(TimetableProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.subjects.length,
      itemBuilder: (context, index) {
        final subject = provider.subjects[index];
        return Dismissible(
          key: Key(subject.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.accentRed,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            provider.removeSubjectFromDay(
                provider.selectedDayIndex, subject.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${subject.name} removed'),
                backgroundColor: AppColors.backgroundCard,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: _buildTimelineItem(
              subject, index == provider.subjects.length - 1),
        );
      },
    );
  }

  Widget _buildTimelineItem(subject, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.surfaceLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScheduleCard(
                  subject: subject.name,
                  topic: subject.topic,
                  room: subject.room,
                  color: subject.color,
                  tags: subject.tags,
                  deadline: subject.deadline,
                  participantCount: null,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Nav items
            Expanded(
              child: Row(
                children: [
                  _buildNavItem(Icons.grid_view_rounded, true),
                  const SizedBox(width: 32),
                  _buildNavItem(Icons.menu_book_rounded, false),
                ],
              ),
            ),

            // AI Suggest Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI Suggest',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, TimetableProvider provider) {
    return FloatingActionButton(
      onPressed: () => _showAddSubjectDialog(context, provider),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showAddSubjectDialog(BuildContext context, TimetableProvider provider) {
    final nameController = TextEditingController();
    final topicController = TextEditingController();
    Color selectedColor = AppColors.cardPink;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Add Subject - ${provider.getDayName(provider.selectedDayIndex)}',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Subject Name', Icons.book),
              const SizedBox(height: 12),
              _buildTextField(topicController, 'Topic', Icons.topic),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color:',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  ...[
                    AppColors.cardPink,
                    AppColors.cardCyan,
                    AppColors.cardPurple,
                    AppColors.cardBlue,
                  ].map((color) => GestureDetector(
                        onTap: () => selectedColor = color,
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final subject = Subject(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  topic: topicController.text.isEmpty
                      ? 'General'
                      : topicController.text,
                  room: '',
                  color: selectedColor,
                  startTime: '',
                  endTime: '',
                );
                provider.addSubjectToDay(provider.selectedDayIndex, subject);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Subject'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Icon(
      icon,
      color: isSelected ? AppColors.primary : AppColors.textMuted,
      size: 24,
    );
  }
}
