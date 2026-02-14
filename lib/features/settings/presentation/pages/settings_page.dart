import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/settings_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = ref.read(settingsServiceProvider);
    final geminiKey = await settings.getGeminiApiKey();
    final openRouterKey = await settings.getOpenRouterApiKey();
    
    if (!mounted) return;
    setState(() {
      _geminiKeyController.text = geminiKey ?? '';
      _openRouterKeyController.text = openRouterKey ?? '';
    });
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
