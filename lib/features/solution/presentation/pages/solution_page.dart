import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/github_service.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final index = await github.fetchIndex();
      if (!mounted) return;
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _searchSolutions(String query) async {
    if (query.isEmpty) {
      _loadSolutions();
      return;
    }
    
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final results = await github.searchSolutions(query);
      if (!mounted) return;
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
      if (mounted) {
        setState(() => _isLoading = false);
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
              ? AppColors.backgroundGradientDark 
              : AppColors.backgroundGradientLight,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(isDark),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search solutions...',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _loadSolutions();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                    ),
                    onSubmitted: _searchSolutions,
                    onChanged: (value) {
                      setState(() {}); // Rebuild to show/hide clear button
                      if (value.isEmpty) {
                        _loadSolutions();
                      }
                    },
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : _solutions.isEmpty
                        ? _buildEmptyState(isDark)
                        : _buildSolutionList(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solutions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Find repair solutions for your device',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            onPressed: _loadSolutions,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(32),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 48,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No solutions found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _solutions.length,
      itemBuilder: (context, index) {
        final solution = _solutions[index];
        return _buildSolutionCard(solution, isDark);
      },
    );
  }

  Widget _buildSolutionCard(IndexEntry solution, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openSolution(solution),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getFileName(solution.path),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (solution.index != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        solution.index!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (solution.images != null && solution.images!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${solution.images!.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark 
              ? AppColors.backgroundGradientDark 
              : AppColors.backgroundGradientLight,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (solution.index != null) ...[
                        _buildSection(
                          isDark: isDark,
                          title: 'AI Index',
                          icon: Icons.auto_awesome,
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              solution.index!,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (solution.images != null && solution.images!.isNotEmpty) ...[
                        _buildSection(
                          isDark: isDark,
                          title: 'Related Images',
                          icon: Icons.image,
                          child: SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: solution.images!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      solution.images![index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.broken_image,
                                          color: isDark ? Colors.grey[600] : Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      _buildSection(
                        isDark: isDark,
                        title: 'Actions',
                        icon: Icons.play_circle,
                        child: GlassCard(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Open in full detail view
                              },
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('View Full Solution'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildSection({
    required bool isDark,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
