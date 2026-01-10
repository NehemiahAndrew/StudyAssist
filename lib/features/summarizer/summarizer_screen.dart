import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/app_provider.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/services/api_service.dart';
import '../../core/models/models.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  bool _isUploading = false;
  bool _showSummary = true;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload Section
                      _buildUploadSection().animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 28),

                      // Recent Documents
                      if (notesProvider.documents.isNotEmpty)
                        _buildRecentDocuments(notesProvider)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 200.ms),

                      const SizedBox(height: 28),

                      // Latest Summary
                      if (_showSummary)
                        _buildLatestSummary(notesProvider)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 300.ms),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const Text(
            'AI SUMMARIZER',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.accentPink.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: _pickFile,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.cloud_upload_rounded,
                      color: AppColors.accentCyan,
                      size: 40,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              _isUploading ? 'Uploading...' : 'Upload PDF',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'MAX FILE SIZE: 25MB',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDocuments(NotesProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Documents',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'SEE ALL',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.documents.length,
            itemBuilder: (context, index) {
              final doc = provider.documents[index];
              final colors = [
                [AppColors.primary, AppColors.primaryLight],
                [AppColors.accentPink, AppColors.accentPink.withOpacity(0.7)],
                [AppColors.accentCyan, AppColors.accentCyan.withOpacity(0.7)],
              ];
              final colorPair = colors[index % colors.length];

              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPair[0].withOpacity(0.3),
                      colorPair[1].withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorPair[0].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_rounded,
                      color: colorPair[0],
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        doc.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestSummary(NotesProvider provider) {
    // Check if documents list is empty
    if (provider.documents.isEmpty) {
      return const SizedBox.shrink();
    }

    final latestDoc = provider.documents.firstWhere(
      (doc) => doc.summary != null,
      orElse: () => provider.documents.first,
    );

    if (latestDoc.summary == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Summary',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          latestDoc.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'SUMMARIZED 2M AGO',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Summary Content with Highlights
              _buildHighlightedText(
                  latestDoc.summary!.content, latestDoc.summary!.keyHighlights),

              const SizedBox(height: 20),

              // Key Concepts
              Text(
                'KEY CONCEPTS IDENTIFIED',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: latestDoc.summary!.keyConcepts.map((concept) {
                  final colors = [
                    AppColors.accentCyan,
                    AppColors.accentPink,
                    AppColors.primary
                  ];
                  final index = latestDoc.summary!.keyConcepts.indexOf(concept);
                  return ConceptChip(
                    text: concept,
                    color: colors[index % colors.length],
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      Icons.copy_rounded,
                      'COPY',
                      () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      Icons.share_rounded,
                      'SHARE',
                      () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightedText(String text, List<String> highlights) {
    // Split text into paragraphs - handle both \n\n and single \n
    final paragraphs =
        text.split('\n').where((p) => p.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.7,
                letterSpacing: 0.2,
              ),
              children: _buildTextSpans(paragraph.trim(), highlights),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<TextSpan> _buildTextSpans(String text, List<String> highlights) {
    List<TextSpan> spans = [];
    String remainingText = text;

    while (remainingText.isNotEmpty) {
      int earliestIndex = remainingText.length;
      String? foundHighlight;

      for (final highlight in highlights) {
        final index =
            remainingText.toLowerCase().indexOf(highlight.toLowerCase());
        if (index != -1 && index < earliestIndex) {
          earliestIndex = index;
          foundHighlight = highlight;
        }
      }

      if (foundHighlight != null && earliestIndex < remainingText.length) {
        // Add text before highlight
        if (earliestIndex > 0) {
          spans.add(TextSpan(text: remainingText.substring(0, earliestIndex)));
        }

        // Add highlighted text
        spans.add(TextSpan(
          text: remainingText.substring(
              earliestIndex, earliestIndex + foundHighlight.length),
          style: TextStyle(
            color: AppColors.accentPink,
            fontWeight: FontWeight.w600,
            backgroundColor: AppColors.accentPink.withOpacity(0.2),
          ),
        ));

        remainingText =
            remainingText.substring(earliestIndex + foundHighlight.length);
      } else {
        spans.add(TextSpan(text: remainingText));
        break;
      }
    }

    return spans;
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    setState(() => _isUploading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'ppt', 'pptx'],
        withData: true, // This loads file bytes for web
      );

      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uploading $fileName...'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );

        // Upload PDF to backend using bytes (web-compatible)
        final uploadResult =
            await ApiService().uploadPdfBytes(fileBytes, fileName);
        final extractedText = uploadResult['text'] as String;

        if (extractedText.isEmpty) {
          throw Exception('No text could be extracted from the file');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Generating AI summary...'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );

        // Generate comprehensive summary with longer length
        final summaryResult = await ApiService().summarizeText(
          extractedText,
          maxLength: 500, // Longer, more detailed summary
          minLength: 200,
        );

        // Create document with summary
        final newDoc = Document(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: fileName,
          path: '', // Empty path for web uploads
          uploadedAt: DateTime.now(),
          summary: Summary(
            content: summaryResult.summary,
            keyHighlights:
                summaryResult.keyConcepts, // Use keyConcepts from API
            keyConcepts: summaryResult.keyConcepts,
            generatedAt: DateTime.now(),
          ),
        );

        // Add to provider
        final notesProvider =
            Provider.of<NotesProvider>(context, listen: false);
        notesProvider.addDocument(newDoc);
        notesProvider.setSelectedDocument(newDoc);

        setState(() {
          _showSummary = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Summary generated successfully!'),
            backgroundColor: AppColors.accentGreen,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Upload Error: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: AppColors.accentRed,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }
}
