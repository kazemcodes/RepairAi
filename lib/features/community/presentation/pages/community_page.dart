import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Community page for contributions - improved user-friendly design
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header
          const SliverToBoxAdapter(
            child: _HeroHeader(),
          ),

          // Stats Cards
          const SliverToBoxAdapter(
            child: _StatsSection(),
          ),

          // Contribution Options - Main Actions
          SliverToBoxAdapter(
            child: _ContributionsSection(
              onSubmitTap: (type) => _showSubmitDialog(context, type),
            ),
          ),

          // How It Works
          const SliverToBoxAdapter(
            child: _HowItWorksSection(),
          ),

          // GitHub Section
          SliverToBoxAdapter(
            child: _GithubSection(
              onGithubTap: () => _openGithub(context),
              onPRTap: () => _openGithubPR(context),
              onIssuesTap: () => _openGithubIssues(context),
              onDiscordTap: () => _openDiscord(context),
            ),
          ),

          // About Section
          const SliverToBoxAdapter(
            child: _AboutSection(),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Future<void> _openGithub(BuildContext context) async {
    final uri = Uri.parse('https://github.com/kazemcodes/repairai');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openGithubPR(BuildContext context) async {
    final uri = Uri.parse('https://github.com/kazemcodes/repairai/pulls');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openGithubIssues(BuildContext context) async {
    final uri = Uri.parse('https://github.com/kazemcodes/repairai/issues');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openDiscord(BuildContext context) async {
    final uri = Uri.parse('https://discord.gg/repairai');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _openGithub(context);
    }
  }

  void _showSubmitDialog(BuildContext context, String type) {
    String title;
    String description;

    switch (type) {
      case 'schematic':
        title = 'Submit Schematic';
        description = 'Share circuit diagrams with the community';
        break;
      case 'solution':
        title = 'Submit Solution';
        description = 'Share repair solutions and guides';
        break;
      case 'idea':
        title = 'Submit Ideas';
        description = 'Suggest new features and improvements';
        break;
      case 'translation':
        title = 'Submit Translation';
        description = 'Help translate RepairAI to your language';
        break;
      default:
        title = 'Submit';
        description = '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getTypeIcon(type),
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 20),
            const Text(
              'To submit content to RepairAI:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _StepText(number: '1', text: 'Fork the GitHub repository'),
            const _StepText(number: '2', text: 'Add your content to the data folder'),
            const _StepText(number: '3', text: 'Submit a Pull Request'),
            const _StepText(number: '4', text: 'Our team will review and merge'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Alternatively, you can submit through the app and our team will help process it.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _openGithub(context);
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Go to GitHub'),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'schematic':
        return Icons.upload_file;
      case 'solution':
        return Icons.lightbulb;
      case 'idea':
        return Icons.emoji_objects;
      case 'translation':
        return Icons.translate;
      default:
        return Icons.send;
    }
  }
}

/// Hero header section with gradient background
class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Column(
        children: [
          // Main icon with decoration
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_rounded,
              size: 56,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            'Community',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Join our community of repair technicians and enthusiasts',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Quick action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Contribute'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stats section showing community numbers
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: const [
          Expanded(
            child: _StatCard(
              icon: Icons.memory,
              value: '2,500+',
              label: 'Schematics',
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.lightbulb,
              value: '1,200+',
              label: 'Solutions',
              color: Colors.green,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.people,
              value: '500+',
              label: 'Contributors',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Contributions section with submit button
class _ContributionsSection extends StatelessWidget {
  final Function(String) onSubmitTap;

  const _ContributionsSection({required this.onSubmitTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contribute',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Single Submit Contribution button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => onSubmitTap('contribution'),
              icon: const Icon(Icons.upload_file),
              label: const Text('Submit Contribution'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Share schematics, solutions, or ideas with the community',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Contribution card widget

/// How It Works section with steps
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _StepItem(
                    number: '1',
                    title: 'Fork the Repository',
                    description: 'Create your own copy of the RepairAI repository on GitHub',
                    icon: Icons.call_split,
                  ),
                  Divider(height: 24),
                  _StepItem(
                    number: '2',
                    title: 'Add Your Content',
                    description: 'Upload schematics, solutions, or ideas following our guidelines',
                    icon: Icons.add_circle_outline,
                  ),
                  Divider(height: 24),
                  _StepItem(
                    number: '3',
                    title: 'Submit a Pull Request',
                    description: 'Our team will review your contribution and merge it',
                    icon: Icons.merge,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Alternative: Submit through app
          Card(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.alternate_email,
                    color: theme.colorScheme.secondary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prefer not to code?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Submit your content directly through the app and our team will help process it.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step item for "How It Works" section
class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// GitHub section with links
class _GithubSection extends StatelessWidget {
  final VoidCallback onGithubTap;
  final VoidCallback onPRTap;
  final VoidCallback onIssuesTap;
  final VoidCallback onDiscordTap;

  const _GithubSection({
    required this.onGithubTap,
    required this.onPRTap,
    required this.onIssuesTap,
    required this.onDiscordTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code, size: 24),
              const SizedBox(width: 8),
              Text(
                'GitHub',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Column(
              children: [
                _GithubTile(
                  icon: Icons.folder_outlined,
                  title: 'View Repository',
                  subtitle: 'Explore the source code and documentation',
                  onTap: onGithubTap,
                ),
                const Divider(height: 1),
                _GithubTile(
                  icon: Icons.fork_right,
                  title: 'Contribute via PR',
                  subtitle: 'Submit changes directly via pull requests',
                  onTap: onPRTap,
                ),
                const Divider(height: 1),
                _GithubTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Report Issues',
                  subtitle: 'Help us find and fix bugs',
                  onTap: onIssuesTap,
                ),
                const Divider(height: 1),
                _GithubTile(
                  icon: Icons.discord_outlined,
                  title: 'Join Discord',
                  subtitle: 'Chat with other contributors in real-time',
                  onTap: onDiscordTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// GitHub tile widget
class _GithubTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _GithubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// About section with project info
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _InfoTile(
                    icon: Icons.lock_open,
                    iconColor: Colors.blue,
                    title: 'Open Source',
                    subtitle: 'MIT License - Free forever',
                  ),
                  SizedBox(height: 16),
                  _InfoTile(
                    icon: Icons.volunteer_activism,
                    iconColor: Colors.green,
                    title: 'Community Driven',
                    subtitle: 'Built by repair technicians for repair technicians',
                  ),
                  SizedBox(height: 16),
                  _InfoTile(
                    icon: Icons.favorite,
                    iconColor: Colors.red,
                    title: 'Made with Love',
                    subtitle: 'Thank you for being part of our journey',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Info tile widget
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Simple step text for dialog
class _StepText extends StatelessWidget {
  final String number;
  final String text;

  const _StepText({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$number. ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
