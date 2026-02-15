import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';

/// PDF Viewer Widget - displays PDF files with zoom, pan, and page navigation
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
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String _errorMessage = '';
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    if (widget.isFromUrl) {
      _loadPdfFromUrl();
    }
  }

  Future<void> _loadPdfFromUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.filePath));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/temp_pdf.pdf');
        await file.writeAsBytes(response.bodyBytes);
        if (mounted) {
          setState(() {});
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to download PDF';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading PDF: $e';
      });
    }
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
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          ),
          
          const SizedBox(width: 8),
          
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
                  ? () => _pdfController?.setPage(0)
                  : null,
              tooltip: 'First page',
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage > 0
                  ? () => _pdfController?.setPage(_currentPage - 1)
                  : null,
              tooltip: 'Previous page',
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage < _totalPages - 1
                  ? () => _pdfController?.setPage(_currentPage + 1)
                  : null,
              tooltip: 'Next page',
            ),
            IconButton(
              icon: Icon(
                Icons.last_page,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _currentPage < _totalPages - 1
                  ? () => _pdfController?.setPage(_totalPages - 1)
                  : null,
              tooltip: 'Last page',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPdfView(bool isDark) {
    final path = widget.isFromUrl 
        ? '${Directory.systemTemp.path}/temp_pdf.pdf'
        : widget.filePath;
    final file = File(path);
    
    if (!file.existsSync()) {
      return _buildLoadingView(isDark);
    }
    
    return Stack(
      children: [
        PDFView(
          filePath: path,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          onRender: (pages) {
            setState(() {
              _totalPages = pages ?? 0;
              _isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              _errorMessage = error.toString();
            });
          },
          onPageError: (page, error) {
            setState(() {
              _errorMessage = 'Error on page $page: $error';
            });
          },
          onViewCreated: (PDFViewController controller) {
            _pdfController = controller;
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              _currentPage = page ?? 0;
              _totalPages = total ?? 0;
            });
          },
        ),
        if (!_isReady && _errorMessage.isEmpty)
          _buildLoadingView(isDark),
      ],
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
            'Page ${_currentPage + 1} of $_totalPages',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
