"""
StudyAssist AI Backend
======================
A FastAPI-based backend that provides AI/ML capabilities for the StudyAssist app.

Features:
- PDF Text Extraction
- Text Summarization using DistilBART
- Question Generation using T5
- Keyword Extraction using KeyBERT
- Flashcard Generation

Author: StudyAssist Team
Course: Artificial Intelligence
"""

from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uvicorn

# Import our AI modules
from services.summarizer import SummarizerService
from services.quiz_generator import QuizGeneratorService
from services.flashcard_generator import FlashcardGeneratorService
from services.pdf_extractor import PDFExtractorService
from services.keyword_extractor import KeywordExtractorService

# Initialize FastAPI app
app = FastAPI(
    title="StudyAssist AI API",
    description="AI-powered backend for student learning assistance",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
summarizer = SummarizerService()
quiz_generator = QuizGeneratorService()
flashcard_generator = FlashcardGeneratorService()
pdf_extractor = PDFExtractorService()
keyword_extractor = KeywordExtractorService()


# ==================== Request/Response Models ====================

class TextInput(BaseModel):
    text: str
    max_length: Optional[int] = 150
    min_length: Optional[int] = 50

class SummaryResponse(BaseModel):
    summary: str
    key_concepts: List[str]
    word_count: int

class QuizRequest(BaseModel):
    text: str
    num_questions: Optional[int] = 5
    difficulty: Optional[str] = "medium"

class Question(BaseModel):
    question: str
    options: List[str]
    correct_answer: int
    explanation: Optional[str] = None

class QuizResponse(BaseModel):
    questions: List[Question]
    topic: str

class FlashcardRequest(BaseModel):
    text: str
    num_cards: Optional[int] = 10

class Flashcard(BaseModel):
    question: str
    answer: str

class FlashcardResponse(BaseModel):
    flashcards: List[Flashcard]
    topic: str

class KeywordResponse(BaseModel):
    keywords: List[str]
    scores: List[float]


# ==================== API Endpoints ====================

@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "status": "online",
        "service": "StudyAssist AI Backend",
        "version": "1.0.0",
        "models": {
            "summarizer": "distilbart-cnn-12-6",
            "quiz_generator": "t5-base-qg-hl",
            "keyword_extractor": "KeyBERT"
        }
    }


