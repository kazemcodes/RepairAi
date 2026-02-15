import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Boardview File Viewer Widget - displays PCB/BoardView files
/// Supports: .pcbdoc, .brd, .bdv, .asc, .fz files
class BoardviewFileViewer extends StatefulWidget {
  final String filePath;
  final String? title;

  const BoardviewFileViewer({
    super.key,
    required this.filePath,
    this.title,
  });

  @override
  State<BoardviewFileViewer> createState() => _BoardviewFileViewerState();
}

class _BoardviewFileViewerState extends State<BoardviewFileViewer> {
  String? _fileContent;
  String? _errorMessage;
  bool _isLoading = true;
  _FileFormat? _detectedFormat;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    try {
      final file = File(widget.filePath);
      if (!await file.exists()) {
        setState(() {
          _errorMessage = 'File not found';
          _isLoading = false;
        });
        return;
      }

      // Detect file format based on extension
      final ext = widget.filePath.toLowerCase();
      _FileFormat format;
      if (ext.endsWith('.pcbdoc')) {
        format = _FileFormat.pcbdoc;
      } else if (ext.endsWith('.brd')) {
        format = _FileFormat.brd;
      } else if (ext.endsWith('.bdv') || ext.endsWith('.bv')) {
        format = _FileFormat.bdv;
      } else if (ext.endsWith('.asc')) {
        format = _FileFormat.asc;
      } else if (ext.endsWith('.fz')) {
        format = _FileFormat.fz;
      } else {
        format = _FileFormat.unknown;
      }

      // Try to read file content
      // Note: Most PCB formats are binary, so we'll show appropriate message
      try {
        final content = await file.readAsString();
        setState(() {
          _fileContent = content;
          _detectedFormat = format;
          _isLoading = false;
        });
      } catch (e) {
        // Binary file - show format info instead
        setState(() {
          _detectedFormat = format;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading file: $e';
        _isLoading = false;
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
          // Toolbar
          _buildToolbar(context, isDark),
          
          // Content
          Expanded(
            child: _isLoading
                ? _buildLoadingView(isDark)
                : _errorMessage != null
                    ? _buildErrorView(isDark)
                    : _buildContentView(isDark),
          ),
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
              widget.title ?? 'PCB Viewer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Format indicator
          if (_detectedFormat != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getFormatName(_detectedFormat!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
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
            'Loading PCB file...',
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
            'Error loading file',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentView(bool isDark) {
    // Check if we have text content (ASCII format)
    if (_fileContent != null && _fileContent!.isNotEmpty) {
      return _buildAsciiContentView(isDark);
    }
    
    // Binary format - show info and conversion guidance
    return _buildBinaryFormatView(isDark);
  }

  Widget _buildAsciiContentView(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File info header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.developer_board,
                      color: Colors.blue.shade400,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PCB Board File',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            _getFormatName(_detectedFormat ?? _FileFormat.unknown),
                            style: TextStyle(
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // ASCII content preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              _fileContent!.length > 10000 
                  ? '${_fileContent!.substring(0, 10000)}...\n\n[Content truncated - file too large]'
                  : _fileContent!,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: isDark ? Colors.green.shade300 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBinaryFormatView(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.developer_board,
              size: 64,
              color: Colors.blue.shade400,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'PCB Board File',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Format badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getFormatName(_detectedFormat ?? _FileFormat.unknown),
              style: TextStyle(
                color: Colors.blue.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Info cards
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.info_outline,
            title: 'Binary Format',
            description: 'This is a binary PCB file that cannot be directly displayed as text.',
          ),
          
          const SizedBox(height: 16),
          
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.transform,
            title: 'Conversion Required',
            description: 'To view this file in the interactive boardview, convert it to JSON format.',
          ),
          
          const SizedBox(height: 16),
          
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.lightbulb_outline,
            title: 'How to Convert',
            description: _getConversionInstructions(),
          ),
          
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Open conversion dialog
                  _showConversionDialog(context);
                },
                icon: const Icon(Icons.transform),
                label: const Text('Convert to BoardView'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isDark ? AppColors.primaryLight : AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConversionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.transform, color: Colors.blue),
            SizedBox(width: 12),
            Text('Convert to BoardView'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To view this PCB file in the interactive boardview:',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            _buildStep('1', 'Export to ASCII format from your PCB software'),
            _buildStep('2', 'Use the boardview converter tool'),
            _buildStep('3', 'Place the JSON file in the correct directory'),
            const SizedBox(height: 16),
            Text(
              'Supported export formats:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• .asc (ASCII)'),
            Text('• .brd (Cadence Allegro)'),
            Text('• .bdv (Board View)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.blue.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormatName(_FileFormat format) {
    switch (format) {
      case _FileFormat.pcbdoc:
        return 'Altium Designer PCB';
      case _FileFormat.brd:
        return 'Cadence Allegro Board';
      case _FileFormat.bdv:
        return 'Board View';
      case _FileFormat.asc:
        return 'ASCII Board';
      case _FileFormat.fz:
        return 'Target 3001! Board';
      case _FileFormat.unknown:
        return 'Unknown Format';
    }
  }

  String _getConversionInstructions() {
    if (_detectedFormat == _FileFormat.pcbdoc) {
      return 'In Altium Designer: File → Export → Export to CAD → Select ASCII format → Save as .asc file';
    } else if (_detectedFormat == _FileFormat.brd) {
      return 'In Cadence Allegro: File → Export → CAD → Select ASCII format';
    } else {
      return 'Use the scraper tool: node src/index.js boardview-convert --input file --output ./output';
    }
  }
}

enum _FileFormat {
  pcbdoc,
  brd,
  bdv,
  asc,
  fz,
  unknown,
}
