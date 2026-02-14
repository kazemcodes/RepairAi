import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../../shared/services/ai_service.dart';
import '../../../community/presentation/pages/community_page.dart';

/// Settings page
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _geminiKeyController = TextEditingController();
  final _openRouterKeyController = TextEditingController();
  bool _isLoading = false;
  String _selectedEngine = 'gemini';
  String? _selectedModel;
  List<String> _availableModels = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = ref.read(settingsServiceProvider);
    final aiService = ref.read(aiServiceProvider);
    final geminiKey = await settings.getGeminiApiKey();
    final openRouterKey = await settings.getOpenRouterApiKey();
    final defaultModel = await settings.getDefaultModel();
    
    // Fetch available models from APIs
    final List<String> models = [];
    
    if (geminiKey != null && geminiKey.isNotEmpty) {
      final geminiModels = await aiService.fetchGeminiModels();
      models.addAll(geminiModels);
    }
    
    if (openRouterKey != null && openRouterKey.isNotEmpty) {
      final openRouterModels = await aiService.fetchOpenRouterModels();
      models.addAll(openRouterModels);
    }
    
    if (!mounted) return;
    setState(() {
      _geminiKeyController.text = geminiKey ?? '';
      _openRouterKeyController.text = openRouterKey ?? '';
      _selectedModel = defaultModel;
      _selectedEngine = defaultModel.startsWith('gemini') ? 'gemini' : 'openrouter';
      _availableModels = models;
      
      // Reset selected model if not in list
      if (_selectedModel != null && !_availableModels.contains(_selectedModel)) {
        _selectedModel = _availableModels.isNotEmpty ? _availableModels.first : null;
      }
    });
  }

  void _updateAvailableModels() {
    // Use the already fetched models from API
    // This method is kept for backwards compatibility
    // Models are now fetched from API in _loadSettings and after saving keys
    
    // If list is empty, provide fallback defaults
    if (_availableModels.isEmpty) {
      _availableModels = [];
      if (_geminiKeyController.text.isNotEmpty) {
        _availableModels.addAll([
          'gemini-2.0-flash',
          'gemini-1.5-pro',
          'gemini-1.5-flash',
        ]);
      }
      if (_openRouterKeyController.text.isNotEmpty) {
        _availableModels.addAll([
          'openai/gpt-4o-mini',
          'openai/gpt-4o',
          'anthropic/claude-3-haiku',
          'google/gemma-2-27b',
        ]);
      }
    }
    
    // Reset selected model if it's not in the list
    if (_selectedModel != null && !_availableModels.contains(_selectedModel)) {
      _selectedModel = _availableModels.isNotEmpty ? _availableModels.first : null;
    }
  }

  @override
  void dispose() {
    _geminiKeyController.dispose();
    _openRouterKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveGeminiKey() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final settings = ref.read(settingsServiceProvider);
      await settings.setGeminiApiKey(_geminiKeyController.text);
      
      // Fetch models from Gemini API
      final aiService = ref.read(aiServiceProvider);
      final geminiModels = await aiService.fetchGeminiModels();
      
      setState(() {
        // Add new models to available models
        for (final model in geminiModels) {
          if (!_availableModels.contains(model)) {
            _availableModels.add(model);
          }
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gemini API key saved')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveOpenRouterKey() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final settings = ref.read(settingsServiceProvider);
      await settings.setOpenRouterApiKey(_openRouterKeyController.text);
      
      // Fetch models from OpenRouter API
      final aiService = ref.read(aiServiceProvider);
      final openRouterModels = await aiService.fetchOpenRouterModels();
      
      setState(() {
        // Add new models to available models
        for (final model in openRouterModels) {
          if (!_availableModels.contains(model)) {
            _availableModels.add(model);
          }
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OpenRouter API key saved')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // AI Engine Section
          _buildSectionHeader('AI Engine'),
          _buildEngineSelector(),
          _buildModelSelector(),
          
          const Divider(),
          
          // API Keys Section
          _buildSectionHeader('API Keys'),
          _buildApiKeyTile(
            title: 'Google Gemini API Key',
            controller: _geminiKeyController,
            onSave: _saveGeminiKey,
            isGemini: true,
          ),
          _buildApiKeyTile(
            title: 'OpenRouter API Key',
            controller: _openRouterKeyController,
            onSave: _saveOpenRouterKey,
            isGemini: false,
          ),
          
          const Divider(),
          
          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildThemeTile(),
          _buildLanguageTile(),
          
          const Divider(),
          
          // More Options
          _buildSectionHeader('More'),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Community'),
            subtitle: const Text('Contribute and share'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommunityPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select AI Engine',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'gemini',
                label: Text('Gemini'),
                icon: Icon(Icons.psychology),
              ),
              ButtonSegment(
                value: 'openrouter',
                label: Text('OpenRouter'),
                icon: Icon(Icons.hub),
              ),
            ],
            selected: {_selectedEngine},
            onSelectionChanged: (selection) {
              setState(() {
                _selectedEngine = selection.first;
                _updateAvailableModels();
                // Set default model for the engine
                if (_selectedEngine == 'gemini' && _availableModels.isNotEmpty) {
                  _selectedModel = _availableModels.first;
                } else if (_selectedEngine == 'openrouter' && _availableModels.isNotEmpty) {
                  _selectedModel = _availableModels.first;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Model',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _availableModels.contains(_selectedModel) ? _selectedModel : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('Select a model'),
            isExpanded: true,
            items: _availableModels.map((model) {
              return DropdownMenuItem(
                value: model,
                child: Text(model, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (value) async {
              setState(() => _selectedModel = value);
              if (value != null) {
                final settings = ref.read(settingsServiceProvider);
                await settings.setDefaultModel(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApiKeyTile({
    required String title,
    required TextEditingController controller,
    required VoidCallback onSave,
    required bool isGemini,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Enter your API key',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isLoading ? null : onSave,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeTile() {
    final themeMode = ref.watch(themeModeProvider);
    
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Theme'),
      subtitle: Text(_getThemeLabel(themeMode)),
      onTap: () => _showThemeDialog(),
    );
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  Widget _buildLanguageTile() {
    final language = ref.watch(languageProvider);
    
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(_getLanguageLabel(language)),
      onTap: () => _showLanguageDialog(),
    );
  }

  String _getLanguageLabel(String lang) {
    switch (lang) {
      case 'fa':
        return 'Persian (فارسی)';
      default:
        return 'English';
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: ref.read(languageProvider),
              onChanged: (value) async {
                final settings = ref.read(settingsServiceProvider);
                await settings.setLanguage(value!);
                ref.read(languageProvider.notifier).state = value;
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Persian (فارسی)'),
              value: 'fa',
              groupValue: ref.read(languageProvider),
              onChanged: (value) async {
                final settings = ref.read(settingsServiceProvider);
                await settings.setLanguage(value!);
                ref.read(languageProvider.notifier).state = value;
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('System'),
              value: 'system',
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) async {
                final settings = ref.read(settingsServiceProvider);
                await settings.setThemeMode(value!);
                ref.read(themeModeProvider.notifier).state = value;
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'light',
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) async {
                final settings = ref.read(settingsServiceProvider);
                await settings.setThemeMode(value!);
                ref.read(themeModeProvider.notifier).state = value;
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'dark',
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) async {
                final settings = ref.read(settingsServiceProvider);
                await settings.setThemeMode(value!);
                ref.read(themeModeProvider.notifier).state = value;
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'RepairAI',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 RepairAI - Open Source Mobile Repair Assistant',
    );
  }
}
