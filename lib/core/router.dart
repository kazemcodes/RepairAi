import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/schematic/presentation/pages/schematic_page.dart';
import '../features/solution/presentation/pages/solution_page.dart';
import '../features/chatbox/presentation/pages/chatbox_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/community/presentation/pages/community_page.dart';
import '../features/device/presentation/pages/device_repair_page.dart';
import 'shell_page.dart';
import 'theme/app_colors.dart';

/// App routes
class AppRoutes {
  static const String home = '/';
  static const String schematic = '/schematic';
  static const String schematicDetail = '/schematic/:id';
  static const String solution = '/solution';
  static const String solutionDetail = '/solution/:id';
  static const String chatbox = '/chat';
  static const String chatDetail = '/chat/:id';
  static const String settings = '/settings';
  static const String community = '/community';
  static const String device = '/device';
}

/// Router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellPage(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DeviceRepairPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.schematic,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SchematicPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.solution,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SolutionPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.chatbox,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ChatboxPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.community,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CommunityPage(),
          ),
        ),
      ],
    ),
  ],
);

/// Home page placeholder
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to RepairAI',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your AI-powered mobile repair assistant',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.build_circle,
                    size: 64,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            
            // Feature Cards
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.schema,
                    title: 'Schematics',
                    description: 'Browse device schematics',
                    route: AppRoutes.schematic,
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.lightbulb,
                    title: 'Solutions',
                    description: 'Find repair solutions',
                    route: AppRoutes.solution,
                    color: Colors.amber,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.chat,
                    title: 'AI Chat',
                    description: 'Ask AI for help',
                    route: AppRoutes.chatbox,
                    color: Colors.green,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.people,
                    title: 'Community',
                    description: 'Join the community',
                    route: AppRoutes.community,
                    color: Colors.purple,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Activity / Getting Started
            Text(
              'Getting Started',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildGettingStartedCard(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String route,
    required Color color,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: InkWell(
        onTap: () => GoRouter.of(context).go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGettingStartedCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rocket_launch,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Setup Your AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '1. Go to Settings and add your API key\n'
              '2. Choose between Gemini or OpenRouter\n'
              '3. Select your preferred model',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).go(AppRoutes.settings),
              icon: const Icon(Icons.settings, size: 18),
              label: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
