# Schematic/BoardView Feature

Interactive PCB boardview viewer for RepairAI mobile app.

## Overview

This feature allows users to view interactive PCB layouts with component locations, net highlighting, and search functionality. It's integrated with the GitHub-based file repository for loading boardview data.

## Architecture

```
schematic/
├── data/
│   ├── models/
│   │   └── boardview_model.dart          # Freezed data models
│   ├── services/
│   │   └── boardview_service.dart        # Data loading service
│   └── providers/
│       └── boardview_providers.dart      # Riverpod providers
└── presentation/
    ├── pages/
    │   └── schematic_page.dart           # Main schematic browser
    └── widgets/
        └── interactive_boardview_viewer.dart  # Interactive viewer widget
```

## Setup

### 1. Install Dependencies

```bash
cd repairAi
flutter pub get
```

### 2. Generate Freezed Models

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `boardview_model.freezed.dart`
- `boardview_model.g.dart`

### 3. Configure GitHub Repository URL

Update the base URL in `boardview_service.dart`:

```dart
BoardViewService({
  this.baseUrl = 'https://raw.githubusercontent.com/YOUR_USERNAME/repairai-files/main',
  // ...
})
```

## Usage

### Loading Boardview Data

```dart
// Using Riverpod provider
final params = BoardViewParams(
  manufacturer: 'samsung',
  model: 'a310f',
);

final boardDataAsync = ref.watch(boardViewDataProvider(params));

boardDataAsync.when(
  data: (boardData) {
    // Use boardData
  },
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### Using the Interactive Viewer

```dart
InteractiveBoardViewViewer(
  boardData: boardData,
  onComponentTap: (component) {
    // Handle component tap
    print('Tapped: ${component.ref}');
  },
  onNetHighlight: (netName) {
    // Handle net highlight
    print('Highlighted: $netName');
  },
)
```

## Features

### Interactive Viewer

- **Zoom & Pan**: Pinch to zoom, drag to pan
- **Component Selection**: Tap components to select
- **Net Highlighting**: Highlight electrical connections
- **Layer Control**: Toggle visibility of layers
- **Search**: Search components by reference, value, or type
- **Board Flip**: View top/bottom sides

### Component Details

When a component is tapped, a bottom sheet shows:
- Component reference (e.g., U1, C5)
- Value (e.g., 10uF, STM32)
- Type (IC, capacitor, resistor, etc.)
- Package (BGA-256, 0402, etc.)
- Position coordinates
- Mounting side (top/bottom)
- Connected nets
- Pin list

### Search Functionality

Search supports:
- Component reference: "U1", "C5"
- Component value: "10uF", "STM32"
- Component type: "capacitor", "IC"
- Component description: "power management"

## Data Format

Boardview data is stored in JSON format:

```json
{
  "format": "BRD",
  "version": "1.0",
  "board": {
    "width": 150.0,
    "height": 75.0,
    "outline": [[0, 0], [150, 0], [150, 75], [0, 75]],
    "units": "mm"
  },
  "device": {
    "manufacturer": "Samsung",
    "model": "Galaxy A3",
    "boardNumber": "A310F"
  },
  "components": [
    {
      "ref": "U1",
      "type": "IC",
      "x": 75.0,
      "y": 37.5,
      "value": "Exynos 7578",
      "package": "BGA-256",
      "side": "top",
      "description": "Main SoC"
    }
  ],
  "nets": [
    {
      "name": "VDD_CORE",
      "pins": ["U1.1", "U4.1", "C1.1"]
    }
  ],
  "pins": [
    {
      "component": "U1",
      "number": "1",
      "net": "VDD_CORE",
      "x": 75.0,
      "y": 37.0
    }
  ]
}
```

## File Structure

Boardview files should be organized in the repository:

```
repairai-files/
└── {manufacturer}/
    └── {model}/
        └── boardview/
            ├── boardview.json      # Main data file
            ├── layers/
            │   ├── top.svg         # Top copper layer
            │   ├── bottom.svg      # Bottom copper layer
            │   ├── combined.svg    # Combined view
            │   └── ...
            ├── preview.png         # Preview image
            └── original.brd        # Original boardview file
```

## Converting Boardview Files

Use the scraper tool to convert boardview files:

```bash
cd repairai-files/scraper
node src/index.js boardview-convert --input board.brd --output ./output --generateSVG
```

Supported formats:
- `.brd` - Binary/text format
- `.bdv`, `.bv` - Encoded format
- `.asc` - ASCII format
- `.fz` - Encrypted format (requires key)

## Testing

### Sample Data

A sample boardview file is included for Samsung Galaxy A3 (A310F):
- `repairai-files/samsung/a310f/boardview/boardview.json`

### Manual Testing

1. Run the app
2. Navigate to Schematics tab
3. Search for "samsung a310f"
4. Tap to open interactive viewer
5. Test features:
   - Zoom in/out
   - Pan around
   - Tap components
   - Search for "U1"
   - Highlight nets
   - Flip board

## Troubleshooting

### Freezed Models Not Generated

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Data Not Loading

1. Check GitHub repository URL in `boardview_service.dart`
2. Verify file exists at expected path
3. Check network connectivity
4. Review error logs

### Viewer Performance Issues

For large boards (>500 components):
- Reduce visible layers
- Limit search results
- Use simplified rendering

## Future Enhancements

- [ ] Offline caching
- [ ] 3D board view
- [ ] Measurement tools
- [ ] Component datasheet links
- [ ] Export functionality
- [ ] Annotation support
- [ ] AR overlay
- [ ] Multi-board comparison

## Contributing

To add boardview files:

1. Convert boardview file using scraper
2. Place in correct directory structure
3. Test loading in app
4. Submit pull request

See `repairai-files/BOARDVIEW_INTEGRATION_GUIDE.md` for details.

## License

Based on OpenBoardView (MIT License)
