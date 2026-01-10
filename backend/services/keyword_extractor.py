"""
Keyword Extraction Service
==========================
Extracts key terms and concepts from text using KeyBERT.

KeyBERT uses BERT embeddings to find keywords that are most similar
to the document, producing semantically relevant keywords.

NLP Concepts Used:
- Word embeddings (BERT)
- Cosine similarity
- N-gram extraction
- Maximal Marginal Relevance (MMR)
"""

from keybert import KeyBERT
from typing import List, Tuple
import warnings

# Suppress some warnings
warnings.filterwarnings("ignore", category=FutureWarning)


class KeywordExtractorService:
    """
    AI-powered keyword extraction using KeyBERT.
    
    KeyBERT Process:
    1. Generate document embedding using BERT
    2. Extract candidate keywords (n-grams)
    3. Generate embeddings for candidates
    4. Calculate similarity to document
    5. Use MMR for diversity
    
    Why KeyBERT?
    - BERT understands context and semantics
    - Better than TF-IDF for understanding meaning
    - Produces more relevant keywords
    """
    
    def __init__(self):
        self.model = None
        self._is_loaded = False
    
    def _load_model(self):
        """Lazy load KeyBERT model"""
        if not self._is_loaded:
            print("📥 Loading KeyBERT model...")
            # Uses all-MiniLM-L6-v2 by default (fast and good quality)
            self.model = KeyBERT()
            self._is_loaded = True
            print("✅ KeyBERT model loaded")
    
    def extract_keywords(
        self,
        text: str,
        top_n: int = 10,
        keyphrase_length: Tuple[int, int] = (1, 3),
        use_mmr: bool = True,
        diversity: float = 0.5
    ) -> List[Tuple[str, float]]:
        """
        Extract keywords from text.
        
        Args:
            text: Input text
            top_n: Number of keywords to extract
            keyphrase_length: Min and max n-gram size (1,3) means 1-3 words
            use_mmr: Use Maximal Marginal Relevance for diversity
            diversity: How diverse keywords should be (0-1)
            
        Returns:
            List of (keyword, score) tuples
            
        Algorithm:
        1. BERT encodes the document
        2. N-grams are extracted as candidates
        3. Each candidate is encoded
        4. Cosine similarity is calculated
        5. MMR balances relevance and diversity
        """
        self._load_model()
        
        if not text or len(text.strip()) < 10:
            return []
        
        try:
            if use_mmr:
                # Use Maximal Marginal Relevance for diverse keywords
                keywords = self.model.extract_keywords(
                    text,
                    keyphrase_ngram_range=keyphrase_length,
                    stop_words='english',
                    use_mmr=True,
                    diversity=diversity,
                    top_n=top_n
                )
            else:
                # Simple cosine similarity
                keywords = self.model.extract_keywords(
                    text,
                    keyphrase_ngram_range=keyphrase_length,
                    stop_words='english',
                    top_n=top_n
                )
            
            return keywords
            
        except Exception as e:
            print(f"Error extracting keywords: {e}")
            return []
    
    def extract_with_candidates(
        self,
        text: str,
        candidates: List[str],
        top_n: int = 5
    ) -> List[Tuple[str, float]]:
        """
        Extract keywords from a predefined list of candidates.
        
        Useful when you have a controlled vocabulary or
        want to match specific terms from a glossary.
        
        Args:
            text: Input text
            candidates: List of candidate keywords
            top_n: Number of keywords to return
            
        Returns:
            List of (keyword, score) tuples
        """
        self._load_model()
        
        if not text or not candidates:
            return []
        
        try:
            keywords = self.model.extract_keywords(
                text,
                candidates=candidates,
                top_n=top_n
            )
            return keywords
        except Exception as e:
            print(f"Error extracting keywords with candidates: {e}")
            return []
    
    def extract_highlights(
        self,
        text: str,
        top_n: int = 5
    ) -> List[str]:
        """
        Extract key phrases to highlight in text.
        
        Returns just the keywords without scores,
        useful for UI highlighting.
        """
        keywords = self.extract_keywords(text, top_n=top_n)
        return [kw[0] for kw in keywords]
    
    def get_topic(self, text: str) -> str:
        """
        Get the main topic of the text.
        
        Returns the single most relevant keyword.
        """
        keywords = self.extract_keywords(text, top_n=1)
        if keywords:
            return keywords[0][0]
        return "Unknown"
    
    def get_related_concepts(
        self,
        text: str,
        concept: str,
        top_n: int = 5
    ) -> List[str]:
        """
        Find concepts in text related to a given concept.
        
        Useful for building concept maps or finding
        related study materials.
        """
        self._load_model()
        
        try:
            # Get all keywords
            all_keywords = self.extract_keywords(text, top_n=20, use_mmr=False)
            
            # Use the model to find similarity to the given concept
            # This is a simplified approach
            related = []
            for kw, score in all_keywords:
                if concept.lower() not in kw.lower():
                    related.append(kw)
                    if len(related) >= top_n:
                        break
            
            return related
            
        except Exception as e:
            print(f"Error finding related concepts: {e}")
            return []
