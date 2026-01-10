import 'package:flutter/material.dart';

/// Subject model for timetable
class Subject {
  final String id;
  final String name;
  final String topic;
  final String room;
  final Color color;
  final String startTime;
  final String endTime;
  final List<String>? tags;
  final String? deadline;
  final int? participantCount;

  Subject({
    required this.id,
    required this.name,
    required this.topic,
    required this.room,
    required this.color,
    required this.startTime,
    required this.endTime,
    this.tags,
    this.deadline,
    this.participantCount,
  });

  Subject copyWith({
    String? id,
    String? name,
    String? topic,
    String? room,
    Color? color,
    String? startTime,
    String? endTime,
    List<String>? tags,
    String? deadline,
    int? participantCount,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      room: room ?? this.room,
      color: color ?? this.color,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tags: tags ?? this.tags,
      deadline: deadline ?? this.deadline,
      participantCount: participantCount ?? this.participantCount,
    );
  }
}

/// Schedule Item for detailed scheduling
class ScheduleItem {
  final String id;
  final Subject subject;
  final DateTime date;
  final bool isCompleted;

  ScheduleItem({
    required this.id,
    required this.subject,
    required this.date,
    this.isCompleted = false,
  });
}

/// Document model for PDF uploads
class Document {
  final String id;
  final String name;
  final String path;
  final DateTime uploadedAt;
  final Summary? summary;
  final int? pageCount;

  Document({
    required this.id,
    required this.name,
    required this.path,
    required this.uploadedAt,
    this.summary,
    this.pageCount,
  });

  Document copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? uploadedAt,
    Summary? summary,
    int? pageCount,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      summary: summary ?? this.summary,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}

/// Summary model for AI-generated summaries
class Summary {
  final String content;
  final List<String> keyHighlights;
  final List<String> keyConcepts;
  final DateTime generatedAt;

  Summary({
    required this.content,
    required this.keyHighlights,
    required this.keyConcepts,
    required this.generatedAt,
  });
}

/// Quiz model
class Quiz {
  final String id;
  final String title;
  final String module;
  final int totalQuestions;
  final List<Question> questions;
  final String? difficulty;
  final int? timeLimit;

  Quiz({
    required this.id,
    required this.title,
    required this.module,
    required this.totalQuestions,
    required this.questions,
    this.difficulty,
    this.timeLimit,
  });
}

/// Question model for quizzes
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String? hint;
  final String? imageUrl;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.hint,
    this.imageUrl,
  });
}

/// Flashcard Deck model
class FlashcardDeck {
  final String id;
  final String title;
  final int totalCards;
  final List<Flashcard> cards;
  final String? description;
  final Color? color;

  FlashcardDeck({
    required this.id,
    required this.title,
    required this.totalCards,
    required this.cards,
    this.description,
    this.color,
  });

  int get masteredCount => cards.where((c) => c.isMastered).length;
}

/// Flashcard model
class Flashcard {
  final String id;
  final String question;
  final String answer;
  final bool isMastered;
  final bool needsReview;
  final DateTime? lastReviewed;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.isMastered = false,
    this.needsReview = false,
    this.lastReviewed,
  });

  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isMastered,
    bool? needsReview,
    DateTime? lastReviewed,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isMastered: isMastered ?? this.isMastered,
      needsReview: needsReview ?? this.needsReview,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }
}

/// Insight model for Recent Insights section
class Insight {
  final String id;
  final String title;
  final String subtitle;
  final InsightType type;
  final DateTime createdAt;

  Insight({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.createdAt,
  });
}

enum InsightType {
  weakTopic,
  goalAchieved,
  streak,
  recommendation,
}

/// User Progress model
class UserProgress {
  final int totalStudyMinutes;
  final int streakDays;
  final int quizzesCompleted;
  final int flashcardsReviewed;
  final double averageScore;

  UserProgress({
    required this.totalStudyMinutes,
    required this.streakDays,
    required this.quizzesCompleted,
    required this.flashcardsReviewed,
    required this.averageScore,
  });
}
