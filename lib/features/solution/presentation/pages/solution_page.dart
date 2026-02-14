import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/github_service.dart';

/// Solution finder page
class SolutionPage extends ConsumerStatefulWidget {
  const SolutionPage({super.key});

  @override
  ConsumerState<SolutionPage> createState() => _SolutionPageState();
}

class _SolutionPageState extends ConsumerState<SolutionPage> {
  final _searchController = TextEditingController();
  List<IndexEntry> _solutions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSolutions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSolutions() async {
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final index = await github.fetchIndex();
      setState(() {
        _solutions = index.solutions;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading solutions: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchSolutions(String query) async {
    if (query.isEmpty) {
      _loadSolutions();
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final results = await github.searchSolutions(query);
      setState(() {
        _solutions = results;
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
        title: const Text('Solutions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSolutions,
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
                hintText: 'Search solutions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadSolutions();
                        },
                      )
                    : null,
              ),
              onSubmitted: _searchSolutions,
              onChanged: (value) {
                if (value.isEmpty) {
                  _loadSolutions();
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _solutions.isEmpty
                    ? _buildEmptyState()
                    : _buildSolutionList(),
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
            Icons.lightbulb_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          const Text(
            'No solutions found',
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

  Widget _buildSolutionList() {
    return ListView.builder(
      itemCount: _solutions.length,
      itemBuilder: (context, index) {
        final solution = _solutions[index];
        return ListTile(
          leading: const Icon(Icons.lightbulb),
          title: Text(_getFileName(solution.path)),
          subtitle: solution.index != null
              ? Text(
                  solution.index!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: solution.images != null && solution.images!.isNotEmpty
              ? Badge(
                  label: Text('${solution.images!.length}'),
                  child: const Icon(Icons.image),
                )
              : null,
          onTap: () => _openSolution(solution),
        );
      },
    );
  }

  String _getFileName(String path) {
    return path.split('/').last.replaceAll('.json', '');
  }

  void _openSolution(IndexEntry solution) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SolutionDetailPage(
          title: _getFileName(solution.path),
          solution: solution,
        ),
      ),
    );
  }
}

/// Solution detail page
class SolutionDetailPage extends StatelessWidget {
  final String title;
  final IndexEntry solution;

  const SolutionDetailPage({
    super.key,
    required this.title,
    required this.solution,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (solution.index != null) ...[
              Text(
                'AI Index',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(solution.index!),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (solution.images != null && solution.images!.isNotEmpty) ...[
              Text(
                'Related Images',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: solution.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          solution.images![index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Open in full detail view
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Full Solution'),
            ),
          ],
        ),
      ),
    );
  }
}
