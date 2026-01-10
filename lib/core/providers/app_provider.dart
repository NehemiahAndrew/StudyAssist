import 'package:flutter/material.dart';
import '../models/models.dart';

/// Main App Provider for global state management
class AppProvider extends ChangeNotifier {
  String _userName = 'Alex Sterling';
  int _currentNavIndex = 0;
  bool _isLoading = false;
  double _dailyStudyGoal = 0.75;

  // Getters
  String get userName => _userName;
  int get currentNavIndex => _currentNavIndex;
  bool get isLoading => _isLoading;
  double get dailyStudyGoal => _dailyStudyGoal;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // Setters
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateDailyGoal(double value) {
    _dailyStudyGoal = value;
    notifyListeners();
  }
}

/// Timetable Provider for schedule management
class TimetableProvider extends ChangeNotifier {
  // Store subjects by day of week (1 = Monday, 5 = Friday)
  Map<int, List<Subject>> _subjectsByDay = {
    1: [], // Monday
    2: [], // Tuesday
    3: [], // Wednesday
    4: [], // Thursday
    5: [], // Friday
  };
  int _selectedDayIndex = 1; // Monday by default

  Map<int, List<Subject>> get subjectsByDay => _subjectsByDay;
  int get selectedDayIndex => _selectedDayIndex;
  List<Subject> get subjects => _subjectsByDay[_selectedDayIndex] ?? [];

  TimetableProvider();

  void setSelectedDay(int dayIndex) {
    if (dayIndex >= 1 && dayIndex <= 5) {
      _selectedDayIndex = dayIndex;
      notifyListeners();
    }
  }

  void addSubjectToDay(int dayIndex, Subject subject) {
    if (dayIndex >= 1 && dayIndex <= 5) {
      _subjectsByDay[dayIndex]?.add(subject);
      notifyListeners();
    }
  }

  void removeSubjectFromDay(int dayIndex, String subjectId) {
    if (dayIndex >= 1 && dayIndex <= 5) {
      _subjectsByDay[dayIndex]?.removeWhere((s) => s.id == subjectId);
      notifyListeners();
    }
  }

  void updateSubject(int dayIndex, String subjectId, Subject updatedSubject) {
    if (dayIndex >= 1 && dayIndex <= 5) {
      final subjects = _subjectsByDay[dayIndex];
      if (subjects != null) {
        final index = subjects.indexWhere((s) => s.id == subjectId);
        if (index != -1) {
          subjects[index] = updatedSubject;
          notifyListeners();
        }
      }
    }
  }

  String getDayName(int dayIndex) {
    const days = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    return days[dayIndex];
  }
}

/// Notes Provider for PDF summarization
class NotesProvider extends ChangeNotifier {
  List<Document> _documents = [];
  Document? _selectedDocument;
  Summary? _currentSummary;
  bool _isProcessing = false;

  List<Document> get documents => _documents;
  Document? get selectedDocument => _selectedDocument;
  Summary? get currentSummary => _currentSummary;
  bool get isProcessing => _isProcessing;

  NotesProvider();

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void addDocument(Document document) {
    _documents.insert(0, document);
    notifyListeners();
  }

  void setSelectedDocument(Document? document) {
    _selectedDocument = document;
    _currentSummary = document?.summary;
    notifyListeners();
  }

  void setSummary(Summary summary, String documentId) {
    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(summary: summary);
      _currentSummary = summary;
      notifyListeners();
    }
  }
}

/// Quiz Provider for quiz generation and management
class QuizProvider extends ChangeNotifier {
  List<Quiz> _quizzes = [];
  Quiz? _currentQuiz;
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  List<int> _userAnswers = [];

  List<Quiz> get quizzes => _quizzes;
  Quiz? get currentQuiz => _currentQuiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  List<int> get userAnswers => _userAnswers;

  Question? get currentQuestion {
    if (_currentQuiz == null) return null;
    if (_currentQuestionIndex >= _currentQuiz!.questions.length) return null;
    return _currentQuiz!.questions[_currentQuestionIndex];
  }

  double get progress {
    if (_currentQuiz == null) return 0;
    return (_currentQuestionIndex + 1) / _currentQuiz!.questions.length;
  }

  QuizProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _quizzes = [
      Quiz(
        id: '1',
        title: 'Quantum Mechanics',
        module: 'PHYSICS MODULE',
        totalQuestions: 15,
        questions: [
          Question(
            id: '1',
            text:
                'What term describes the phenomenon where particles remain connected regardless of distance?',
            options: [
              'Quantum Superposition',
              'Quantum Entanglement',
              'Wave-Particle Duality',
              'The Uncertainty Principle',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Quantum entanglement is a phenomenon where two particles become interconnected and the quantum state of each particle cannot be described independently.',
          ),
          Question(
            id: '2',
            text:
                'What principle states that you cannot simultaneously know both the exact position and momentum of a particle?',
            options: [
              'Pauli Exclusion Principle',
              'Heisenberg Uncertainty Principle',
              'Principle of Superposition',
              'Copenhagen Interpretation',
            ],
            correctAnswerIndex: 1,
            explanation:
                'The Heisenberg Uncertainty Principle states that there is a fundamental limit to the precision with which complementary variables can be known.',
          ),
        ],
      ),
    ];
    _currentQuiz = _quizzes.first;
    notifyListeners();
  }

  void setCurrentQuiz(Quiz quiz) {
    _currentQuiz = quiz;
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _userAnswers = [];
    notifyListeners();
  }

  void selectAnswer(int index) {
    _selectedAnswerIndex = index;
    notifyListeners();
  }

  void submitAnswer() {
    if (_selectedAnswerIndex != null) {
      _userAnswers.add(_selectedAnswerIndex!);
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuiz != null &&
        _currentQuestionIndex < _currentQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _selectedAnswerIndex = _userAnswers.length > _currentQuestionIndex
          ? _userAnswers[_currentQuestionIndex]
          : null;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _userAnswers = [];
    notifyListeners();
  }
}

/// Flashcard Provider for flashcard management
class FlashcardProvider extends ChangeNotifier {
  List<FlashcardDeck> _decks = [];
  FlashcardDeck? _currentDeck;
  int _currentCardIndex = 0;
  bool _isFlipped = false;

  List<FlashcardDeck> get decks => _decks;
  FlashcardDeck? get currentDeck => _currentDeck;
  int get currentCardIndex => _currentCardIndex;
  bool get isFlipped => _isFlipped;

  Flashcard? get currentCard {
    if (_currentDeck == null) return null;
    if (_currentCardIndex >= _currentDeck!.cards.length) return null;
    return _currentDeck!.cards[_currentCardIndex];
  }

  double get progress {
    if (_currentDeck == null) return 0;
    return (_currentCardIndex + 1) / _currentDeck!.cards.length;
  }

  int get masteredCount {
    if (_currentDeck == null) return 0;
    return _currentDeck!.cards.where((c) => c.isMastered).length;
  }

  FlashcardProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _decks = [
      FlashcardDeck(
        id: '1',
        title: 'Organic Chemistry',
        totalCards: 40,
        cards: [
          Flashcard(
            id: '1',
            question: 'What is the definition of an organic compound?',
            answer:
                'A compound containing carbon atoms bonded to hydrogen and other elements, typically with covalent bonds.',
          ),
          Flashcard(
            id: '2',
            question: 'What is a functional group?',
            answer:
                'A specific group of atoms within a molecule that is responsible for the characteristic chemical reactions of that molecule.',
          ),
          Flashcard(
            id: '3',
            question: 'Define isomerism.',
            answer:
                'The phenomenon where compounds have the same molecular formula but different structural arrangements of atoms.',
          ),
        ],
      ),
      FlashcardDeck(
        id: '2',
        title: 'Physics Fundamentals',
        totalCards: 25,
        cards: [],
      ),
    ];
    _currentDeck = _decks.first;
    notifyListeners();
  }

  void setCurrentDeck(FlashcardDeck deck) {
    _currentDeck = deck;
    _currentCardIndex = 0;
    _isFlipped = false;
    notifyListeners();
  }

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void nextCard() {
    if (_currentDeck != null &&
        _currentCardIndex < _currentDeck!.cards.length - 1) {
      _currentCardIndex++;
      _isFlipped = false;
      notifyListeners();
    }
  }

  void previousCard() {
    if (_currentCardIndex > 0) {
      _currentCardIndex--;
      _isFlipped = false;
      notifyListeners();
    }
  }

  void markAsMastered() {
    if (_currentDeck != null && currentCard != null) {
      final index =
          _currentDeck!.cards.indexWhere((c) => c.id == currentCard!.id);
      if (index != -1) {
        _currentDeck!.cards[index] =
            _currentDeck!.cards[index].copyWith(isMastered: true);
        nextCard();
        notifyListeners();
      }
    }
  }

  void markForReview() {
    if (_currentDeck != null && currentCard != null) {
      final index =
          _currentDeck!.cards.indexWhere((c) => c.id == currentCard!.id);
      if (index != -1) {
        _currentDeck!.cards[index] = _currentDeck!.cards[index].copyWith(
          isMastered: false,
          needsReview: true,
        );
        nextCard();
        notifyListeners();
      }
    }
  }

  void resetDeck() {
    _currentCardIndex = 0;
    _isFlipped = false;
    notifyListeners();
  }
}
