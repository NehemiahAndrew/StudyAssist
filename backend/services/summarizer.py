"""
Text Summarization Service
==========================
Uses DistilBART (distilbart-cnn-12-6) for abstractive text summarization.

This model is a distilled version of BART, fine-tuned on CNN/DailyMail dataset.
It provides fast, high-quality summaries suitable for educational content.

NLP Concepts Used:
- Transformer architecture
- Encoder-Decoder model
- Attention mechanism
- Abstractive summarization
"""

from transformers import pipeline, AutoTokenizer, AutoModelForSeq2SeqLM
from typing import Optional
import torch


class SummarizerService:
    """
    AI-powered text summarization using pre-trained transformer models.
    
    Model: sshleifer/distilbart-cnn-12-6
    - Smaller and faster than BART-large
    - Trained on news articles (generalizes well to educational content)
    - Produces coherent, fluent summaries
    """
    
    def __init__(self, model_name: str = "sshleifer/distilbart-cnn-12-6"):
        """
        Initialize the summarizer with a pre-trained model.
        
        Args:
            model_name: HuggingFace model identifier
        """
        self.model_name = model_name
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.summarizer = None
        self._is_loaded = False
        
    def _load_model(self):
        """Lazy load the model when first needed"""
        if not self._is_loaded:
            print(f"📥 Loading summarization model: {self.model_name}")
            self.summarizer = pipeline(
                "summarization",
                model=self.model_name,
                device=0 if self.device == "cuda" else -1
            )
            self._is_loaded = True
            print("✅ Summarization model loaded successfully")
    
    def summarize(
        self,
        text: str,
        max_length: int = 500,
        min_length: int = 200,
        do_sample: bool = False
    ) -> str:
        """
        Generate a comprehensive summary of the input text.
        
        Args:
            text: The text to summarize
            max_length: Maximum length of the summary (default 500 for detailed summaries)
            min_length: Minimum length of the summary (default 200 for comprehensive coverage)
            do_sample: Whether to use sampling (for more diverse outputs)
            
        Returns:
            Generated summary string with proper formatting
            
        NLP Process:
        1. Tokenization: Text is converted to tokens
        2. Encoding: Tokens pass through encoder layers
        3. Attention: Model attends to important parts
        4. Decoding: Summary is generated token by token
        """
        self._load_model()
        
        # Handle very long texts by chunking
        max_input_length = 1024  # Model's max input length
        
        if len(text.split()) > max_input_length:
            # Split into chunks and summarize each
            chunks = self._chunk_text(text, max_input_length)
            summaries = []
            
            for chunk in chunks:
                result = self.summarizer(
                    chunk,
                    max_length=min(max_length // len(chunks), 200),
                    min_length=min(min_length // len(chunks), 80),
                    do_sample=do_sample
                )
                summaries.append(result[0]['summary_text'])
            
            # Combine chunk summaries with paragraph breaks
            combined = "\n\n".join(summaries)
            
            # If combined is still too long, summarize again
            if len(combined.split()) > max_length:
                result = self.summarizer(
                    combined,
                    max_length=max_length,
                    min_length=min_length,
                    do_sample=do_sample
                )
                return result[0]['summary_text']
            
            return combined
        else:
            result = self.summarizer(
                text,
                max_length=max_length,
                min_length=min_length,
                do_sample=do_sample
            )
            summary = result[0]['summary_text']
            
            # Format summary with paragraph breaks for better readability
            # Split long summaries into paragraphs at sentence boundaries
            sentences = summary.split('. ')
            if len(sentences) > 4:
                # Group sentences into paragraphs (3-4 sentences each)
                paragraphs = []
                for i in range(0, len(sentences), 3):
                    para = '. '.join(sentences[i:i+3])
                    if not para.endswith('.'):
                        para += '.'
                    paragraphs.append(para)
                return '\n\n'.join(paragraphs)
            
            return summary
    
    def _chunk_text(self, text: str, max_words: int) -> list:
        """
        Split text into chunks of approximately max_words.
        
        Args:
            text: Text to split
            max_words: Maximum words per chunk
            
        Returns:
            List of text chunks
        """
        words = text.split()
        chunks = []
        
        for i in range(0, len(words), max_words):
            chunk = " ".join(words[i:i + max_words])
            chunks.append(chunk)
        
        return chunks
    
    def get_extractive_summary(self, text: str, num_sentences: int = 5) -> str:
        """
        Alternative: Extractive summarization using sentence scoring.
        
        This method doesn't use the neural model but instead:
        1. Splits text into sentences
        2. Scores sentences by word frequency
        3. Returns top-scoring sentences
        
        Good for when you want exact quotes from the text.
        """
        import nltk
        from nltk.tokenize import sent_tokenize, word_tokenize
        from nltk.corpus import stopwords
        from collections import Counter
        
        # Ensure NLTK data is downloaded
        try:
            nltk.data.find('tokenizers/punkt')
        except LookupError:
            nltk.download('punkt')
            nltk.download('stopwords')
        
        sentences = sent_tokenize(text)
        
        if len(sentences) <= num_sentences:
            return text
        
        # Calculate word frequencies
        words = word_tokenize(text.lower())
        stop_words = set(stopwords.words('english'))
        words = [w for w in words if w.isalnum() and w not in stop_words]
        word_freq = Counter(words)
        
        # Score sentences
        sentence_scores = []
        for i, sentence in enumerate(sentences):
            words = word_tokenize(sentence.lower())
            words = [w for w in words if w.isalnum() and w not in stop_words]
            score = sum(word_freq[w] for w in words) / (len(words) + 1)
            sentence_scores.append((i, score, sentence))
        
        # Get top sentences (maintaining original order)
        top_sentences = sorted(sentence_scores, key=lambda x: x[1], reverse=True)[:num_sentences]
        top_sentences = sorted(top_sentences, key=lambda x: x[0])  # Restore order
        
        return " ".join([s[2] for s in top_sentences])
    
    def warmup(self):
        """Pre-load the model for faster first inference"""
        self._load_model()
        # Run a dummy inference to warm up
        _ = self.summarize("This is a test sentence for warming up the model.")
