# StudyAssist - Complete Setup Guide

## 📋 Prerequisites

Before running the project, ensure you have the following installed:

### For Flutter App:
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio or VS Code
- Android/iOS emulator or physical device

### For Python Backend:
- Python 3.10+
- pip (Python package manager)
- 8GB+ RAM recommended (for ML models)

---

## 🚀 Step-by-Step Setup

### Step 1: Clone/Download the Project

```bash
cd C:\Users\Nehemiah\Desktop\StudyAssist
```

### Step 2: Setup Python Backend

```bash
# Navigate to backend folder
cd backend

# Create virtual environment (recommended)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Download spaCy model
python -m spacy download en_core_web_sm

# Run the backend server
python main.py
```

The API will be available at: `http://localhost:8000`

**API Documentation**: Visit `http://localhost:8000/docs` for Swagger UI

### Step 3: Setup Flutter App

```bash
# Navigate to project root
cd C:\Users\Nehemiah\Desktop\StudyAssist

# Get Flutter dependencies
flutter pub get

# Create asset directories
mkdir assets\images
mkdir assets\icons
mkdir assets\animations
mkdir assets\fonts

# Run the app
flutter run
```

---

## 📁 Project Structure

```
StudyAssist/
├── lib/                          # Flutter app source
│   ├── main.dart                 # App entry point
│   ├── core/
│   │   ├── theme/
│   │   │   └── app_theme.dart    # Colors, styles, theme
│   │   ├── providers/
│   │   │   └── app_provider.dart # State management
│   │   ├── models/
│   │   │   └── models.dart       # Data models
│   │   ├── widgets/
│   │   │   └── common_widgets.dart # Reusable widgets
│   │   └── services/
│   │       └── api_service.dart  # Backend API calls
│   └── features/
│       ├── splash/
│       │   └── splash_screen.dart
│       ├── navigation/
│       │   └── main_navigation.dart
│       ├── home/
│       │   └── home_screen.dart
│       ├── library/
│       │   └── library_screen.dart
│       ├── stats/
│       │   └── stats_screen.dart
│       ├── profile/
│       │   └── profile_screen.dart
│       ├── summarizer/
│       │   └── summarizer_screen.dart
│       ├── timetable/
│       │   └── timetable_screen.dart
│       ├── quiz/
│       │   ├── quiz_screen.dart
│       │   └── quiz_list_screen.dart
│       └── flashcards/
│           ├── flashcard_screen.dart
│           └── flashcard_deck_screen.dart
├── backend/                       # Python AI backend
│   ├── main.py                   # FastAPI server
│   ├── requirements.txt          # Python dependencies
│   └── services/
│       ├── __init__.py
│       ├── summarizer.py         # DistilBART summarization
│       ├── quiz_generator.py     # T5 question generation
│       ├── flashcard_generator.py # Flashcard creation
│       ├── pdf_extractor.py      # PDF text extraction
│       └── keyword_extractor.py  # KeyBERT keywords
├── docs/
│   ├── README.md                 # Project documentation
│   ├── PRESENTATION_GUIDE.md     # PowerPoint content
│   └── SETUP_GUIDE.md           # This file
├── pubspec.yaml                  # Flutter dependencies
└── assets/
    ├── images/
    ├── icons/
    ├── animations/
    └── fonts/
```

---

## 🔌 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Health check |
| `/api/v1/upload-pdf` | POST | Upload and extract PDF text |
| `/api/v1/summarize` | POST | Summarize text |
| `/api/v1/generate-quiz` | POST | Generate quiz questions |
| `/api/v1/generate-flashcards` | POST | Create flashcards |
| `/api/v1/extract-keywords` | POST | Extract key terms |
| `/api/v1/process-document` | POST | Complete pipeline |

---

## 🧪 Testing the API

### Using cURL:

```bash
# Health check
curl http://localhost:8000/

# Summarize text
curl -X POST http://localhost:8000/api/v1/summarize \
  -H "Content-Type: application/json" \
  -d '{"text": "Your long text here..."}'

# Generate quiz
curl -X POST http://localhost:8000/api/v1/generate-quiz \
  -H "Content-Type: application/json" \
  -d '{"text": "Your text here...", "num_questions": 3}'
```

### Using Swagger UI:
Visit `http://localhost:8000/docs` in your browser

---

## ⚠️ Common Issues & Solutions

### Issue 1: Models not downloading
```
Error: Can't load model...
```
**Solution**: Ensure you have internet connection and enough disk space (~3GB for all models)

### Issue 2: CUDA/GPU errors
```
Error: CUDA out of memory
```
**Solution**: The code automatically falls back to CPU. If using GPU, reduce batch sizes.

### Issue 3: Flutter build errors
```
Error: pub get failed
```
**Solution**:
```bash
flutter clean
flutter pub get
```

### Issue 4: Port already in use
```
Error: Address already in use
```
**Solution**:
```bash
# Kill process on port 8000
# Windows:
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

---

## 📱 Running on Device

### Android:
```bash
flutter run -d android
```

### iOS:
```bash
flutter run -d ios
```

### Web (for testing):
```bash
flutter run -d chrome
```

---

## 🔧 Configuration

### Backend URL
In `lib/core/services/api_service.dart`, update the base URL:

```dart
// For local development
static const String baseUrl = 'http://localhost:8000/api/v1';

// For Android emulator
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

// For production
static const String baseUrl = 'https://your-server.com/api/v1';
```

---

## 📝 Adding New Features

### Adding a new screen:
1. Create file in `lib/features/<feature_name>/<screen_name>.dart`
2. Import in navigation
3. Add route if needed

### Adding a new AI service:
1. Create file in `backend/services/<service_name>.py`
2. Import in `__init__.py`
3. Add endpoint in `main.py`

---

## 🎓 For Presentation

1. Start backend first: `python main.py`
2. Run Flutter app: `flutter run`
3. Have sample PDF ready for demo
4. Test all features before presenting

---

## 📞 Support

If you encounter issues:
1. Check this guide
2. Check API docs at `/docs`
3. Review error messages carefully
4. Ensure all prerequisites are installed
