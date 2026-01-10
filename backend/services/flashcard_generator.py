"""
Flashcard Generation Service
============================
Generates Q&A flashcards from text using keyword extraction and NLP.

This service demonstrates:
- Keyword/keyphrase extraction
- Question template generation
- Answer extraction from context

NLP Concepts Used:
- Keyword extraction (TF-IDF, TextRank)
- Named Entity Recognition
- Template-based NLG
"""

from typing import List, Dict
# import spacy  # Commented out - requires C++ build tools
import random


class FlashcardGeneratorService:
    """
    AI-powered flashcard generation.
    
    Process:
    1. Extract key concepts using KeyBERT/spaCy
    2. Identify definitions and explanations
    3. Generate Q&A pairs
    4. Format as flashcards
    """
    
    def __init__(self):
        self.nlp = None
        self._is_loaded = False
        
        # Question templates for different entity types
        self.templates = {
            'DEFINITION': [
                "What is {concept}?",
                "Define {concept}.",
                "Explain the term {concept}.",
            ],
            'PERSON': [
                "Who is {concept}?",
                "What is {concept} known for?",
            ],
            'DATE': [
                "When did {concept} occur?",
                "What happened on {concept}?",
            ],
            'PROCESS': [
                "Describe the process of {concept}.",
                "How does {concept} work?",
            ],
            'CONCEPT': [
                "What is the significance of {concept}?",
                "Explain {concept}.",
            ],
        }
    
    def _load_model(self):
        """Lazy load - no external models needed for basic flashcards"""
        if not self._is_loaded:
            print("📥 Loading flashcard generation service...")
            # Note: spaCy disabled to avoid C++ build tool requirements
            self.nlp = None
            self._is_loaded = True
            print("✅ Flashcard generation ready")
    
    def generate_flashcards(
        self,
        text: str,
        num_cards: int = 10
    ) -> List[Dict]:
        """
        Generate flashcards from text.
        
        Args:
            text: Source text
            num_cards: Number of flashcards to generate
            
        Returns:
            List of flashcard dictionaries with question and answer
            
        NLP Pipeline:
        1. Sentence segmentation
        2. Entity extraction
        3. Definition pattern matching
        4. Q&A pair generation
        """
        self._load_model()
        
        flashcards = []
        
        # Strategy 1: Extract definitions ("X is/are Y" patterns)
        definition_cards = self._extract_definitions_simple(text)
        flashcards.extend(definition_cards)
        
        # Strategy 2: Split into sentences and create Q&A pairs
        sentences = text.split('. ')
        for sentence in sentences[:num_cards * 2]:
            if len(sentence.split()) > 5:  # Only meaningful sentences
                # Simple approach: first part is question, sentence is answer
                words = sentence.split()
                if len(words) > 10:
                    question = ' '.join(words[:5]) + '...'
                    flashcards.append({
                        'question': f"Complete: {question}",
                        'answer': sentence.strip()
                    })
        
        # Remove duplicates and limit
        seen = set()
        unique_cards = []
        for card in flashcards:
            if card['question'] not in seen:
                seen.add(card['question'])
                unique_cards.append(card)
        
        # Shuffle and return requested number
        random.shuffle(unique_cards)
        return unique_cards[:num_cards]
    
    def _extract_definitions_simple(self, text: str) -> List[Dict]:
        """
        Extract definition-style sentences using simple pattern matching.
        
        Looks for patterns like:
        - "X is a/an Y"
        - "X refers to Y"
        - "X is defined as Y"
        """
        definitions = []
        sentences = text.split('. ')
        
        for sentence in sentences:
            sentence = sentence.strip()
            lower_sent = sentence.lower()
            
            # Pattern: "X is a/an/the Y"
            if ' is a ' in lower_sent or ' is an ' in lower_sent or ' is the ' in lower_sent:
                parts = sentence.split(' is ', 1)
                if len(parts) == 2 and len(parts[0]) > 2:
                    subject = parts[0].strip()
                    definition = parts[1].strip()
                    if len(subject.split()) <= 5 and len(definition.split()) > 2:
                        definitions.append({
                            'question': f"What is {subject}?",
                            'answer': definition
                        })
            
            # Pattern: "X refers to Y"
            elif ' refers to ' in lower_sent or ' defined as ' in lower_sent:
                definitions.append({
                    'question': f"Explain: {sentence.split()[0]}",
                    'answer': sentence
                })
        
        return definitions[:10]  # Limit definitions

