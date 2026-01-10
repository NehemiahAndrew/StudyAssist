"""
Quiz Generation Service
=======================
Uses T5-based model for automatic question generation from text.

This service demonstrates:
- Question Generation (QG) using transformers
- Named Entity Recognition for answer extraction
- Distractor generation for MCQs

NLP Concepts Used:
- Sequence-to-sequence learning
- Text-to-text generation
- Answer-aware question generation
"""

from transformers import pipeline, T5ForConditionalGeneration, T5Tokenizer
from typing import List, Dict, Optional
import torch
import random
# import spacy  # Commented out - requires C++ build tools


class QuizGeneratorService:
    """
    AI-powered quiz question generation.
    
    Model: valhalla/t5-base-qg-hl
    - Fine-tuned T5 for question generation
    - Takes text with highlighted answers
    - Generates relevant questions
    
    Process:
    1. Extract key sentences/concepts from text
    2. Identify potential answers (entities, key terms)
    3. Generate questions for each answer
    4. Create distractors (wrong options) for MCQs
    """
    
    def __init__(self):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.qg_model = None
        self.qg_tokenizer = None
        self.nlp = None
        self._is_loaded = False
        
    def _load_models(self):
        """Lazy load models when first needed"""
        if not self._is_loaded:
            print("📥 Loading question generation model...")
            
            # Load T5 for question generation
            model_name = "valhalla/t5-base-qg-hl"
            self.qg_tokenizer = T5Tokenizer.from_pretrained(model_name)
            self.qg_model = T5ForConditionalGeneration.from_pretrained(model_name)
            
            if self.device == "cuda":
                self.qg_model = self.qg_model.cuda()
            
            # Note: spaCy disabled to avoid C++ build tool requirements
            # Using simpler text processing instead
            self.nlp = None
            
            self._is_loaded = True
            print("✅ Question generation models loaded")
    
    def generate_quiz(
        self,
        text: str,
        num_questions: int = 5,
        difficulty: str = "medium"
    ) -> List[Dict]:
        """
        Generate multiple-choice questions from text.
        
        Args:
            text: Source text for question generation
            num_questions: Number of questions to generate
            difficulty: easy, medium, or hard
            
        Returns:
            List of question dictionaries with options
            
        ML Pipeline:
        1. NER: Extract entities (answers)
        2. QG: Generate questions for answers
        3. Distractor: Create wrong options
        """
        self._load_models()
        
        # Extract potential answers from text
        answers = self._extract_answers(text, num_questions * 2)
        
        questions = []
        for answer in answers[:num_questions]:
            try:
                # Generate question for this answer
                question_text = self._generate_question(text, answer)
                
                if question_text:
                    # Generate distractors (wrong options)
                    distractors = self._generate_distractors(answer, text, num=3)
                    
                    # Create MCQ
                    options = distractors + [answer]
                    random.shuffle(options)
                    correct_index = options.index(answer)
                    
                    questions.append({
                        "question": question_text,
                        "options": options,
                        "correct_answer": correct_index,
                        "explanation": f"The correct answer is '{answer}' based on the provided text."
                    })
            except Exception as e:
                print(f"Error generating question for answer '{answer}': {e}")
                continue
        
        return questions
    
    def _extract_answers(self, text: str, num_answers: int) -> List[str]:
        """
        Extract potential answers from text using NER and key phrase extraction.
        
        Uses spaCy's NER to identify:
        - Named entities (people, places, dates, etc.)
        - Noun phrases
        - Key terms
        """
        self._load_models()
        
        # Simple answer extraction without spaCy
        answers = []
        
        # Extract capitalized phrases (likely important terms/names)
        words = text.split()
        for i, word in enumerate(words):
            if word and word[0].isupper() and word not in ['The', 'A', 'An', 'This', 'That', 'These', 'Those']:
                # Get multi-word capitalized phrases
                phrase = word
                j = i + 1
                while j < len(words) and words[j] and words[j][0].isupper():
                    phrase += ' ' + words[j]
                    j += 1
                if phrase not in answers and len(phrase.split()) <= 4:
                    answers.append(phrase)
        
        # Limit and shuffle for variety
        random.shuffle(answers)
        return answers[:min(num_answers, len(answers))]
    
    def _generate_question(self, text: str, answer: str) -> Optional[str]:
        """
        Generate a question for a given answer using T5 model.
        
        The model expects input in format:
        "generate question: <answer> context: <text>"
        
        T5 Concept:
        - Text-to-text framework
        - All NLP tasks as text generation
        - Answer-aware question generation
        """
        self._load_models()
        
        # Format input for the model
        # Highlight the answer in the text
        highlighted_text = text.replace(answer, f"<hl> {answer} <hl>")
        input_text = f"generate question: {highlighted_text}"
        
        # Tokenize
        inputs = self.qg_tokenizer.encode(
            input_text,
            max_length=512,
            truncation=True,
            return_tensors="pt"
        )
        
        if self.device == "cuda":
            inputs = inputs.cuda()
        
        # Generate
        outputs = self.qg_model.generate(
            inputs,
            max_length=64,
            num_beams=4,
            early_stopping=True
        )
        
        question = self.qg_tokenizer.decode(outputs[0], skip_special_tokens=True)
        return question if question else None
    
    def _generate_distractors(self, answer: str, text: str, num: int = 3) -> List[str]:
        """
        Generate plausible wrong answers (distractors) for MCQs.
        
        Strategies:
        1. Use other similar phrases from text
        2. Use related concepts from the text
        """
        self._load_models()
        
        distractors = []
        
        # Extract other capitalized phrases as distractors
        words = text.split()
        for i, word in enumerate(words):
            if word and word[0].isupper():
                phrase = word
                j = i + 1
                while j < len(words) and j < i + 4 and words[j] and words[j][0].isupper():
                    phrase += ' ' + words[j]
                    j += 1
                if phrase != answer and phrase not in distractors and len(distractors) < num_distractors * 2:
                    distractors.append(phrase)
                    if len(distractors) >= num:
                        break
        
        # If not enough distractors, add noun phrases
        if len(distractors) < num:
            for chunk in doc.noun_chunks:
                if chunk.text != answer and chunk.text not in distractors:
                    distractors.append(chunk.text)
                    if len(distractors) >= num:
                        break
        
        # Fallback: create plausible variations
        if len(distractors) < num:
            fallbacks = [
                "None of the above",
                "All of the above",
                "Cannot be determined"
            ]
            distractors.extend(fallbacks[:num - len(distractors)])
        
        return distractors[:num]
    
    def warmup(self):
        """Pre-load models for faster first inference"""
        self._load_models()
