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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final index = await github.fetchIndex();
      if (!mounted) return;
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _searchSchematics(String query) async {
    if (query.isEmpty) {
      _loadSchematics();
      return;
    }
    
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final github = ref.read(githubServiceProvider);
      final results = await github.searchSchematics(query);
      if (!mounted) return;
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
                      hintText: 'Search schematics...',
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
                                _loadSchematics();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                    ),
                    onSubmitted: _searchSchematics,
                    onChanged: (value) {
                      setState(() {}); // Rebuild to show/hide clear button
                      if (value.isEmpty) {
                        _loadSchematics();
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
                    : _schematics.isEmpty
                        ? _buildEmptyState(isDark)
                        : _buildSchematicList(isDark),
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
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.schema,
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
                  'Schematics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Browse device schematics',
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
            onPressed: _loadSchematics,
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
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.schema_outlined,
                size: 48,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No schematics found',
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

  Widget _buildSchematicList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _schematics.length,
      itemBuilder: (context, index) {
        final schematic = _schematics[index];
        return _buildSchematicCard(schematic, isDark);
      },
    );
  }

  Widget _buildSchematicCard(IndexEntry schematic, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openSchematic(schematic),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description,
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
                      _getFileName(schematic.path),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (schematic.index != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        schematic.index!,
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

/// Schematic detail page with interactive viewer
class SchematicDetailPage extends StatefulWidget {
  final String title;
  final String url;

  const SchematicDetailPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<SchematicDetailPage> createState() => _SchematicDetailPageState();
}

class _SchematicDetailPageState extends State<SchematicDetailPage> {
  bool _isLoading = true;
  String? _error;
  // BoardViewData? _boardData; // Uncomment when model is ready

  @override
  void initState() {
    super.initState();
    _loadBoardView();
  }

  Future<void> _loadBoardView() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Load boardview data from URL
      // final response = await http.get(Uri.parse(widget.url));
      // final data = json.decode(response.body);
      // _boardData = BoardViewData.fromJson(data);
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Interactive viewer coming soon!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error loading schematic: $e';
        });
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
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showInfo(context),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Loading schematic...',
                              style: TextStyle(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _error != null
                        ? _buildErrorState(isDark)
                        : _buildPlaceholder(isDark),
                        // : InteractiveBoardViewViewer(
                        //     boardData: _boardData!,
                        //     onComponentTap: (component) {
                        //       // Show component details
                        //     },
                        //   ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(32),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadBoardView,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(32),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.schema,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Interactive Schematic Viewer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Features:\n• Interactive PCB layout\n• Component search\n• Net highlighting\n• Layer control\n• Zoom & pan',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Schematics'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Interactive PCB Viewer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'View detailed PCB layouts with:\n'
                '• Component locations\n'
                '• Pin connections\n'
                '• Net highlighting\n'
                '• Layer visualization\n'
                '• Search functionality',
              ),
              SizedBox(height: 16),
              Text(
                'Contribute',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Help us grow the database by contributing boardview files for your devices!',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to contribution page
            },
            child: const Text('Contribute'),
          ),
        ],
      ),
    );
  }
}