@app.post("/api/v1/upload-pdf")
async def upload_pdf(file: UploadFile = File(...)):
    """
    Upload a PDF file and extract its text content.
    
    - **file**: PDF file to upload (max 25MB)
    
    Returns extracted text and basic metadata.
    """
    if not file.filename.endswith('.pdf'):
        raise HTTPException(status_code=400, detail="Only PDF files are allowed")
    
    try:
        contents = await file.read()
        
        # Extract text from PDF
        extracted_text = pdf_extractor.extract_text(contents)
        
        return {
            "filename": file.filename,
            "text": extracted_text,
            "word_count": len(extracted_text.split()),
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing PDF: {str(e)}")


@app.post("/api/v1/summarize", response_model=SummaryResponse)
async def summarize_text(request: TextInput):
    """
    Generate an AI summary of the provided text.
    
    Uses DistilBART (distilbart-cnn-12-6) for summarization.
    
    - **text**: The text to summarize
    - **max_length**: Maximum length of summary (default: 150)
    - **min_length**: Minimum length of summary (default: 50)
    """
    try:
        # Generate summary
        summary = summarizer.summarize(
            request.text,
            max_length=request.max_length or 150,
            min_length=request.min_length or 50
        )
        
        # Extract key concepts
        keywords = keyword_extractor.extract_keywords(request.text, top_n=5)
        
        return SummaryResponse(
            summary=summary,
            key_concepts=[kw[0] for kw in keywords],
            word_count=len(summary.split())
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Summarization error: {str(e)}")


@app.post("/api/v1/generate-quiz", response_model=QuizResponse)
async def generate_quiz(request: QuizRequest):
    """
    Generate multiple-choice questions from the provided text.
    
    Uses T5-based question generation model (valhalla/t5-base-qg-hl).
    
    - **text**: Source text for generating questions
    - **num_questions**: Number of questions to generate (default: 5)
    - **difficulty**: Difficulty level (easy, medium, hard)
    """
    try:
        questions = quiz_generator.generate_quiz(
            request.text,
            num_questions=request.num_questions or 5,
            difficulty=request.difficulty or "medium"
        )
        
        # Extract topic from text
        topic_keywords = keyword_extractor.extract_keywords(request.text, top_n=1)
        topic = topic_keywords[0][0] if topic_keywords else "General"
        
        return QuizResponse(
            questions=questions,
            topic=topic.title()
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Quiz generation error: {str(e)}")


@app.post("/api/v1/generate-flashcards", response_model=FlashcardResponse)
async def generate_flashcards(request: FlashcardRequest):
    """
    Generate flashcards from the provided text.
    
    Uses KeyBERT for keyword extraction and NLP for Q&A generation.
    
    - **text**: Source text for generating flashcards
    - **num_cards**: Number of flashcards to generate (default: 10)
    """
    try:
        flashcards = flashcard_generator.generate_flashcards(
            request.text,
            num_cards=request.num_cards or 10
        )
        
        # Extract topic
        topic_keywords = keyword_extractor.extract_keywords(request.text, top_n=1)
        topic = topic_keywords[0][0] if topic_keywords else "General"
        
        return FlashcardResponse(
            flashcards=flashcards,
            topic=topic.title()
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Flashcard generation error: {str(e)}")


@app.post("/api/v1/extract-keywords", response_model=KeywordResponse)
async def extract_keywords(request: TextInput):
    """
    Extract key terms and concepts from text.
    
    Uses KeyBERT with BERT embeddings for semantic keyword extraction.
    
    - **text**: Text to extract keywords from
    """
    try:
        keywords_with_scores = keyword_extractor.extract_keywords(request.text, top_n=10)
        
        return KeywordResponse(
            keywords=[kw[0] for kw in keywords_with_scores],
            scores=[kw[1] for kw in keywords_with_scores]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Keyword extraction error: {str(e)}")


@app.post("/api/v1/process-document")
async def process_document(file: UploadFile = File(...)):
    """
    Complete document processing pipeline:
    1. Extract text from PDF
    2. Generate summary
    3. Extract keywords
    4. Generate quiz questions
    5. Create flashcards
    
    Returns all processed data in a single response.
    """
    if not file.filename.endswith('.pdf'):
        raise HTTPException(status_code=400, detail="Only PDF files are allowed")
    
    try:
        contents = await file.read()
        
        # Step 1: Extract text
        text = pdf_extractor.extract_text(contents)
        
        # Step 2: Generate summary
        summary = summarizer.summarize(text)
        
        # Step 3: Extract keywords
        keywords = keyword_extractor.extract_keywords(text, top_n=10)
        
        # Step 4: Generate quiz (3 questions for quick processing)
        questions = quiz_generator.generate_quiz(text, num_questions=3)
        
        # Step 5: Generate flashcards (5 cards for quick processing)
        flashcards = flashcard_generator.generate_flashcards(text, num_cards=5)
        
        return {
            "status": "success",
            "filename": file.filename,
            "summary": {
                "text": summary,
                "word_count": len(summary.split())
            },
            "keywords": [kw[0] for kw in keywords],
            "quiz": {
                "questions": questions,
                "count": len(questions)
            },
            "flashcards": {
                "cards": flashcards,
                "count": len(flashcards)
            }
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Document processing error: {str(e)}")


# ==================== Startup Event ====================

@app.on_event("startup")
async def startup_event():
    """Initialize ML models on startup"""
    print("🚀 Starting StudyAssist AI Backend...")
    print("📦 Loading ML models...")
    
    # Models are loaded lazily, but we can warm them up here
    # summarizer.warmup()
    # quiz_generator.warmup()
    
    print("✅ All systems ready!")


# ==================== Run Server ====================

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
