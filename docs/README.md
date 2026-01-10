# StudyAssist - AI-Powered Learning Companion

## 📚 Project Overview

**StudyAssist** is an AI-powered mobile application designed to help students organize their study life and master their subjects. Built with Flutter for the frontend and Python for the AI backend, this project demonstrates practical applications of **Natural Language Processing (NLP)** and **Machine Learning (ML)** in education technology.

---

## 🎯 Problem Statement

Students face several challenges in their academic journey:
- **Information Overload**: Too many notes, textbooks, and materials to process
- **Inefficient Study Methods**: Traditional reading without active recall
- **Poor Time Management**: Difficulty creating and following study schedules
- **Lack of Self-Assessment**: No easy way to test understanding

---

## 💡 Solution: StudyAssist

Our AI-powered assistant addresses these challenges through:

| Feature | AI Technology | Benefit |
|---------|--------------|---------|
| **PDF Summarization** | Transformer Models (DistilBART) | Condense lengthy notes into key points |
| **Quiz Generation** | T5 Question Generation | Automatic MCQ creation for self-testing |
| **Flashcard Creation** | KeyBERT + NLP | Convert concepts to spaced repetition cards |
| **Smart Timetable** | Optimization Algorithms | AI-suggested study schedules |

---

## 🧠 AI/ML Technologies Used

### 1. Text Summarization (Abstractive)
**Model**: `sshleifer/distilbart-cnn-12-6`

```
Input: Long text document
   ↓
[Transformer Encoder] → Attention mechanism identifies key information
   ↓
[Transformer Decoder] → Generates new summary text
   ↓
Output: Concise summary
```

**NLP Concepts**:
- Encoder-Decoder Architecture
- Self-Attention Mechanism
- Sequence-to-Sequence Learning

### 2. Question Generation
**Model**: `valhalla/t5-base-qg-hl`

```
Input: Text with highlighted answers
   ↓
[Named Entity Recognition] → Extract potential answers
   ↓
[T5 Model] → Generate questions for each answer
   ↓
[Distractor Generation] → Create wrong options
   ↓
Output: Multiple Choice Questions
```

**NLP Concepts**:
- Text-to-Text Transfer Learning
- Named Entity Recognition (NER)
- Answer-Aware Question Generation

### 3. Keyword Extraction
**Model**: KeyBERT with `all-MiniLM-L6-v2`

```
Input: Document text
   ↓
[BERT Encoding] → Generate document embedding
   ↓
[N-gram Extraction] → Extract candidate keywords
   ↓
[Similarity Calculation] → Cosine similarity with document
   ↓
[MMR] → Maximal Marginal Relevance for diversity
   ↓
Output: Ranked keywords with scores
```

**NLP Concepts**:
- Word Embeddings (BERT)
- Semantic Similarity
- Maximal Marginal Relevance

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    STUDYASSIST ARCHITECTURE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐         ┌─────────────────────────┐   │
│  │   FLUTTER APP   │  REST   │    PYTHON BACKEND       │   │
│  │   (Frontend)    │◄──────► │    (FastAPI)            │   │
│  │                 │   API   │                         │   │
│  │  • Home Screen  │         │  • PDF Extraction       │   │
│  │  • Summarizer   │         │  • Summarization        │   │
│  │  • Quiz Module  │         │  • Quiz Generation      │   │
│  │  • Flashcards   │         │  • Flashcard Gen        │   │
│  │  • Timetable    │         │  • Keyword Extraction   │   │
│  └─────────────────┘         └─────────────────────────┘   │
│                                        │                    │
│                                        ▼                    │
│                              ┌─────────────────────────┐   │
│                              │     AI/ML MODELS        │   │
│                              │                         │   │
│                              │  • DistilBART (Summary) │   │
│                              │  • T5 (Question Gen)    │   │
│                              │  • KeyBERT (Keywords)   │   │
│                              │  • spaCy (NLP)          │   │
│                              └─────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📱 App Features

### 1. Home Dashboard
- Personalized greeting
- Today's focus subject
- Daily study goal progress
- Quick access to all features
- Recent insights and recommendations

### 2. AI Summarizer
- PDF upload (up to 25MB)
- Real-time text extraction
- AI-generated summaries
- Key concept highlighting
- Copy and share functionality

### 3. Quiz Module
- Auto-generated MCQ questions
- Multiple difficulty levels
- Progress tracking
- Visual hints
- Explanations for answers

### 4. Flashcard System
- AI-generated Q&A cards
- Flip animation
- Mark as mastered/review
- Spaced repetition support
- Deck management

### 5. Timetable Planner
- Weekly schedule view
- Color-coded subjects
- AI schedule suggestions
- Deadline tracking
- Study time optimization

---

## 🔧 Technology Stack

### Frontend (Mobile App)
| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform UI framework |
| Provider | State management |
| flutter_animate | Animations |
| file_picker | PDF upload |
| percent_indicator | Progress visualization |

### Backend (AI Server)
| Technology | Purpose |
|------------|---------|
| FastAPI | REST API framework |
| Transformers | Pre-trained NLP models |
| PyTorch | Deep learning backend |
| spaCy | NLP processing |
| KeyBERT | Keyword extraction |
| PyMuPDF | PDF text extraction |

---

## 📊 ML Models Summary

| Model | Task | Size | Source |
|-------|------|------|--------|
| distilbart-cnn-12-6 | Summarization | ~800MB | Hugging Face |
| t5-base-qg-hl | Question Generation | ~850MB | Hugging Face |
| all-MiniLM-L6-v2 | Embeddings | ~80MB | Sentence Transformers |
| en_core_web_sm | NLP Processing | ~12MB | spaCy |

---

## 🚀 How to Run

### Backend Setup
```bash
cd backend
pip install -r requirements.txt
python -m spacy download en_core_web_sm
python main.py
```

### Flutter App Setup
```bash
flutter pub get
flutter run
```

---

## 📈 Future Enhancements

1. **Voice-to-Text**: Convert lecture recordings to notes
2. **OCR Integration**: Extract text from handwritten notes
3. **Collaborative Study**: Share flashcards with classmates
4. **Performance Analytics**: Detailed learning insights
5. **Offline Mode**: Cache models for offline use

---

## 👥 Team

- **Course**: Artificial Intelligence
- **Project**: AI Model that Solves a Problem
- **Focus**: NLP and Machine Learning for Education

---

## 📚 References

1. Lewis, M., et al. "BART: Denoising Sequence-to-Sequence Pre-training" (2019)
2. Raffel, C., et al. "Exploring the Limits of Transfer Learning with T5" (2020)
3. Grootendorst, M. "KeyBERT: Minimal keyword extraction with BERT" (2020)
4. Vaswani, A., et al. "Attention Is All You Need" (2017)
