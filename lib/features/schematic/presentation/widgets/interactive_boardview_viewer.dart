import 'package:flutter/material.dart';
import '../../data/models/boardview_model.dart';
import 'dart:ui' as ui;

/// Interactive BoardView Viewer Widget
class InteractiveBoardViewViewer extends StatefulWidget {
  final BoardViewData boardData;
  final Function(Component)? onComponentTap;
  final Function(String)? onNetHighlight;

  const InteractiveBoardViewViewer({
    super.key,
    required this.boardData,
    this.onComponentTap,
    this.onNetHighlight,
  });

  @override
  State<InteractiveBoardViewViewer> createState() =>
      _InteractiveBoardViewViewerState();
}

class _InteractiveBoardViewViewerState
    extends State<InteractiveBoardViewViewer> {
  final TransformationController _transformController =
      TransformationController();
  
  Component? _selectedComponent;
  Set<String> _highlightedNets = {};
  Set<String> _visibleLayers = {'top', 'silkscreen-top'};
  bool _showBottomSide = false;
  String _searchQuery = '';
  List<Component> _searchResults = [];

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _selectComponent(Component component) {
    setState(() {
      _selectedComponent = component;
      _highlightedNets.clear();
      
      // Highlight nets connected to this component
      for (final net in widget.boardData.nets) {
        if (net.pins.any((pin) => pin.startsWith('${component.ref}.'))) {
          _highlightedNets.add(net.name);
        }
      }
    });
    
    widget.onComponentTap?.call(component);
  }

  void _highlightNet(String netName) {
    setState(() {
      if (_highlightedNets.contains(netName)) {
        _highlightedNets.remove(netName);
      } else {
        _highlightedNets.add(netName);
      }
    });
    
    widget.onNetHighlight?.call(netName);
  }

  void _toggleLayer(String layerId) {
    setState(() {
      if (_visibleLayers.contains(layerId)) {
        _visibleLayers.remove(layerId);
      } else {
        _visibleLayers.add(layerId);
      }
    });
  }

  void _flipBoard() {
    setState(() {
      _showBottomSide = !_showBottomSide;
      _visibleLayers.clear();
      if (_showBottomSide) {
        _visibleLayers.addAll(['bottom', 'silkscreen-bottom']);
      } else {
        _visibleLayers.addAll(['top', 'silkscreen-top']);
      }
    });
  }

  void _resetView() {
    _transformController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final matrix = _transformController.value.clone();
    matrix.scale(1.2);
    _transformController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformController.value.clone();
    matrix.scale(0.8);
    _transformController.value = matrix;
  }

  void _searchComponents(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults.clear();
        return;
      }
      
      _searchResults = widget.boardData.components.where((c) {
        return c.ref.toLowerCase().contains(query.toLowerCase()) ||
               (c.value?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               (c.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    });
  }

  void _jumpToComponent(Component component) {
    // Calculate the transformation to center on the component
    final boardWidth = widget.boardData.board.width;
    final boardHeight = widget.boardData.board.height;
    
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    
    // Calculate scale to fit board
    final scaleX = screenSize.width / boardWidth;
    final scaleY = screenSize.height / boardHeight;
    final scale = (scaleX < scaleY ? scaleX : scaleY) * 0.8;
    
    // Calculate translation to center component
    final translateX = screenSize.width / 2 - component.x * scale;
    final translateY = screenSize.height / 2 - component.y * scale;
    
    final matrix = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(scale);
    
    _transformController.value = matrix;
    _selectComponent(component);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main board viewer
        InteractiveViewer(
          transformationController: _transformController,
          minScale: 0.1,
          maxScale: 10.0,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: GestureDetector(
            onTapUp: (details) => _handleTap(details.localPosition),
            child: CustomPaint(
              size: Size(
                widget.boardData.board.width,
                widget.boardData.board.height,
              ),
              painter: BoardViewPainter(
                boardData: widget.boardData,
                selectedComponent: _selectedComponent,
                highlightedNets: _highlightedNets,
                visibleLayers: _visibleLayers,
                showBottomSide: _showBottomSide,
                searchResults: _searchResults,
              ),
            ),
          ),
        ),
        
        // Toolbar
        Positioned(
          left: 16,
          top: 16,
          child: _buildToolbar(),
        ),
        
        // Layer controls
        Positioned(
          right: 16,
          top: 16,
          child: _buildLayerControls(),
        ),
        
        // Search bar
        Positioned(
          top: 16,
          left: 80,
          right: 80,
          child: _buildSearchBar(),
        ),
        
        // Component info panel
        if (_selectedComponent != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildComponentInfo(),
          ),
        
        // Search results
        if (_searchResults.isNotEmpty)
          Positioned(
            top: 70,
            left: 80,
            right: 80,
            child: _buildSearchResults(),
          ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _zoomOut,
            tooltip: 'Zoom Out',
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _resetView,
            tooltip: 'Reset View',
          ),
          IconButton(
            icon: const Icon(Icons.flip),
            onPressed: _flipBoard,
            tooltip: 'Flip Board',
          ),
        ],
      ),
    );
  }

  Widget _buildLayerControls() {
    final layers = [
      {'id': 'top', 'name': 'Top Copper', 'icon': Icons.layers},
      {'id': 'bottom', 'name': 'Bottom Copper', 'icon': Icons.layers_outlined},
      {'id': 'silkscreen-top', 'name': 'Top Silkscreen', 'icon': Icons.text_fields},
      {'id': 'silkscreen-bottom', 'name': 'Bottom Silkscreen', 'icon': Icons.text_fields_outlined},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Layers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...layers.map((layer) => SizedBox(
              width: double.infinity,
              child: CheckboxListTile(
                dense: true,
                title: Text(layer['name'] as String, style: const TextStyle(fontSize: 12)),
                value: _visibleLayers.contains(layer['id']),
                onChanged: (value) => _toggleLayer(layer['id'] as String),
                secondary: Icon(layer['icon'] as IconData, size: 16),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search components (e.g., U1, C5, 10uF)...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchComponents(''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: _searchComponents,
      ),
    );
  }

  Widget _buildSearchResults() {
    return Card(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final component = _searchResults[index];
            return ListTile(
              dense: true,
              leading: Icon(_getComponentIcon(component.type)),
              title: Text(component.ref),
              subtitle: Text(component.value ?? component.type),
              trailing: Text('${component.x.toStringAsFixed(1)}, ${component.y.toStringAsFixed(1)}'),
              onTap: () => _jumpToComponent(component),
            );
          },
        ),
      ),
    );
  }

  Widget _buildComponentInfo() {
    final component = _selectedComponent!;
    final connectedNets = widget.boardData.nets
        .where((net) => net.pins.any((pin) => pin.startsWith('${component.ref}.')))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getComponentIcon(component.type), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        component.ref,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (component.value != null)
                        Text(
                          component.value!,
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _selectedComponent = null),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Type', component.type),
            if (component.package != null)
              _buildInfoRow('Package', component.package!),
            _buildInfoRow('Position', '${component.x.toStringAsFixed(2)}, ${component.y.toStringAsFixed(2)}'),
            _buildInfoRow('Side', component.side),
            if (component.rotation != 0)
              _buildInfoRow('Rotation', '${component.rotation}°'),
            if (component.description != null)
              _buildInfoRow('Description', component.description!),
            if (connectedNets.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Connected Nets:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: connectedNets.map((net) => ActionChip(
                  label: Text(net.name, style: const TextStyle(fontSize: 12)),
                  onPressed: () => _highlightNet(net.name),
                  backgroundColor: _highlightedNets.contains(net.name)
                      ? Colors.blue.withOpacity(0.3)
                      : null,
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
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

  IconData _getComponentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ic':
      case 'chip':
        return Icons.memory;
      case 'capacitor':
        return Icons.battery_charging_full;
      case 'resistor':
        return Icons.linear_scale;
      case 'inductor':
        return Icons.waves;
      case 'diode':
        return Icons.arrow_forward;
      case 'transistor':
        return Icons.electrical_services;
      case 'connector':
        return Icons.cable;
      default:
        return Icons.circle_outlined;
    }
  }

  void _handleTap(Offset position) {
    // Find component at tap position
    for (final component in widget.boardData.components) {
      final distance = (Offset(component.x, component.y) - position).distance;
      if (distance < 5.0) { // 5mm tolerance
        _selectComponent(component);
        return;
      }
    }
    
    // Clear selection if tapped on empty space
    setState(() {
      _selectedComponent = null;
      _highlightedNets.clear();
    });
  }
}

/// Custom painter for board view
class BoardViewPainter extends CustomPainter {
  final BoardViewData boardData;
  final Component? selectedComponent;
  final Set<String> highlightedNets;
  final Set<String> visibleLayers;
  final bool showBottomSide;
  final List<Component> searchResults;

  BoardViewPainter({
    required this.boardData,
    this.selectedComponent,
    required this.highlightedNets,
    required this.visibleLayers,
    required this.showBottomSide,
    required this.searchResults,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw board outline
    _drawBoardOutline(canvas);
    
    // Draw components
    _drawComponents(canvas);
    
    // Draw highlighted nets
    _drawHighlightedNets(canvas);
    
    // Draw selected component highlight
    if (selectedComponent != null) {
      _drawSelectedComponent(canvas);
    }
    
    // Draw search results
    _drawSearchResults(canvas);
  }

  void _drawBoardOutline(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final outline = boardData.board.outline;
    
    if (outline.isNotEmpty) {
      path.moveTo(outline[0][0], outline[0][1]);
      for (var i = 1; i < outline.length; i++) {
        path.lineTo(outline[i][0], outline[i][1]);
      }
      path.close();
    }
    
    canvas.drawPath(path, paint);
  }

  void _drawComponents(Canvas canvas) {
    for (final component in boardData.components) {
      // Skip if on wrong side
      if (showBottomSide && component.side == 'top') continue;
      if (!showBottomSide && component.side == 'bottom') continue;
      
      _drawComponent(canvas, component);
    }
  }

  void _drawComponent(Canvas canvas, Component component) {
    final paint = Paint()
      ..color = component == selectedComponent
          ? Colors.blue
          : Colors.green.shade700
      ..style = PaintingStyle.fill;

    // Draw component as a circle (simplified)
    canvas.drawCircle(
      Offset(component.x, component.y),
      2.0,
      paint,
    );

    // Draw component reference
    final textPainter = TextPainter(
      text: TextSpan(
        text: component.ref,
        style: TextStyle(
          color: Colors.white,
          fontSize: 3.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(component.x + 3, component.y - 1.5),
    );
  }

  void _drawHighlightedNets(Canvas canvas) {
    if (highlightedNets.isEmpty) return;

    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final net in boardData.nets) {
      if (!highlightedNets.contains(net.name)) continue;
      
      // Draw connections between pins in this net
      final pins = boardData.pins.where((p) => p.net == net.name).toList();
      
      for (var i = 0; i < pins.length - 1; i++) {
        canvas.drawLine(
          Offset(pins[i].x, pins[i].y),
          Offset(pins[i + 1].x, pins[i + 1].y),
          paint,
        );
      }
    }
  }

  void _drawSelectedComponent(Canvas canvas) {
    final component = selectedComponent!;
    
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(component.x, component.y),
      5.0,
      paint,
    );
  }

  void _drawSearchResults(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final component in searchResults) {
      canvas.drawCircle(
        Offset(component.x, component.y),
        4.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BoardViewPainter oldDelegate) {
    return oldDelegate.selectedComponent != selectedComponent ||
           oldDelegate.highlightedNets != highlightedNets ||
           oldDelegate.visibleLayers != visibleLayers ||
           oldDelegate.showBottomSide != showBottomSide ||
           oldDelegate.searchResults != searchResults;
  }
}
