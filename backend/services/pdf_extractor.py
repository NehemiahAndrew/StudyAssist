"""
PDF Text Extraction Service
===========================
Extracts text content from PDF files using PyMuPDF (fitz).

This service handles:
- Text extraction from PDF pages
- Layout preservation
- Handling of multi-column layouts
- Image-based PDF detection
"""

import fitz  # PyMuPDF
from typing import Optional
import io


class PDFExtractorService:
    """
    PDF text extraction service using PyMuPDF.
    
    PyMuPDF (fitz) is chosen because:
    - Fast and efficient
    - Good text layout preservation
    - Handles various PDF formats
    - Pure Python, easy to install
    """
    
    def __init__(self):
        pass
    
    def extract_text(self, pdf_content: bytes) -> str:
        """
        Extract text from PDF content.
        
        Args:
            pdf_content: Raw PDF file bytes
            
        Returns:
            Extracted text as string
            
        Process:
        1. Open PDF from bytes
        2. Iterate through pages
        3. Extract text with layout preservation
        4. Clean and format output
        """
        try:
            # Open PDF from bytes
            pdf_stream = io.BytesIO(pdf_content)
            doc = fitz.open(stream=pdf_stream, filetype="pdf")
            
            full_text = []
            
            for page_num in range(len(doc)):
                page = doc.load_page(page_num)
                
                # Extract text with layout preservation
                # "text" mode preserves reading order
                text = page.get_text("text")
                
                if text.strip():
                    full_text.append(text)
                else:
                    # If no text found, try extracting from blocks
                    blocks = page.get_text("blocks")
                    block_texts = [block[4] for block in blocks if isinstance(block[4], str)]
                    if block_texts:
                        full_text.append("\n".join(block_texts))
            
            doc.close()
            
            # Join all pages and clean up
            extracted = "\n\n".join(full_text)
            return self._clean_text(extracted)
            
        except Exception as e:
            raise Exception(f"Error extracting text from PDF: {str(e)}")
    
    def extract_text_from_file(self, file_path: str) -> str:
        """
        Extract text from a PDF file path.
        
        Args:
            file_path: Path to the PDF file
            
        Returns:
            Extracted text as string
        """
        try:
            doc = fitz.open(file_path)
            
            full_text = []
            
            for page_num in range(len(doc)):
                page = doc.load_page(page_num)
                text = page.get_text("text")
                
                if text.strip():
                    full_text.append(text)
            
            doc.close()
            
            extracted = "\n\n".join(full_text)
            return self._clean_text(extracted)
            
        except Exception as e:
            raise Exception(f"Error extracting text from PDF file: {str(e)}")
    
    def get_pdf_info(self, pdf_content: bytes) -> dict:
        """
        Get metadata and info about a PDF.
        
        Returns:
            Dictionary with page count, metadata, etc.
        """
        try:
            pdf_stream = io.BytesIO(pdf_content)
            doc = fitz.open(stream=pdf_stream, filetype="pdf")
            
            info = {
                "page_count": len(doc),
                "metadata": doc.metadata,
                "is_encrypted": doc.is_encrypted,
                "has_text": False
            }
            
            # Check if PDF has extractable text
            for page_num in range(min(3, len(doc))):  # Check first 3 pages
                page = doc.load_page(page_num)
                if page.get_text().strip():
                    info["has_text"] = True
                    break
            
            doc.close()
            return info
            
        except Exception as e:
            raise Exception(f"Error getting PDF info: {str(e)}")
    
    def _clean_text(self, text: str) -> str:
        """
        Clean extracted text.
        
        - Remove excessive whitespace
        - Fix common extraction issues
        - Normalize line breaks
        """
        import re
        
        # Replace multiple spaces with single space
        text = re.sub(r' +', ' ', text)
        
        # Replace multiple newlines with double newline
        text = re.sub(r'\n{3,}', '\n\n', text)
        
        # Remove page numbers (common patterns)
        text = re.sub(r'\n\d+\n', '\n', text)
        
        # Fix hyphenation at line breaks
        text = re.sub(r'-\n', '', text)
        
        # Trim lines
        lines = [line.strip() for line in text.split('\n')]
        text = '\n'.join(lines)
        
        return text.strip()
    
    def extract_by_pages(self, pdf_content: bytes) -> list:
        """
        Extract text page by page.
        
        Returns:
            List of text strings, one per page
        """
        try:
            pdf_stream = io.BytesIO(pdf_content)
            doc = fitz.open(stream=pdf_stream, filetype="pdf")
            
            pages = []
            
            for page_num in range(len(doc)):
                page = doc.load_page(page_num)
                text = page.get_text("text")
                pages.append({
                    "page_number": page_num + 1,
                    "text": self._clean_text(text)
                })
            
            doc.close()
            return pages
            
        except Exception as e:
            raise Exception(f"Error extracting pages: {str(e)}")
