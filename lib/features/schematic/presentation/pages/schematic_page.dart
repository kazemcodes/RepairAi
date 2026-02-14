import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/github_service.dart';

/// Schematic viewer page
class SchematicPage extends ConsumerStatefulWidget {
  const SchematicPage({super.key});

  @override
  ConsumerState<SchematicPage> createState() => _SchematicPageState();
}

class _SchematicPageState extends ConsumerState<SchematicPage> {
  final _searchController = TextEditingController();
  List<IndexEntry> _schematics = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSchematics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSchematics() async {
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final index = await github.fetchIndex();
      setState(() {
        _schematics = index.schematics;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading schematics: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchSchematics(String query) async {
    if (query.isEmpty) {
      _loadSchematics();
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final results = await github.searchSchematics(query);
      setState(() {
        _schematics = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schematics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSchematics,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search schematics...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadSchematics();
                        },
                      )
                    : null,
              ),
              onSubmitted: _searchSchematics,
              onChanged: (value) {
                if (value.isEmpty) {
                  _loadSchematics();
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _schematics.isEmpty
                    ? _buildEmptyState()
                    : _buildSchematicList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schema_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          const Text(
            'No schematics found',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search term',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSchematicList() {
    return ListView.builder(
      itemCount: _schematics.length,
      itemBuilder: (context, index) {
        final schematic = _schematics[index];
        return ListTile(
          leading: const Icon(Icons.description),
          title: Text(_getFileName(schematic.path)),
          subtitle: schematic.index != null
              ? Text(
                  schematic.index!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openSchematic(schematic),
        );
      },
    );
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  void _openSchematic(IndexEntry schematic) {
    final github = ref.read(githubServiceProvider);
    final url = github.getRawFileUrl(schematic.path);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchematicDetailPage(
          title: _getFileName(schematic.path),
          url: url,
        ),
      ),
    );
  }
}

/// Schematic detail page with image viewer
class SchematicDetailPage extends StatelessWidget {
  final String title;
  final String url;

  const SchematicDetailPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 64),
            const SizedBox(height: 16),
            Text('Schematic: $title'),
            const SizedBox(height: 8),
            Text(
              url,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Open in full screen viewer
              },
              icon: const Icon(Icons.fullscreen),
              label: const Text('View Full Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
