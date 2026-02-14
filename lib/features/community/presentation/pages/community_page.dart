import 'package:flutter/material.dart';

/// Community page for contributions
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: ListView(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                const Icon(Icons.people, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Join Our Community',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Help make RepairAI better for everyone',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Contribution options
          _buildSectionTitle(context, 'Contribute'),
          
          _buildContributionTile(
            context,
            icon: Icons.upload_file,
            title: 'Submit Schematic',
            subtitle: 'Share circuit diagrams with the community',
            onTap: () => _showSubmitDialog(context, 'schematic'),
          ),
          
          _buildContributionTile(
            context,
            icon: Icons.lightbulb,
            title: 'Submit Solution',
            subtitle: 'Share repair solutions and guides',
            onTap: () => _showSubmitDialog(context, 'solution'),
          ),
          
          _buildContributionTile(
            context,
            icon: Icons.emoji_objects,
            title: 'Submit Ideas',
            subtitle: 'Suggest new features and improvements',
            onTap: () => _showSubmitDialog(context, 'idea'),
          ),
          
          const Divider(),
          
          // GitHub section
          _buildSectionTitle(context, 'GitHub'),
          
          _buildLinkTile(
            context,
            icon: Icons.link,
            title: 'View on GitHub',
            subtitle: 'repairai/repairai',
            onTap: () {
              // Open GitHub
            },
          ),
          
          _buildLinkTile(
            context,
            icon: Icons.fork_right,
            title: 'Contribute via PR',
            subtitle: 'Submit changes directly',
            onTap: () {
              // Open PR guide
            },
          ),
          
          _buildLinkTile(
            context,
            icon: Icons.bug_report,
            title: 'Report Issues',
            subtitle: 'Help us fix bugs',
            onTap: () {
              // Open issues
            },
          ),
          
          const Divider(),
          
          // Info section
          _buildSectionTitle(context, 'About'),
          
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Open Source'),
            subtitle: Text('MIT License - Free forever'),
          ),
          
          const ListTile(
            leading: Icon(Icons.volunteer_activism),
            title: Text('Community Driven'),
            subtitle: Text('Built by repair technicians for repair technicians'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildContributionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: onTap,
    );
  }

  void _showSubmitDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit ${type.substring(0, 1).toUpperCase()}${type.substring(1)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To submit content to RepairAI:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('1. Fork the GitHub repository'),
            const SizedBox(height: 4),
            const Text('2. Add your content to the data folder'),
            const SizedBox(height: 4),
            const Text('3. Submit a Pull Request'),
            const SizedBox(height: 4),
            const Text('4. Our team will review and merge'),
            const SizedBox(height: 16),
            const Text(
              'Alternatively, you can submit through the app and our team will help process it.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open GitHub
            },
            child: const Text('Go to GitHub'),
          ),
        ],
      ),
    );
  }
}
