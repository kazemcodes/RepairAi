import 'package:flutter/material.dart';

/// Component Locator Widget
/// Provides search functionality for components across schematics and boardviews
class ComponentLocator extends StatefulWidget {
  final List<ComponentData> components;
  final Function(ComponentData)? onComponentSelected;
  final String? deviceModel;
  
  const ComponentLocator({
    super.key,
    required this.components,
    this.onComponentSelected,
    this.deviceModel,
  });

  @override
  State<ComponentLocator> createState() => _ComponentLocatorState();
}

class _ComponentLocatorState extends State<ComponentLocator> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<ComponentData> _searchResults = [];
  String _selectedCategory = 'all';
  bool _showFilters = false;
  
  // Component categories with color coding
  final Map<String, ComponentCategory> _categories = {
    'power': ComponentCategory(
      name: 'Power Related',
      color: Colors.red,
      icon: Icons.power,
      keywords: ['pmic', 'power', 'charging', 'battery', 'vbus', 'vbat', 'ldo', 'dc-dc', 'buck'],
    ),
    'signal': ComponentCategory(
      name: 'Signal/RF',
      color: Colors.blue,
      icon: Icons.wifi,
      keywords: ['rf', 'antenna', 'signal', 'transceiver', 'modem', 'gsm', 'lte', 'wifi', 'bt', 'bluetooth'],
    ),
    'audio': ComponentCategory(
      name: 'Audio',
      color: Colors.green,
      icon: Icons.volume_up,
      keywords: ['audio', 'speaker', 'mic', 'microphone', 'codec', 'amp', 'sound'],
    ),
    'display': ComponentCategory(
      name: 'Display',
      color: Colors.amber,
      icon: Icons.phone_android,
      keywords: ['display', 'lcd', 'oled', 'backlight', 'touch', 'screen'],
    ),
    'memory': ComponentCategory(
      name: 'Memory/Storage',
      color: Colors.purple,
      icon: Icons.storage,
      keywords: ['emmc', 'ufs', 'ram', 'nand', 'flash', 'memory', 'storage'],
    ),
    'processor': ComponentCategory(
      name: 'Processor/IC',
      color: Colors.orange,
      icon: Icons.memory,
      keywords: ['cpu', 'ap', 'cp', 'processor', 'soc', 'mcu', 'ic'],
    ),
    'connector': ComponentCategory(
      name: 'Connectors',
      color: Colors.teal,
      icon: Icons.cable,
      keywords: ['usb', 'connector', 'jack', 'port', 'header'],
    ),
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchComponents(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _searchResults = [];
        return;
      }
      
      _searchResults = widget.components.where((component) {
        final matchesQuery = component.ref.toLowerCase().contains(_searchQuery) ||
            (component.value?.toLowerCase().contains(_searchQuery) ?? false) ||
            (component.description?.toLowerCase().contains(_searchQuery) ?? false) ||
            (component.type?.toLowerCase().contains(_searchQuery) ?? false);
        
        final matchesCategory = _selectedCategory == 'all' || 
            _matchesCategory(component, _selectedCategory);
        
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  bool _matchesCategory(ComponentData component, String categoryId) {
    final category = _categories[categoryId];
    if (category == null) return false;
    
    final searchText = '${component.ref} ${component.value ?? ''} ${component.description ?? ''} ${component.type ?? ''}'.toLowerCase();
    return category.keywords.any((keyword) => searchText.contains(keyword));
  }

  String? _getComponentCategory(ComponentData component) {
    for (final entry in _categories.entries) {
      if (_matchesCategory(component, entry.key)) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Component Locator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (widget.deviceModel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.deviceModel!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search components (e.g., U5201, charging IC, PM3001)',
                hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchComponents('');
                        },
                      ),
                    IconButton(
                      icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
                      onPressed: () => setState(() => _showFilters = !_showFilters),
                      tooltip: 'Toggle filters',
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              ),
              onChanged: _searchComponents,
            ),
          ),
          
          // Category Filters
          if (_showFilters)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('all', 'All', null),
                  ..._categories.entries.map((entry) => 
                    _buildCategoryChip(entry.key, entry.value.name, entry.value.color),
                  ),
                ],
              ),
            ),
          
          // Quick Category Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickButton('Charging IC', 'power', ['charging', 'charger', 'pmic']),
                _buildQuickButton('Display', 'display', ['display', 'lcd', 'oled']),
                _buildQuickButton('Audio', 'audio', ['audio', 'speaker', 'mic']),
                _buildQuickButton('WiFi/BT', 'signal', ['wifi', 'bluetooth', 'bt']),
              ],
            ),
          ),
          
          // Search Results
          if (_searchResults.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return _buildComponentTile(_searchResults[index], isDark);
                },
              ),
            )
          else if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No components found for "$_searchQuery"',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.electrical_services, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Search for components by reference,\nvalue, or description',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, Color? color) {
    final isSelected = _selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = id;
            if (_searchQuery.isNotEmpty) {
              _searchComponents(_searchController.text);
            }
          });
        },
        backgroundColor: color?.withOpacity(0.1) ?? Colors.grey.shade200,
        selectedColor: color?.withOpacity(0.3) ?? Colors.blue.shade200,
        labelStyle: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, String category, List<String> keywords) {
    final categoryData = _categories[category];
    return ActionChip(
      avatar: Icon(categoryData?.icon ?? Icons.search, size: 16, color: categoryData?.color),
      label: Text(label),
      onPressed: () {
        setState(() {
          _selectedCategory = category;
          _searchController.text = keywords.first;
          _searchComponents(keywords.first);
        });
      },
    );
  }

  Widget _buildComponentTile(ComponentData component, bool isDark) {
    final categoryId = _getComponentCategory(component);
    final category = categoryId != null ? _categories[categoryId] : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (category?.color ?? Colors.grey).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category?.icon ?? Icons.circle_outlined,
            color: category?.color ?? Colors.grey,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              component.ref,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (component.value != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  component.value!,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (component.description != null)
              Text(
                component.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (component.type != null)
              Text(
                'Type: ${component.type}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => widget.onComponentSelected?.call(component),
      ),
    );
  }
}

