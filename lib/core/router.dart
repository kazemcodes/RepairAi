import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/schematic/presentation/pages/schematic_page.dart';
import '../features/solution/presentation/pages/solution_page.dart';
import '../features/chatbox/presentation/pages/chatbox_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/community/presentation/pages/community_page.dart';
import 'shell_page.dart';

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
            child: HomePage(),
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
    return const Scaffold(
      body: Center(
        child: Text('RepairAI Home'),
      ),
    );
  }
}
