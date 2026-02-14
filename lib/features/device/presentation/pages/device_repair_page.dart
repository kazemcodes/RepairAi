import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../shared/services/github_service.dart';
import '../../../../shared/services/ai_service.dart';
import '../../../../core/theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadManufacturers();
  }

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
        // Filter schematics for selected model - only markdown and text files
        _schematics = index.schematics
            .where((s) => s.path.contains('/$_selectedModel/') && 
                (s.path.endsWith('.md') || s.path.endsWith('.txt')))
            .toList();
        
        // Also include PDF and image files in list for display
        final allSchematics = index.schematics
            .where((s) => s.path.contains('/$_selectedModel/'))
            .toList();
        
        // Merge with PDF/image files
        for (var schematic in allSchematics) {
          if (!schematic.path.endsWith('.md') && !schematic.path.endsWith('.txt')) {
            if (!_schematics.any((s) => s.path == schematic.path)) {
              _schematics.add(schematic);
            }
          }
        }
        
        // Filter solutions for selected model
        _solutions = index.solutions
            .where((s) => s.path.contains('/$_selectedModel/'))
            .toList();
        
        // Auto-select first schematic
        if (_schematics.isNotEmpty) {
          _selectedSchematic = _schematics.first.path;
          _loadSchematicContent(_schematics.first.path);
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
      body: Column(
        children: [
          // Device Selector
          _buildDeviceSelector(isDark),
          
          // Tab Bar
          Container(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.schema), text: 'Schematics'),
                Tab(icon: Icon(Icons.lightbulb), text: 'Solutions'),
                Tab(icon: Icon(Icons.chat), text: 'AI Chat'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSchematicsTab(isDark),
                _buildSolutionsTab(isDark),
                _buildChatTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Manufacturer dropdown
          Expanded(
            child: _manufacturers.isEmpty
                ? const Center(child: Text('Loading...'))
                : DropdownButtonFormField<String>(
                    value: _selectedManufacturer,
                    decoration: const InputDecoration(
                      labelText: 'Manufacturer',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _manufacturers.map((m) {
                      return DropdownMenuItem(
                        value: m.name,
                        child: Text(m.name.toUpperCase()),
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
          const SizedBox(width: 16),
          
          // Model dropdown
          Expanded(
            child: _manufacturers.isEmpty
                ? const Center(child: Text('No devices found'))
                : DropdownButtonFormField<String>(
                    value: _selectedModel,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _manufacturers.isNotEmpty
                        ? _manufacturers
                            .firstWhere((m) => m.name == _selectedManufacturer, 
                                orElse: () => _manufacturers.first)
                            .models
                            .map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(m.toUpperCase()),
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
          const SizedBox(width: 8),
          
          // Refresh button
          IconButton(
            onPressed: _loadManufacturers,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
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
              
              return ListTile(
                selected: isSelected,
                leading: Icon(
                  isPdf ? Icons.picture_as_pdf : 
                  isImage ? Icons.image : Icons.description,
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