/// Component data model
class ComponentData {
  final String ref;
  final String? value;
  final String? description;
  final String? type;
  final String? package;
  final double? x;
  final double? y;
  final String? side;
  final Map<String, dynamic>? extra;
  
  const ComponentData({
    required this.ref,
    this.value,
    this.description,
    this.type,
    this.package,
    this.x,
    this.y,
    this.side,
    this.extra,
  });
  
  factory ComponentData.fromJson(Map<String, dynamic> json) {
    return ComponentData(
      ref: json['ref'] ?? '',
      value: json['value'],
      description: json['description'],
      type: json['type'],
      package: json['package'],
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      side: json['side'],
      extra: json,
    );
  }
}

/// Component category definition
class ComponentCategory {
  final String name;
  final Color color;
  final IconData icon;
  final List<String> keywords;
  
  const ComponentCategory({
    required this.name,
    required this.color,
    required this.icon,
    required this.keywords,
  });
}

/// Component info dialog
class ComponentInfoDialog extends StatelessWidget {
  final ComponentData component;
  final String? deviceModel;
  
  const ComponentInfoDialog({
    super.key,
    required this.component,
    this.deviceModel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.memory, color: Colors.blue, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          component.ref,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (component.value != null)
                          Text(
                            component.value!,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Type', component.type ?? 'Unknown'),
                  if (component.package != null)
                    _buildInfoRow('Package', component.package!),
                  if (component.description != null)
                    _buildInfoRow('Description', component.description!),
                  if (component.x != null && component.y != null)
                    _buildInfoRow('Position', '${component.x!.toStringAsFixed(2)}, ${component.y!.toStringAsFixed(2)}'),
                  if (component.side != null)
                    _buildInfoRow('Side', component.side!),
                  
                  const Divider(height: 32),
                  
                  // Common failures section
                  const Text(
                    'Common Failures',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFailureInfo(),
                  
                  const SizedBox(height: 16),
                  
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.location_on),
                          label: const Text('Find on Board'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TODO: Navigate to board view
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.build),
                          label: const Text('Repair Guide'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TODO: Show repair guide
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureInfo() {
    // Provide common failure info based on component type
    String failureInfo = 'No specific failure data available.';
    
    if (component.type?.toLowerCase().contains('capacitor') ?? false) {
      failureInfo = '• Short circuit (most common)\n• Open circuit\n• Capacitance drift';
    } else if (component.type?.toLowerCase().contains('ic') ?? false) {
      failureInfo = '• Overheating\n• Short on power rails\n• No output signal\n• Intermittent failures';
    } else if (component.type?.toLowerCase().contains('resistor') ?? false) {
      failureInfo = '• Open circuit (burnt)\n• Value drift\n• Corrosion on pads';
    } else if (component.ref.toLowerCase().startsWith('u')) {
      failureInfo = '• Power rail short\n• Overheating\n• No communication\n• Boot failure';
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        failureInfo,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
