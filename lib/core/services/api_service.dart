import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// API Service for communicating with the Python AI Backend
class ApiService {
  // Change this to your backend URL
  static const String baseUrl = 'http://localhost:8000/api/v1';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Upload a PDF file and get extracted text (web-compatible)
  Future<Map<String, dynamic>> uploadPdfBytes(
      List<int> bytes, String fileName) async {
    try {
      print('📤 Uploading to: $baseUrl/upload-pdf'); // Debug
      final uri = Uri.parse('$baseUrl/upload-pdf');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );

      print('⏳ Sending request...'); // Debug
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('Upload timeout - backend not responding'),
          );

      print('📥 Got response: ${streamedResponse.statusCode}'); // Debug
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('✅ Upload successful'); // Debug
        return json.decode(response.body);
      } else {
        print('❌ Upload failed: ${response.body}'); // Debug
        throw Exception(
            'Failed to upload PDF (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('❌ Upload error: $e'); // Debug
      throw Exception('Error uploading PDF: $e');
    }
  }

  /// Upload a PDF file and get extracted text (legacy - desktop only)
  Future<Map<String, dynamic>> uploadPdf(File file) async {
    try {
      print('📤 Uploading to: $baseUrl/upload-pdf'); // Debug
      final uri = Uri.parse('$baseUrl/upload-pdf');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      print('⏳ Sending request...'); // Debug
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('Upload timeout - backend not responding'),
          );

      print('📥 Got response: ${streamedResponse.statusCode}'); // Debug
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('✅ Upload successful'); // Debug
        return json.decode(response.body);
      } else {
        print('❌ Upload failed: ${response.body}'); // Debug
        throw Exception(
            'Failed to upload PDF (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('❌ Upload error: $e'); // Debug
      throw Exception('Error uploading PDF: $e');
    }
  }

  /// Summarize text using AI
  Future<SummaryResult> summarizeText(String text,
      {int maxLength = 500, int minLength = 200}) async {
    try {
      print('📝 Summarizing text (${text.length} chars)...'); // Debug
      final uri = Uri.parse('$baseUrl/summarize');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'text': text,
              'max_length': maxLength,
              'min_length': minLength,
            }),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw Exception('Summarization timeout'),
          );

      print('📥 Summarize response: ${response.statusCode}'); // Debug
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Summary generated'); // Debug
        return SummaryResult.fromJson(data);
      } else {
        print('❌ Summarize failed: ${response.body}'); // Debug
        throw Exception(
            'Failed to summarize (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('❌ Summarize error: $e'); // Debug
      throw Exception('Error summarizing text: $e');
    }
  }

  /// Generate quiz questions from text
  Future<QuizResult> generateQuiz(String text,
      {int numQuestions = 5, String difficulty = 'medium'}) async {
    try {
      final uri = Uri.parse('$baseUrl/generate-quiz');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': text,
          'num_questions': numQuestions,
          'difficulty': difficulty,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuizResult.fromJson(data);
      } else {
        throw Exception('Failed to generate quiz: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating quiz: $e');
    }
  }

  /// Generate flashcards from text
  Future<FlashcardResult> generateFlashcards(String text,
      {int numCards = 10}) async {
    try {
      final uri = Uri.parse('$baseUrl/generate-flashcards');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': text,
          'num_cards': numCards,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FlashcardResult.fromJson(data);
      } else {
        throw Exception('Failed to generate flashcards: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating flashcards: $e');
    }
  }

  /// Extract keywords from text
  Future<List<String>> extractKeywords(String text) async {
    try {
      final uri = Uri.parse('$baseUrl/extract-keywords');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['keywords']);
      } else {
        throw Exception('Failed to extract keywords: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error extracting keywords: $e');
    }
  }

  /// Complete document processing pipeline
  Future<DocumentProcessResult> processDocument(File file) async {
    try {
      final uri = Uri.parse('$baseUrl/process-document');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DocumentProcessResult.fromJson(data);
      } else {
        throw Exception('Failed to process document: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error processing document: $e');
    }
  }

  /// Check if backend is available
  Future<bool> healthCheck() async {
    try {
      final uri = Uri.parse(baseUrl.replaceAll('/api/v1', '/'));
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// ==================== Response Models ====================

class SummaryResult {
  final String summary;
  final List<String> keyConcepts;
  final int wordCount;

  SummaryResult({
    required this.summary,
    required this.keyConcepts,
    required this.wordCount,
  });

  factory SummaryResult.fromJson(Map<String, dynamic> json) {
    return SummaryResult(
      summary: json['summary'],
      keyConcepts: List<String>.from(json['key_concepts']),
      wordCount: json['word_count'],
    );
  }
}

class QuizResult {
  final List<QuizQuestion> questions;
  final String topic;

  QuizResult({
    required this.questions,
    required this.topic,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      questions: (json['questions'] as List)
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      topic: json['topic'],
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'],
    );
  }
}

class FlashcardResult {
  final List<FlashcardItem> flashcards;
  final String topic;

  FlashcardResult({
    required this.flashcards,
    required this.topic,
  });

  factory FlashcardResult.fromJson(Map<String, dynamic> json) {
    return FlashcardResult(
      flashcards: (json['flashcards'] as List)
          .map((f) => FlashcardItem.fromJson(f))
          .toList(),
      topic: json['topic'],
    );
  }
}

class FlashcardItem {
  final String question;
  final String answer;

  FlashcardItem({
    required this.question,
    required this.answer,
  });

  factory FlashcardItem.fromJson(Map<String, dynamic> json) {
    return FlashcardItem(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class DocumentProcessResult {
  final String status;
  final String filename;
  final SummaryResult summary;
  final List<String> keywords;
  final QuizResult quiz;
  final FlashcardResult flashcards;

  DocumentProcessResult({
    required this.status,
    required this.filename,
    required this.summary,
    required this.keywords,
    required this.quiz,
    required this.flashcards,
  });

  factory DocumentProcessResult.fromJson(Map<String, dynamic> json) {
    return DocumentProcessResult(
      status: json['status'],
      filename: json['filename'],
      summary: SummaryResult(
        summary: json['summary']['text'],
        keyConcepts: [],
        wordCount: json['summary']['word_count'],
      ),
      keywords: List<String>.from(json['keywords']),
      quiz: QuizResult(
        questions: (json['quiz']['questions'] as List)
            .map((q) => QuizQuestion.fromJson(q))
            .toList(),
        topic: 'Document',
      ),
      flashcards: FlashcardResult(
        flashcards: (json['flashcards']['cards'] as List)
            .map((f) => FlashcardItem.fromJson(f))
            .toList(),
        topic: 'Document',
      ),
    );
  }
}
