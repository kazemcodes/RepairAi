import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import '../../../../shared/services/github_service.dart';
import '../../../../shared/services/ai_service.dart';
import '../../../../shared/widgets/pdf_viewer_widget.dart';
import '../../../../shared/widgets/boardview_file_viewer.dart';
import '../../../../core/theme/app_colors.dart';

/// Glassmorphism Container - Modern frosted glass effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? borderColor;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border: Border.all(
                color: borderColor ?? (isDark ? Colors.white24 : Colors.black12),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Modern Gradient Card with glass effect
class GlassGradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isSelected;

  const GlassGradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Colors.white, Color(0xFFF8FAFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: margin ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : (gradient ?? defaultGradient),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.5) 
                : (isDark ? Colors.white12 : Colors.black12),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern Icon Button with gradient
class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double size;
  final Color? color;

  const GradientIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  icon,
                  color: color ?? Colors.white,
                  size: size * 0.5,
                ),
        ),
      ),
    );
  }
}

/// Combined Schematic + Solution + Chat Page
class DeviceRepairPage extends ConsumerStatefulWidget {
  const DeviceRepairPage({super.key});

  @override
  ConsumerState<DeviceRepairPage> createState() => _DeviceRepairPageState();
}

class _DeviceRepairPageState extends ConsumerState<DeviceRepairPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Model selection
  List<Manufacturer> _manufacturers = [];
  String? _selectedManufacturer;
  String? _selectedModel;
  
  // Quick Diagnosis - Symptom-based navigation
  String? _selectedSymptom;
  bool _isAnalyzingSymptom = false;
  static const List<String> _commonSymptoms = [
    "Won't turn on",
    "No display",
    "Not charging",
    "No sound",
    "WiFi/Bluetooth issues",
    "Camera not working",
    "Overheating",
    "No SIM detected",
    "Touch not working",
    "Battery drain",
  ];
  
  // Symptom to component mapping for AI context
  static const Map<String, List<String>> _symptomComponents = {
    "Won't turn on": ["PMIC", "Power button", "Battery connector", "Charging IC"],
    "No display": ["Display connector", "Backlight IC", "Display driver"],
    "Not charging": ["Charging IC", "USB connector", "Charging coil", "PMIC"],
    "No sound": ["Audio IC", "Speaker connector", "Microphone"],
    "WiFi/Bluetooth issues": ["WiFi module", "Antenna", "RF section"],
    "Camera not working": ["Camera connector", "Camera IC", "MIPI lines"],
    "Overheating": ["PMIC", "CPU/GPU", "Charging IC", "Short circuit"],
    "No SIM detected": ["SIM reader", "Baseband processor", "Antenna"],
    "Touch not working": ["Touch controller", "Display connector", "Digitizer"],
    "Battery drain": ["PMIC", "Leaking capacitor", "Background processes"],
  };
  
  // Schematics
  List<IndexEntry> _schematics = [];
  String? _selectedSchematic;
  String? _schematicContent;
  
  // Solutions
  List<IndexEntry> _solutions = [];
  String? _selectedSolution;
  
  // Chat
  final _chatController = TextEditingController();
  final _chatScrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoadingChat = false;

  // Files Tab
  List<_FileItem> _filesTabFiles = [];
  bool _filesTabLoading = true;
  String? _selectedFilePath;
  _FileType? _selectedFileType;
  
  // Unified Search
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  List<_SearchResult> _searchResults = [];
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadManufacturers();
    
    // Listen to search input changes
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query != _searchQuery.toLowerCase()) {
      setState(() {
        _searchQuery = query;
        _updateSearchResults();
      });
    }
  }
  
  void _updateSearchResults() {
    if (_searchQuery.isEmpty) {
      _searchResults = [];
      _showSearchResults = false;
      return;
    }
    
    final results = <_SearchResult>[];
    
    // Search manufacturers and models
    for (final manu in _manufacturers) {
      // Check manufacturer name
      if (manu.name.toLowerCase().contains(_searchQuery)) {
        for (final model in manu.models) {
          results.add(_SearchResult(
            type: _SearchResultType.device,
            title: '${manu.name} $model',
            subtitle: 'Device',
            manufacturer: manu.name,
            model: model,
          ));
        }
      } else {
        // Check individual models
        for (final model in manu.models) {
          if (model.toLowerCase().contains(_searchQuery)) {
            results.add(_SearchResult(
              type: _SearchResultType.device,
              title: '${manu.name} $model',
              subtitle: 'Device',
              manufacturer: manu.name,
              model: model,
            ));
          }
        }
      }
    }
    
    // Search symptoms
    for (final symptom in _commonSymptoms) {
      if (symptom.toLowerCase().contains(_searchQuery)) {
        results.add(_SearchResult(
          type: _SearchResultType.symptom,
          title: symptom,
          subtitle: 'Quick Diagnosis',
          symptom: symptom,
        ));
      }
    }
    
    // Search schematics (if model selected)
    for (final schematic in _schematics) {
      final fileName = schematic.path.split('/').last.toLowerCase();
      final index = schematic.index?.toLowerCase() ?? '';
      
      if (fileName.contains(_searchQuery) || index.contains(_searchQuery)) {
        results.add(_SearchResult(
          type: _SearchResultType.schematic,
          title: schematic.path.split('/').last,
          subtitle: schematic.index ?? 'Schematic File',
          schematicPath: schematic.path,
        ));
      }
    }
    
    setState(() {
      _searchResults = results.take(10).toList(); // Limit to 10 results
      _showSearchResults = results.isNotEmpty;
    });
  }
  
  void _onSearchResultSelected(_SearchResult result) {
    _searchController.clear();
    _searchQuery = '';
    _showSearchResults = false;
    _searchFocusNode.unfocus();
    
    switch (result.type) {
      case _SearchResultType.device:
        setState(() {
          _selectedManufacturer = result.manufacturer;
          _selectedModel = result.model;
        });
        _loadFilesForModel();
        break;
      case _SearchResultType.symptom:
        if (_selectedModel != null) {
          _onSymptomSelected(result.symptom!);
        } else if (_manufacturers.isNotEmpty) {
          // Select first available device then trigger symptom
          setState(() {
            _selectedManufacturer = _manufacturers.first.name;
            _selectedModel = _manufacturers.first.models.first;
          });
          _loadFilesForModel().then((_) {
            _onSymptomSelected(result.symptom!);
          });
        }
        break;
      case _SearchResultType.schematic:
        if (result.schematicPath != null) {
          setState(() {
            _selectedFilePath = result.schematicPath;
            _selectedFileType = _determineFileType(result.schematicPath!);
          });
        }
        break;
    }
  }
  
  /// Determine file type from path
  _FileType _determineFileType(String path) {
    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.pdf')) return _FileType.pdf;
    if (lowerPath.endsWith('.brd')) return _FileType.pcb;
    if (lowerPath.endsWith('.md') || lowerPath.endsWith('.txt')) return _FileType.md;
    if (lowerPath.endsWith('.png') || lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg') || lowerPath.endsWith('.gif')) return _FileType.image;
    if (lowerPath.contains('/boardview/') || lowerPath.endsWith('.bdv')) return _FileType.boardview;
    return _FileType.md;
  }

  // Load files when model is first selected

  static const String _cacheKey = 'manufacturers_cache';
  
  Future<void> _loadManufacturers() async {
    // First try to load from cache
    await _loadFromCache();
    
    // Then try to refresh from GitHub
    try {
      final github = ref.read(githubServiceProvider);
      final index = await github.fetchIndex();
      
      if (!mounted) return;
      
      // Group by manufacturer
      final Map<String, Set<String>> manuModels = {};
      for (final schematic in index.schematics) {
        final parts = schematic.path.split('/');
        if (parts.length >= 2) {
          final manu = parts[0];
          final model = parts[1];
          manuModels.putIfAbsent(manu, () => {});
          manuModels[manu]!.add(model);
        }
      }
      
      setState(() {
        _manufacturers = manuModels.entries
            .map((e) => Manufacturer(name: e.key, models: e.value.toList()))
            .toList();
        
        // Sort manufacturers and models alphabetically
        _manufacturers.sort((a, b) => a.name.compareTo(b.name));
        for (var m in _manufacturers) {
          m.models.sort();
        }
        
        if (_manufacturers.isNotEmpty) {
          _selectedManufacturer = _manufacturers.first.name;
          _selectedModel = _manufacturers.first.models.first;
          _loadFilesForModel();
        }
      });
      
      // Save to cache
      await _saveToCache();
    } catch (e) {
      // If network fails, we still have cached data
      debugPrint('Error refreshing manufacturers: $e');
    }
  }

  // Load files for Files tab
  Future<void> _loadFilesTab() async {
    final List<_FileItem> files = [];
    
    final pdfExtensions = ['.pdf'];
    final pcbExtensions = ['.pcbdoc', '.brd', '.bdv', '.asc', '.fz'];
    
    try {
      final dataDir = Directory('data');
      if (await dataDir.exists()) {
        await for (final entity in dataDir.list()) {
          if (entity is File) {
            final lowerPath = entity.path.toLowerCase();
            if (pdfExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(name: fileName, path: entity.path, fileType: _FileType.pdf));
            } else if (pcbExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(name: fileName, path: entity.path, fileType: _FileType.pcb));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading data directory: $e');
    }
    
    try {
      final filesDir = Directory('repairai-files');
      if (await filesDir.exists()) {
        await for (final entity in filesDir.list(recursive: true)) {
          if (entity is File) {
            final lowerPath = entity.path.toLowerCase();
            if (pdfExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(name: fileName, path: entity.path, fileType: _FileType.pdf));
            } else if (pcbExtensions.any((ext) => lowerPath.endsWith(ext))) {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              files.add(_FileItem(name: fileName, path: entity.path, fileType: _FileType.pcb));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading repairai-files directory: $e');
    }
    
    setState(() {
      _filesTabFiles = files;
      _filesTabLoading = false;
    });
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final List<dynamic> decoded = jsonDecode(cached);
        setState(() {
          _manufacturers = decoded
              .map((e) => Manufacturer(name: e['name'], models: List<String>.from(e['models'])))
              .toList();
          
          if (_manufacturers.isNotEmpty && _selectedManufacturer == null) {
            _selectedManufacturer = _manufacturers.first.name;
            _selectedModel = _manufacturers.first.models.first;
            _loadFilesForModel();
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading from cache: $e');
    }
  }

  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        _manufacturers.map((e) => {'name': e.name, 'models': e.models}).toList(),
      );
      await prefs.setString(_cacheKey, encoded);
    } catch (e) {
      debugPrint('Error saving to cache: $e');
    }
  }

  String get _filesCacheKey => 'files_cache_${_selectedManufacturer}_$_selectedModel';
  
  Future<void> _loadFilesForModel() async {
    if (_selectedModel == null) return;
    
    // First try to load from cache
    await _loadFilesFromCache();
    
    // Then refresh from GitHub
    try {
      final github = ref.read(githubServiceProvider);
      final index = await github.fetchIndex();
      
      if (!mounted) return;
      
      setState(() {
        // Filter schematics for selected model - markdown, text, and boardview files
        _schematics = index.schematics
            .where((s) => s.path.contains('/$_selectedModel/') && 
                (s.path.endsWith('.md') || 
                 s.path.endsWith('.txt') || 
                 s.path.contains('/boardview/')))
            .toList();
        
        // Also include PDF, image, and BRD files in list for display
        final allSchematics = index.schematics
            .where((s) => s.path.contains('/$_selectedModel/'))
            .toList();
        
        // Merge with non-text files (PDF, images, BRD, boardview, etc.)
        for (var schematic in allSchematics) {
          if (!schematic.path.endsWith('.md') && !schematic.path.endsWith('.txt')) {
            if (!_schematics.any((s) => s.path == schematic.path)) {
              _schematics.add(schematic);
            }
          }
        }
        
        // Mark files tab as loaded
        _filesTabLoading = false;
        
        // Filter solutions for selected model
        _solutions = index.solutions
            .where((s) => s.path.contains('/$_selectedModel/'))
            .toList();
        
        // Auto-select first text-based schematic
        if (_schematics.isNotEmpty) {
          final textFile = _schematics.firstWhere(
            (s) => s.path.endsWith('.md') || s.path.endsWith('.txt'),
            orElse: () => _schematics.first,
          );
          _selectedSchematic = textFile.path;
          if (textFile.path.endsWith('.md') || textFile.path.endsWith('.txt')) {
            _loadSchematicContent(textFile.path);
          } else {
            setState(() {
              _schematicContent = null;
            });
          }
        }
      });
      
      // Save to cache
      await _saveFilesToCache();
    } catch (e) {
      // If network fails, we still have cached data
      debugPrint('Error refreshing files: $e');
    }
  }

  Future<void> _loadFilesFromCache() async {
    if (_selectedModel == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_filesCacheKey);
      if (cached != null) {
        final Map<String, dynamic> decoded = jsonDecode(cached);
        setState(() {
          _schematics = (decoded['schematics'] as List)
              .map((e) => IndexEntry(
                    path: e['path'],
                    type: 'schematic',
                    index: e['index'],
                  ))
              .toList();
          _solutions = (decoded['solutions'] as List)
              .map((e) => IndexEntry(
                    path: e['path'],
                    type: 'solution',
                  ))
              .toList();
          
          if (_schematics.isNotEmpty && _selectedSchematic == null) {
            _selectedSchematic = _schematics.first.path;
            _loadSchematicContent(_schematics.first.path);
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading files from cache: $e');
    }
  }

  Future<void> _saveFilesToCache() async {
    if (_selectedModel == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode({
        'schematics': _schematics.map((s) => {'path': s.path, 'index': s.index}).toList(),
        'solutions': _solutions.map((s) => {'path': s.path}).toList(),
      });
      await prefs.setString(_filesCacheKey, encoded);
    } catch (e) {
      debugPrint('Error saving files to cache: $e');
    }
  }

  Future<void> _loadSchematicContent(String path) async {
    try {
      final github = ref.read(githubServiceProvider);
      final url = github.getRawFileUrl(path);
      final response = await http.get(Uri.parse(url));
      
      if (!mounted) return;
      
      setState(() {
        _schematicContent = response.body;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _openExternalViewer(String path) async {
    final github = ref.read(githubServiceProvider);
    final url = github.getRawFileUrl(path);
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      debugPrint('Error opening external viewer: $e');
    }
  }

  Future<void> _openBrdFile(String path) async {
    // Extract manufacturer and model from path
    // Expected format: manufacturer/model/...
    final pathParts = path.split('/');
    if (pathParts.length >= 2) {
      final manufacturer = pathParts[0];
      final model = pathParts[1];
      
      // Try to navigate to schematic page with boardview
      // For now, open the raw file in browser
      final github = ref.read(githubServiceProvider);
      final url = github.getRawFileUrl(path);
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        debugPrint('Error opening BRD file: $e');
      }
    }
  }

  Future<void> _openBoardviewFile(String path) async {
    // Extract manufacturer and model from path
    // Expected format: manufacturer/model/boardview/boardview.json
    final pathParts = path.split('/');
    if (pathParts.length >= 2) {
      final manufacturer = pathParts[0];
      final model = pathParts[1];
      
      // Navigate to schematic page to view boardview
      if (mounted) {
        // TODO: Navigate to schematic page with boardview viewer
        // For now, show a message or open in external viewer
        final github = ref.read(githubServiceProvider);
        final url = github.getRawFileUrl(path);
        try {
          await launchUrl(Uri.parse(url));
        } catch (e) {
          debugPrint('Error opening boardview file: $e');
        }
      }
    }
  }

  Future<void> _sendChatMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty || _isLoadingChat) return;

    _chatController.clear();
    
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(
        role: 'user',
        content: message,
        timestamp: DateTime.now(),
      ));
      _isLoadingChat = true;
    });
    
    _scrollToBottom();
    
    try {
      // Build enhanced context from current device schematics
      String contextInfo = '';
      if (_selectedModel != null) {
        // Only include markdown and text files in AI context
        final markdownFiles = _schematics
            .where((s) => s.path.endsWith('.md') || s.path.endsWith('.txt'))
            .toList();
        
        // Get PDF and boardview files for reference
        final pdfFiles = _schematics.where((s) => s.path.endsWith('.pdf')).toList();
        final boardviewFiles = _schematics.where((s) => s.path.contains('/boardview/')).toList();
        
        contextInfo = '''
Current Device Context:
- Manufacturer: $_selectedManufacturer
- Model: $_selectedModel
${_selectedSymptom != null ? '- Active Symptom: $_selectedSymptom' : ''}

Available Documentation:
${markdownFiles.isNotEmpty ? 'Markdown Files:\n${markdownFiles.map((s) => '- ${s.path}: ${s.index ?? ""}').join('\n')}' : 'No markdown files available'}

${pdfFiles.isNotEmpty ? 'PDF Schematics: ${pdfFiles.length} files available' : ''}
${boardviewFiles.isNotEmpty ? 'BoardView Files: ${boardviewFiles.length} files available' : ''}
''';
        
        if (_schematicContent != null && _schematicContent!.isNotEmpty) {
          // Include relevant portion of schematic content (limit to avoid token limits)
          final contentPreview = _schematicContent!.length > 3000 
              ? '${_schematicContent!.substring(0, 3000)}...\n[Content truncated for analysis]'
              : _schematicContent!;
          contextInfo += '\nCurrent Schematic Content:\n$contentPreview';
        }
      }

      final aiService = ref.read(aiServiceProvider);
      final prompt = '''
You are RepairAI, an expert mobile repair technician with 20 years of experience. You help technicians diagnose and repair mobile devices efficiently.

$contextInfo

User Question: $message

Provide a comprehensive response that includes:
1. **Direct Answer**: Address the specific question clearly
2. **Technical Details**: Include relevant voltage values, component locations, or pinouts if applicable
3. **Diagnostic Steps**: If troubleshooting, provide step-by-step measurement procedures
4. **Common Issues**: Mention known failure patterns for this device/model if relevant
5. **Safety Notes**: Any precautions the technician should take

Be concise but thorough. Use bullet points and numbered lists for clarity.
If the question is outside mobile repair scope, politely redirect to repair-related topics.
''';

      final response = await aiService.sendMessage(prompt);
      
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: response,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: 'Error: ${e.toString()}',
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingChat = false);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  /// Handle symptom selection - triggers AI analysis with repair context
  Future<void> _onSymptomSelected(String symptom) async {
    if (_selectedModel == null) return;
    
    setState(() {
      _selectedSymptom = symptom;
      _isAnalyzingSymptom = true;
    });
    
    // Switch to Chat tab to show analysis
    _tabController.animateTo(1);
    
    // Add user message about symptom
    setState(() {
      _messages.add(ChatMessage(
        role: 'user',
        content: '🔍 Quick Diagnosis: $symptom',
        timestamp: DateTime.now(),
      ));
    });
    
    _scrollToBottom();
    
    try {
      // Build enhanced context for symptom-based diagnosis
      final relatedComponents = _symptomComponents[symptom] ?? [];
      final markdownFiles = _schematics
          .where((s) => s.path.endsWith('.md') || s.path.endsWith('.txt'))
          .toList();
      
      String contextInfo = '''
Current Device Context:
- Manufacturer: $_selectedManufacturer
- Model: $_selectedModel
- Reported Symptom: $symptom

Likely Related Components:
${relatedComponents.map((c) => '- $c').join('\n')}

Available Schematics:
${markdownFiles.map((s) => '- ${s.path}: ${s.index ?? ""}').join('\n')}
''';

      if (_schematicContent != null && _schematicContent!.isNotEmpty) {
        contextInfo += '\nCurrent Schematic Content:\n$_schematicContent';
      }

      final aiService = ref.read(aiServiceProvider);
      final prompt = '''
You are RepairAI, an expert mobile repair technician with 20 years of experience.

$contextInfo

The user has selected the symptom: "$symptom"

Provide a comprehensive diagnosis:
1. **Most Likely Faulty Components** (ranked by probability):
   - List the most probable failing components
   - Explain why each could cause this symptom

2. **Test Points to Check**:
   - Specific voltage measurements to take
   - Expected values vs. faulty values
   - Which pins/pads to probe

3. **Step-by-Step Repair Procedure**:
   - Disassembly notes if relevant
   - Component location on board
   - Replacement procedure

4. **Common Pitfalls to Avoid**:
   - Mistakes technicians often make with this issue
   - Related components that could be damaged

Be specific to the $_selectedManufacturer $_selectedModel if information is available.
''';

      final response = await aiService.sendMessage(prompt);
      
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: response,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: 'Error analyzing symptom: ${e.toString()}',
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      if (mounted) {
        setState(() => _isAnalyzingSymptom = false);
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Device Selector with Glass effect
                  GlassCard(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    borderRadius: BorderRadius.circular(20),
                opacity: isDark ? 0.15 : 0.25,
                child: _buildDeviceSelector(isDark),
              ),
              
              // Quick Diagnosis Card - Symptom-based navigation
              if (_selectedModel != null)
                GlassCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(16),
                  opacity: isDark ? 0.12 : 0.2,
                  child: _buildQuickDiagnosisCard(isDark),
                ),
              
              // Tab Bar with Glass effect
              GlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(4),
                borderRadius: BorderRadius.circular(16),
                opacity: isDark ? 0.15 : 0.25,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.black12 : Colors.white24,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on, size: 20),
                            SizedBox(width: 8),
                            Text('Diagnosis'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.build_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Repair'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Reference'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Tab Content
              Expanded(
                child: GlassCard(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(20),
                  opacity: isDark ? 0.15 : 0.25,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDiagnosisTab(isDark),
                      _buildRepairTab(isDark),
                      _buildReferenceTab(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Quick Actions Panel - Floating Action Buttons
          _buildQuickActionsPanel(isDark),
        ],
      ),
    ),
    ),
  );
}
  
  /// Quick Actions Panel - Floating action buttons for common tasks
  Widget _buildQuickActionsPanel(bool isDark) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Measure Button
          _buildQuickActionButton(
            icon: Icons.straighten,
            label: 'Measure',
            color: Colors.green,
            isDark: isDark,
            onTap: () => _tabController.animateTo(2), // Go to Reference tab
          ),
          const SizedBox(height: 8),
          
          // Find Component Button
          _buildQuickActionButton(
            icon: Icons.search,
            label: 'Find',
            color: Colors.blue,
            isDark: isDark,
            onTap: () {
              _searchFocusNode.requestFocus();
            },
          ),
          const SizedBox(height: 8),
          
          // Checklist Button
          _buildQuickActionButton(
            icon: Icons.checklist,
            label: 'Checklist',
            color: Colors.orange,
            isDark: isDark,
            onTap: () => _showChecklistDialog(isDark),
          ),
          const SizedBox(height: 8),
          
          // Main FAB
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => _showQuickActionsMenu(isDark),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.apps, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showQuickActionsMenu(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionItem(
                  icon: Icons.straighten,
                  label: 'Measure',
                  color: Colors.green,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(2);
                  },
                ),
                _buildQuickActionItem(
                  icon: Icons.search,
                  label: 'Find',
                  color: Colors.blue,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _searchFocusNode.requestFocus();
                  },
                ),
                _buildQuickActionItem(
                  icon: Icons.checklist,
                  label: 'Checklist',
                  color: Colors.orange,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _showChecklistDialog(isDark);
                  },
                ),
                _buildQuickActionItem(
                  icon: Icons.compare,
                  label: 'Compare',
                  color: Colors.purple,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement compare feature
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showChecklistDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Row(
          children: [
            Icon(Icons.checklist, color: Colors.orange.shade600),
            const SizedBox(width: 12),
            const Text('Diagnostic Checklist'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChecklistItem('Check battery voltage (3.7V-4.4V)', isDark),
            _buildChecklistItem('Inspect for visible damage', isDark),
            _buildChecklistItem('Check all connectors', isDark),
            _buildChecklistItem('Test with known-good battery', isDark),
            _buildChecklistItem('Check for short circuits', isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChecklistItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_box_outline_blank,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelector(bool isDark) {
    return Column(
      children: [
        // Unified Search Bar
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search device, symptom, or file...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: isDark ? Colors.white54 : Colors.black45,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _showSearchResults = false;
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Refresh button
            GradientIconButton(
              icon: Icons.refresh,
              onPressed: _loadManufacturers,
              size: 48,
            ),
          ],
        ),
        
        // Search Results Dropdown
        if (_showSearchResults && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return _buildSearchResultItem(result, isDark);
              },
            ),
          ),
        
        // Current Selection Display
        if (_selectedModel != null && !_showSearchResults)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone_android, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '$_selectedManufacturer $_selectedModel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildSearchResultItem(_SearchResult result, bool isDark) {
    IconData icon;
    Color color;
    
    switch (result.type) {
      case _SearchResultType.device:
        icon = Icons.phone_android;
        color = Colors.blue;
        break;
      case _SearchResultType.symptom:
        icon = Icons.flash_on;
        color = Colors.orange;
        break;
      case _SearchResultType.schematic:
        icon = Icons.description;
        color = Colors.green;
        break;
    }
    
    return InkWell(
      onTap: () => _onSearchResultSelected(result),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Quick Diagnosis Card - Symptom-based navigation for instant repair guidance
  Widget _buildQuickDiagnosisCard(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              'Quick Diagnosis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            if (_isAnalyzingSymptom)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Select a symptom for instant AI-powered diagnosis:',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        // Symptom chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonSymptoms.map((symptom) {
            final isSelected = _selectedSymptom == symptom;
            return GestureDetector(
              onTap: _isAnalyzingSymptom ? null : () => _onSymptomSelected(symptom),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected 
                      ? null 
                      : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.transparent 
                        : (isDark ? Colors.white24 : Colors.black12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getSymptomIcon(symptom),
                      size: 16,
                      color: isSelected 
                          ? Colors.white 
                          : (isDark ? Colors.white70 : Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      symptom,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected 
                            ? Colors.white 
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  /// Get icon for each symptom type
  IconData _getSymptomIcon(String symptom) {
    switch (symptom) {
      case "Won't turn on":
        return Icons.power_off;
      case "No display":
        return Icons.visibility_off;
      case "Not charging":
        return Icons.battery_alert;
      case "No sound":
        return Icons.volume_off;
      case "WiFi/Bluetooth issues":
        return Icons.wifi_off;
      case "Camera not working":
        return Icons.camera_alt_outlined;
      case "Overheating":
        return Icons.thermostat;
      case "No SIM detected":
        return Icons.sim_card_alert;
      case "Touch not working":
        return Icons.touch_app_outlined;
      case "Battery drain":
        return Icons.battery_saver;
      default:
        return Icons.build;
    }
  }
  
  /// Diagnosis Tab - Symptoms + AI Chat
  Widget _buildDiagnosisTab(bool isDark) {
    return Column(
      children: [
        // Symptom Quick Select
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Diagnosis',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonSymptoms.take(6).map((symptom) {
                  return GestureDetector(
                    onTap: _isAnalyzingSymptom ? null : () => _onSymptomSelected(symptom),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getSymptomIcon(symptom),
                            size: 14,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            symptom,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        
        // Chat Messages
        Expanded(
          child: _buildChatTab(isDark),
        ),
      ],
    );
  }
  
  /// Repair Tab - Files + Schematics
  Widget _buildRepairTab(bool isDark) {
    return _buildFilesTab(isDark);
  }
  
  /// Reference Tab - Quick Reference Cards + Component Info
  Widget _buildReferenceTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Reference Card
          _buildQuickReferenceCard(isDark),
          const SizedBox(height: 24),
          
          // Multimeter Reference
          _buildMultimeterReference(isDark),
          const SizedBox(height: 24),
          
          // Common Components Reference
          _buildCommonComponentsReference(isDark),
        ],
      ),
    );
  }
  
  /// Multimeter Reference Card
  Widget _buildMultimeterReference(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.electrical_services, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Multimeter Reference',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildVoltageRow('V_BAT (Battery)', '3.7V - 4.4V', 'Main battery voltage', isDark),
                _buildVoltageRow('V_SYS (System)', '3.8V - 4.5V', 'System power rail', isDark),
                _buildVoltageRow('V_IO (I/O)', '1.8V / 3.3V', 'GPIO logic level', isDark),
                _buildVoltageRow('5V_BOOST', '5.0V ±0.2V', 'USB/OTG power', isDark),
                _buildVoltageRow('1.8V_ALWAYS', '1.8V', 'Always-on rail', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVoltageRow(String name, String value, String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Common Components Reference
  Widget _buildCommonComponentsReference(bool isDark) {
    final components = [
      {'name': 'PMIC', 'full': 'Power Management IC', 'function': 'Power distribution, charging'},
      {'name': 'AP', 'full': 'Application Processor', 'function': 'Main CPU/GPU'},
      {'name': 'BP', 'full': 'Baseband Processor', 'function': 'Cellular connectivity'},
      {'name': 'WLAN', 'full': 'WiFi/Bluetooth Module', 'function': 'Wireless connectivity'},
      {'name': 'Audio IC', 'full': 'Audio Codec', 'function': 'Sound processing'},
      {'name': 'Touch IC', 'full': 'Touch Controller', 'function': 'Touch input'},
    ];
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.memory, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Common Components',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: components.map((c) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['full']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['function']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.purple.shade400,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchematicsTab(bool isDark) {
    return Row(
      children: [
        // File list
        SizedBox(
          width: 250,
          child: ListView.builder(
            itemCount: _schematics.length,
            itemBuilder: (context, index) {
              final schematic = _schematics[index];
              final isSelected = schematic.path == _selectedSchematic;
              final isPdf = schematic.path.endsWith('.pdf');
              final isImage = schematic.path.endsWith('.png') || 
                            schematic.path.endsWith('.jpg') || 
                            schematic.path.endsWith('.jpeg');
              final isBrd = schematic.path.endsWith('.brd');
              final isBoardview = schematic.path.contains('/boardview/') && 
                                  schematic.path.endsWith('.json');
              
              return ListTile(
                selected: isSelected,
                leading: Icon(
                  isPdf ? Icons.picture_as_pdf : 
                  isImage ? Icons.image : 
                  isBrd ? Icons.developer_board :
                  isBoardview ? Icons.layers : Icons.description,
                  size: 20,
                ),
                title: Text(
                  schematic.path.split('/').last,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: schematic.index != null
                    ? Text(
                        schematic.index!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedSchematic = schematic.path;
                  });
                  if (isPdf || isImage) {
                    _openExternalViewer(schematic.path);
                    setState(() {
                      _schematicContent = null;
                    });
                  } else if (isBrd) {
                    // Open .brd files in external viewer
                    _openBrdFile(schematic.path);
                  } else if (isBoardview) {
                    // Open boardview.json in the boardview viewer
                    _openBoardviewFile(schematic.path);
                  } else {
                    _loadSchematicContent(schematic.path);
                  }
                },
              );
            },
          ),
        ),
        
        // Divider
        VerticalDivider(
          width: 1,
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        
        // Content viewer
        Expanded(
          child: _schematicContent != null
              ? Markdown(
                  data: _schematicContent!,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    h2: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    p: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    code: TextStyle(
                      fontFamily: 'monospace',
                      backgroundColor: Colors.grey[200],
                      color: Colors.black,
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    tableBorder: TableBorder.all(color: Colors.grey[300]!),
                  ),
                )
              : const Center(child: Text('Select a schematic to view')),
        ),
      ],
    );
  }

  // Files Tab - shows files for selected model from _schematics list
  Widget _buildFilesTab(bool isDark) {
    // Show file viewer if a file is selected
    if (_selectedFilePath != null) {
      if (_selectedFileType == _FileType.pdf) {
        // Convert relative path to full GitHub URL
        final github = ref.read(githubServiceProvider);
        final url = github.getRawFileUrl(_selectedFilePath!);
        return Scaffold(
          appBar: AppBar(
            title: Text(_selectedFilePath!.split('/').last),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() { _selectedFilePath = null; _selectedFileType = null; }),
            ),
          ),
          body: PdfViewerWidget(filePath: url, title: _selectedFilePath!.split('/').last, isFromUrl: true),
        );
      } else if (_selectedFileType == _FileType.pcb) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_selectedFilePath!.split('/').last),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() { _selectedFilePath = null; _selectedFileType = null; }),
            ),
          ),
          body: BoardviewFileViewer(filePath: _selectedFilePath!, title: _selectedFilePath!.split('/').last),
        );
      } else if (_selectedFileType == _FileType.md) {
        // Show markdown content viewer
        return _buildMarkdownViewer(_selectedFilePath!, isDark);
      } else if (_selectedFileType == _FileType.image) {
        // Show image viewer
        return _buildImageViewer(_selectedFilePath!, isDark);
      } else if (_selectedFileType == _FileType.boardview) {
        // Show boardview viewer
        return Scaffold(
          appBar: AppBar(
            title: Text(_selectedFilePath!.split('/').last),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() { _selectedFilePath = null; _selectedFileType = null; }),
            ),
          ),
          body: BoardviewFileViewer(filePath: _selectedFilePath!, title: _selectedFilePath!.split('/').last),
        );
      }
    }

    // Show loading if schematics are still loading
    if (_filesTabLoading) {
      return Center(child: CircularProgressIndicator(color: isDark ? AppColors.primaryLight : AppColors.primary));
    }

    // Get files from _schematics list which is populated by _loadFilesForModel()
    final files = _schematics;
    
    // Helper to determine file type from path
    _FileType getFileType(String path) {
      final lowerPath = path.toLowerCase();
      // Check PDF first
      if (lowerPath.endsWith('.pdf')) return _FileType.pdf;
      // Check PCB files
      if (lowerPath.endsWith('.brd')) return _FileType.pcb;
      // Check markdown/text files
      if (lowerPath.endsWith('.md') || lowerPath.endsWith('.txt')) return _FileType.md;
      // Check images
      if (lowerPath.endsWith('.png') || lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg') || lowerPath.endsWith('.gif')) return _FileType.image;
      // Check boardview files
      if (lowerPath.contains('/boardview/') || lowerPath.endsWith('.bdv')) return _FileType.boardview;
      return _FileType.md; // Default
    }

    // Convert IndexEntry to _FileItem
    _FileItem toFileItem(IndexEntry entry) {
      final fileName = entry.path.split('/').last;
      return _FileItem(name: fileName, path: entry.path, fileType: getFileType(entry.path));
    }

    // Filter by file type
    final pdfFiles = files.where((f) => getFileType(f.path) == _FileType.pdf).map(toFileItem).toList();
    final pcbFiles = files.where((f) => getFileType(f.path) == _FileType.pcb).map(toFileItem).toList();
    final mdFiles = files.where((f) => getFileType(f.path) == _FileType.md).map(toFileItem).toList();
    final imageFiles = files.where((f) => getFileType(f.path) == _FileType.image).map(toFileItem).toList();
    final boardviewFiles = files.where((f) => getFileType(f.path) == _FileType.boardview).map(toFileItem).toList();

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            const SizedBox(height: 16),
            Text('No files found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            const SizedBox(height: 8),
            Text('Select a model to view its files', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Reference Card - At-a-glance device info
        _buildQuickReferenceCard(isDark),
        const SizedBox(height: 24),
        
        if (mdFiles.isNotEmpty) ...[
          _buildSectionHeader('Documentation', Icons.description, isDark),
          ...mdFiles.map((file) => _buildFileCard(isDark, file, (f) => setState(() { _selectedFilePath = f.path; _selectedFileType = f.fileType; }))),
          const SizedBox(height: 24),
        ],
        if (pdfFiles.isNotEmpty) ...[
          _buildSectionHeader('PDF Documents', Icons.picture_as_pdf, isDark),
          ...pdfFiles.map((file) => _buildFileCard(isDark, file, (f) => setState(() { _selectedFilePath = f.path; _selectedFileType = f.fileType; }))),
          const SizedBox(height: 24),
        ],
        if (boardviewFiles.isNotEmpty) ...[
          _buildSectionHeader('BoardView Files', Icons.grid_on, isDark),
          ...boardviewFiles.map((file) => _buildFileCard(isDark, file, (f) => setState(() { _selectedFilePath = f.path; _selectedFileType = f.fileType; }))),
          const SizedBox(height: 24),
        ],
        if (pcbFiles.isNotEmpty) ...[
          _buildSectionHeader('PCB Files', Icons.developer_board, isDark),
          ...pcbFiles.map((file) => _buildFileCard(isDark, file, (f) => setState(() { _selectedFilePath = f.path; _selectedFileType = f.fileType; }))),
          const SizedBox(height: 24),
        ],
        if (imageFiles.isNotEmpty) ...[
          _buildSectionHeader('Images', Icons.image, isDark),
          ...imageFiles.map((file) => _buildFileCard(isDark, file, (f) => setState(() { _selectedFilePath = f.path; _selectedFileType = f.fileType; }))),
        ],
      ],
    );
  }
  
  /// Quick Reference Card - At-a-glance device information
  Widget _buildQuickReferenceCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark 
            ? LinearGradient(
                colors: [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, const Color(0xFFF8FAFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Quick Reference - $_selectedModel',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedManufacturer?.toUpperCase() ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Row 1: Common ICs and Voltage Values
                Row(
                  children: [
                    Expanded(
                      child: _buildReferenceItem(
                        isDark,
                        icon: Icons.memory,
                        title: 'Common ICs',
                        items: _getCommonICs(),
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReferenceItem(
                        isDark,
                        icon: Icons.electrical_services,
                        title: 'Key Voltages',
                        items: _getKeyVoltages(),
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Row 2: Screw Locations and Disassembly
                Row(
                  children: [
                    Expanded(
                      child: _buildReferenceItem(
                        isDark,
                        icon: Icons.build,
                        title: 'Screw Types',
                        items: _getScrewTypes(),
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReferenceItem(
                        isDark,
                        icon: Icons.timer_outlined,
                        title: 'Repair Time',
                        items: _getRepairEstimates(),
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReferenceItem(bool isDark, {
    required IconData icon,
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  /// Get common ICs for the selected model
  List<String> _getCommonICs() {
    // This could be expanded to load from a database per model
    if (_selectedModel == null) return ['Select a model'];
    
    // Default common ICs for most smartphones
    return [
      'PMIC (Power Management)',
      'Charging IC',
      'Audio Codec',
      'WiFi/Bluetooth Module',
    ];
  }
  
  /// Get key voltage test points
  List<String> _getKeyVoltages() {
    if (_selectedModel == null) return ['Select a model'];
    
    return [
      'V_BAT: 3.7V - 4.4V',
      'V_SYS: 3.8V - 4.5V',
      'V_IO: 1.8V / 3.3V',
      '5V_BOOST: 5.0V',
    ];
  }
  
  /// Get screw types for the device
  List<String> _getScrewTypes() {
    if (_selectedModel == null) return ['Select a model'];
    
    return [
      'Display: 2.5mm Phillips',
      'Battery: 2.0mm Phillips',
      'Motherboard: 1.5mm Y-type',
      'Shield: 1.2mm Torx',
    ];
  }
  
  /// Get repair time estimates
  List<String> _getRepairEstimates() {
    if (_selectedModel == null) return ['Select a model'];
    
    return [
      'Screen: 30-45 min',
      'Battery: 20-30 min',
      'Charging Port: 45-60 min',
      'Full Disassembly: 60-90 min',
    ];
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        ],
      ),
    );
  }

  Widget _buildFileCard(bool isDark, _FileItem file, Function(_FileItem) onTap) {
    final isPcb = file.fileType == _FileType.pcb;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: InkWell(
        onTap: () => onTap(file),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: isPcb ? Colors.blue.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                child: Icon(isPcb ? Icons.developer_board : Icons.picture_as_pdf, color: isPcb ? Colors.blue.shade400 : Colors.red.shade400, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(file.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(isPcb ? 'PCB/BoardView File' : 'PDF Document', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, color: isDark ? AppColors.primaryLight : AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  // Build markdown viewer for .md files from GitHub URL
  Widget _buildMarkdownViewer(String path, bool isDark) {
    // Convert relative path to full GitHub URL
    final github = ref.read(githubServiceProvider);
    final url = github.getRawFileUrl(path);
    
    return FutureBuilder<String>(
      future: _fetchFileContent(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: isDark ? AppColors.primaryLight : AppColors.primary));
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text('Error loading file', style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                Text(snapshot.error.toString(), style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  onPressed: () => setState(() { _selectedFilePath = null; _selectedFileType = null; }),
                ),
              ],
            ),
          );
        }
        final content = snapshot.data ?? '';
        return Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    onPressed: () => setState(() { _selectedFilePath = null; _selectedFileType = null; }),
                    tooltip: 'Go back',
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(url.split('/').last, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            Expanded(
              child: Markdown(
                data: content,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, fontSize: 14),
                  h1: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.bold),
                  h2: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.bold),
                  h3: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.bold),
                  code: TextStyle(fontFamily: 'monospace', backgroundColor: Colors.grey.shade800, color: Colors.white),
                  codeblockDecoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(4)),
                  tableBorder: TableBorder.all(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build image viewer for image files from GitHub URL
  Widget _buildImageViewer(String path, bool isDark) {
    // Convert relative path to full GitHub URL
    final github = ref.read(githubServiceProvider);
    final url = github.getRawFileUrl(path);
    
    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                onPressed: () => setState(() { _selectedFilePath = null; _selectedFileType = null; }),
                tooltip: 'Go back',
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(url.split('/').last, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(url, fit: BoxFit.contain, loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null, color: isDark ? AppColors.primaryLight : AppColors.primary));
            }, errorBuilder: (context, error, stack) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.broken_image, size: 48, color: Colors.grey.shade400), const SizedBox(height: 8), Text('Failed to load image', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))]))),
          ),
        ),
      ],
    );
  }

  // Fetch file content from GitHub URL
  Future<String> _fetchFileContent(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to load file: ${response.statusCode}');
  }

  Widget _buildSolutionsTab(bool isDark) {
    if (_solutions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            const Text(
              'No solutions found for this model',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _solutions.length,
      itemBuilder: (context, index) {
        final solution = _solutions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.lightbulb),
            title: Text(solution.index ?? solution.path.split('/').last),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open solution detail
            },
          ),
        );
      },
    );
  }

  Widget _buildChatTab(bool isDark) {
    return Column(
      children: [
        // Messages
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.smart_toy,
                          size: 48,
                          color: isDark ? AppColors.primaryLight : AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ask about repairs for $_selectedModel',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI will use the schematic data as context',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg.role == 'user';
                    
                    return Align(
                      alignment: isUser 
                          ? Alignment.centerRight 
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? (isDark ? AppColors.primaryDark : AppColors.primary)
                              : (isDark ? AppColors.surfaceDark2 : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SelectableText(
                          msg.content,
                          style: TextStyle(
                            color: isUser ? Colors.white : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        
        // Input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    hintText: 'Ask about repairs...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (_) => _sendChatMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isLoadingChat ? null : _sendChatMessage,
                icon: _isLoadingChat
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Chat message model
class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });
}

/// Manufacturer model
class Manufacturer {
  final String name;
  final List<String> models;

  Manufacturer({required this.name, required this.models});
}

/// File type enum for Files tab
enum _FileType { pdf, pcb, md, image, boardview }

/// File item model for Files tab
class _FileItem {
  final String name;
  final String path;
  final _FileType fileType;

  _FileItem({required this.name, required this.path, required this.fileType});
}

/// Search result type enum
enum _SearchResultType { device, symptom, schematic }

/// Search result model for unified search
class _SearchResult {
  final _SearchResultType type;
  final String title;
  final String subtitle;
  final String? manufacturer;
  final String? model;
  final String? symptom;
  final String? schematicPath;

  _SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    this.manufacturer,
    this.model,
    this.symptom,
    this.schematicPath,
  });
}
