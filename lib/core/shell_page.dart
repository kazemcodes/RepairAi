import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';

/// Shell page with bottom navigation
class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema_outlined),
            activeIcon: Icon(Icons.schema),
            label: 'Schematic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            activeIcon: Icon(Icons.lightbulb),
            label: 'Solutions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            activeIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/schematic')) return 1;
    if (location.startsWith('/solution')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/settings') || location.startsWith('/community')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.schematic);
        break;
      case 2:
        context.go(AppRoutes.solution);
        break;
      case 3:
        context.go(AppRoutes.chatbox);
        break;
      case 4:
        context.go(AppRoutes.settings);
        break;
    }
  }
}
