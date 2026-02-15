import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';

/// PDF Viewer Widget - displays PDF files with zoom, pan, and page navigation
/// Uses Syncfusion PDF Viewer which supports all platforms including Windows
class PdfViewerWidget extends StatefulWidget {
  final String filePath;
  final String? title;
  final bool isFromUrl;

  const PdfViewerWidget({
    super.key,
    required this.filePath,
    this.title,
    this.isFromUrl = false,
  });

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final PdfViewerController _pdfController = PdfViewerController();
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String _errorMessage = '';
  String? _localPath;

  @override
  void initState() {
    super.initState();
    if (widget.isFromUrl) {
      _loadPdfFromUrl();
    } else {
      _localPath = widget.filePath;
      _isReady = true;
    }
  }

  Future<void> _loadPdfFromUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.filePath));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/temp_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(response.bodyBytes);
        if (mounted) {
          setState(() {
            _localPath = file.path;
            _isReady = true;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to download PDF: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading PDF: $e';
      });
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    // Clean up temp file
    if (_localPath != null && _localPath!.contains('temp_pdf_')) {
      try {
        File(_localPath!).deleteSync();
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: Column(
        children: [
          // PDF Toolbar
          _buildToolbar(context, isDark),
          
          // PDF View
          Expanded(
            child: _errorMessage.isNotEmpty
                ? _buildErrorView(isDark)
                : _buildPdfView(isDark),
          ),
          
          // Page Indicator
          if (_isReady && _totalPages > 0)
            _buildPageIndicator(isDark),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, bool isDark) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text(
              widget.title ?? 'PDF Viewer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Page navigation
          if (_isReady && _totalPages > 0) ...[
            IconButton(
              icon: Icon(
                Icons.first_page,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage > 0
                  ? () => _pdfController.jumpToPage(1)
                  : null,
              tooltip: 'First page',
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage > 0
                  ? () => _pdfController.previousPage()
                  : null,
              tooltip: 'Previous page',
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage < _totalPages
                  ? () => _pdfController.nextPage()
                  : null,
              tooltip: 'Next page',
            ),
            IconButton(
              icon: Icon(
                Icons.last_page,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage < _totalPages
                  ? () => _pdfController.jumpToPage(_totalPages)
                  : null,
              tooltip: 'Last page',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPdfView(bool isDark) {
    if (!_isReady || _localPath == null) {
      return _buildLoadingView(isDark);
    }
    
    return SfPdfViewer.file(
      File(_localPath!),
      controller: _pdfController,
      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
        setState(() {
          _totalPages = details.document.pages.count;
          _isReady = true;
        });
      },
      onPageChanged: (PdfPageChangedDetails details) {
        setState(() {
          _currentPage = details.newPageNumber;
        });
      },
    );
  }

  Widget _buildLoadingView(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isDark ? AppColors.primaryLight : AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading PDF...',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading PDF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isDark) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Page $_currentPage of $_totalPages',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
