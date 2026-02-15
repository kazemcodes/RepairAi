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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadManufacturers();
  }

  // Load files when model is first selected

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

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
      // Build context from current device schematics
      String contextInfo = '';
      if (_selectedModel != null) {
        // Only include markdown and text files in AI context
        final markdownFiles = _schematics
            .where((s) => s.path.endsWith('.md') || s.path.endsWith('.txt'))
            .toList();
        
        contextInfo = '''
Current Device Context:
- Manufacturer: $_selectedManufacturer
- Model: $_selectedModel

Available Schematics (Markdown/Txt only):
${markdownFiles.map((s) => '- ${s.path}: ${s.index ?? ""}').join('\n')}
''';
        
        if (_schematicContent != null && _schematicContent!.isNotEmpty) {
          contextInfo += '\nCurrent Schematic Content:\n$_schematicContent';
        }
      }

      final aiService = ref.read(aiServiceProvider);
      final prompt = '''
You are RepairAI, an AI assistant for mobile repair technicians.
$contextInfo

User Question: $message

Please provide a helpful, technical answer based on the schematic data above. If the question is about repair procedures, refer to the step-by-step guides available.
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
          child: Column(
            children: [
              // Device Selector with Glass effect
              GlassCard(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                borderRadius: BorderRadius.circular(20),
                opacity: isDark ? 0.15 : 0.25,
                child: _buildDeviceSelector(isDark),
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
                            Icon(Icons.folder_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Files'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.smart_toy_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Chat'),
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
                      _buildFilesTab(isDark),
                      _buildChatTab(isDark),
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

  Widget _buildDeviceSelector(bool isDark) {
    return Row(
      children: [
        // Manufacturer dropdown
        Expanded(
          child: _manufacturers.isEmpty
              ? Center(
                  child: Text(
                    'Loading devices...',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedManufacturer,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Manufacturer',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
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
                      prefixIcon: Icon(Icons.phone_android, color: isDark ? Colors.white70 : Colors.black54),
                    ),
                    items: _manufacturers.map((m) {
                      return DropdownMenuItem(
                        value: m.name,
                        child: Text(
                          m.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedManufacturer = value;
                        final manu = _manufacturers.firstWhere((m) => m.name == value);
                        _selectedModel = manu.models.first;
                        _loadFilesForModel();
                      });
                    },
                  ),
                ),
        ),
        const SizedBox(width: 12),
        
        // Model dropdown
        Expanded(
          child: _manufacturers.isEmpty
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedModel,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Model',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
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
                        borderSide: const BorderSide(color: AppColors.accent, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      prefixIcon: Icon(Icons.model_training, color: isDark ? Colors.white70 : Colors.black54),
                    ),
                    items: _manufacturers.isNotEmpty
                        ? _manufacturers
                            .firstWhere((m) => m.name == _selectedManufacturer, 
                                orElse: () => _manufacturers.first)
                            .models
                            .map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(
                              m.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          );
                        }).toList()
                        : [],
                    onChanged: (value) {
                      setState(() {
                        _selectedModel = value;
                        _loadFilesForModel();
                      });
                    },
                  ),
                ),
        ),
        const SizedBox(width: 8),
        
        // Refresh button with gradient
        GradientIconButton(
          icon: Icons.refresh,
          onPressed: _loadManufacturers,
          size: 48,
        ),
      ],
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
