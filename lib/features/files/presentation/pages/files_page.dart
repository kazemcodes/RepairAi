import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pdf_viewer_widget.dart';
import '../../../../shared/widgets/boardview_file_viewer.dart';

/// Files Page - displays PDF and PCB files and allows viewing them
class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  List<_FileItem> _files = [];
  bool _isLoading = true;
  String? _selectedFilePath;
  _FileType? _selectedFileType;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    
    final List<_FileItem> files = [];
    
    // Define supported file extensions
    final pdfExtensions = ['.pdf'];
    final pcbExtensions = ['.pcbdoc', '.brd', '.bdv', '.asc', '.fz'];
    
    // Load from data directory (assets)
    try {
      final dataDir = Directory('data');
      if (await dataDir.exists()) {
        await for (final entity in dataDir.list()) {
          if (entity is File) {
            final lowerPath = entity.path.toLowerCase();
            if (pdfExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(
                name: fileName,
                path: entity.path,
                fileType: _FileType.pdf,
              ));
            } else if (pcbExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(
                name: fileName,
                path: entity.path,
                fileType: _FileType.pcb,
              ));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading data directory: $e');
    }
    
    // Load from repairai-files directory
    try {
      final filesDir = Directory('repairai-files');
      if (await filesDir.exists()) {
        await for (final entity in filesDir.list(recursive: true)) {
          if (entity is File) {
            final lowerPath = entity.path.toLowerCase();
            if (pdfExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(
                name: fileName,
                path: entity.path,
                fileType: _FileType.pdf,
              ));
            } else if (pcbExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(
                name: fileName,
                path: entity.path,
                fileType: _FileType.pcb,
              ));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading repairai-files directory: $e');
    }
    
    setState(() {
      _files = files;
      _isLoading = false;
    });
  }

  void _openFile(_FileItem file) {
    setState(() {
      _selectedFilePath = file.path;
      _selectedFileType = file.fileType;
    });
  }

  void _closeFile() {
    setState(() {
      _selectedFilePath = null;
      _selectedFileType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // If a file is selected, show the appropriate viewer
    if (_selectedFilePath != null) {
      if (_selectedFileType == _FileType.pdf) {
        return Stack(
          children: [
            PdfViewerWidget(
              filePath: _selectedFilePath!,
              title: _selectedFilePath!.split(Platform.pathSeparator).last,
              isFromUrl: false,
            ),
            Positioned(
              top: 60,
              left: 8,
              child: FloatingActionButton.small(
                onPressed: _closeFile,
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        );
      } else if (_selectedFileType == _FileType.pcb) {
        return Stack(
          children: [
            BoardviewFileViewer(
              filePath: _selectedFilePath!,
              title: _selectedFilePath!.split(Platform.pathSeparator).last,
            ),
            Positioned(
              top: 60,
              left: 8,
              child: FloatingActionButton.small(
                onPressed: _closeFile,
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        );
      }
    }
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, isDark),
          
          // Content
          Expanded(
            child: _isLoading 
                ? _buildLoadingView(isDark)
                : _files.isEmpty 
                    ? _buildEmptyView(isDark)
                    : _buildFilesList(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Icon(
            Icons.folder_open,
            size: 28,
            color: isDark ? AppColors.primaryLight : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Files',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const Spacer(),
          // Refresh button
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            onPressed: _loadFiles,
            tooltip: 'Refresh',
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
            'Loading files...',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No files found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add PDF or PCB files to the data folder',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesList(BuildContext context, bool isDark) {
    // Group files by type
    final pdfFiles = _files.where((f) => f.fileType == _FileType.pdf).toList();
    final pcbFiles = _files.where((f) => f.fileType == _FileType.pcb).toList();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // PDF Section
        if (pdfFiles.isNotEmpty) ...[
          _buildSectionHeader('PDF Documents', Icons.picture_as_pdf, isDark),
          ...pdfFiles.map((file) => _buildFileCard(context, isDark, file)),
          const SizedBox(height: 24),
        ],
        
        // PCB Section
        if (pcbFiles.isNotEmpty) ...[
          _buildSectionHeader('PCB/BoardView Files', Icons.developer_board, isDark),
          ...pcbFiles.map((file) => _buildFileCard(context, isDark, file)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, bool isDark, _FileItem file) {
    final isPcb = file.fileType == _FileType.pcb;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: InkWell(
        onTap: () => _openFile(file),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // File Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPcb ? Colors.blue.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isPcb ? Icons.developer_board : Icons.picture_as_pdf,
                  color: isPcb ? Colors.blue.shade400 : Colors.red.shade400,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPcb ? 'PCB/BoardView File' : 'PDF Document',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Open icon
              Icon(
                Icons.open_in_new,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _FileType { pdf, pcb }

class _FileItem {
  final String name;
  final String path;
  final _FileType fileType;

  _FileItem({
    required this.name,
    required this.path,
    required this.fileType,
  });
}
