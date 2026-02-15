# BoardView Feature Setup Guide

Quick guide to set up and test the interactive boardview feature.

## Prerequisites

- Flutter 3.16+
- Dart 3.11+
- Internet connection (for loading data from GitHub)

## Setup Steps

### 1. Install Dependencies

```bash
cd repairAi
flutter pub get
```

### 2. Generate Code

Generate Freezed models and JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/features/schematic/data/models/boardview_model.freezed.dart`
- `lib/features/schematic/data/models/boardview_model.g.dart`

### 3. Configure GitHub URL

Edit `lib/features/schematic/data/services/boardview_service.dart`:

```dart
BoardViewService({
  this.baseUrl = 'https://raw.githubusercontent.com/YOUR_USERNAME/repairai-files/main',
  // Replace YOUR_USERNAME with your GitHub username
})
```

### 4. Run the App

```bash
flutter run
```

## Testing

### Test with Sample Data

1. Navigate to the **Schematics** tab
2. The sample Samsung A310F boardview should be available
3. Tap to open the interactive viewer

### Test Features

**Zoom & Pan:**
- Pinch to zoom in/out
- Drag to pan around the board
- Use zoom buttons in toolbar

**Component Selection:**
- Tap any component (U1, C1, R1, etc.)
- View component details in bottom sheet
- See connected nets and pins

**Search:**
- Type in search bar: "U1", "10uF", "capacitor"
- Tap search result to jump to component
- Component will be highlighted

**Net Highlighting:**
- Select a component
- Tap on a net name in the details
- Net connections will be highlighted in yellow

**Layer Control:**
- Use layer panel on the right
- Toggle top/bottom copper layers
- Toggle silkscreen layers

**Board Flip:**
- Tap flip button in toolbar
- View switches between top and bottom

## Adding More Devices

### Option 1: Use Existing Boardview Files

If you have `.brd`, `.bdv`, `.asc`, or `.fz` files:

```bash
cd repairai-files/scraper
node src/index.js boardview-convert \
  --input path/to/board.brd \
  --output ../manufacturer/model/boardview \
  --generateSVG
```

### Option 2: Create Manual Data

Create a JSON file following the format in:
`repairai-files/samsung/a310f/boardview/boardview.json`

Place it in:
```
repairai-files/
└── {manufacturer}/
    └── {model}/
        └── boardview/
            └── boardview.json
```

### Option 3: Use Web Contribution Portal

Visit the contribution page (when deployed) to upload boardview files.

## Troubleshooting

### Build Runner Fails

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Data Not Loading

**Check URL:**
```dart
// In boardview_service.dart
print('Loading from: $url');
```

**Check Response:**
```dart
// Add debug logging
print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');
```

**Verify File Exists:**
Visit the URL in your browser:
```
https://raw.githubusercontent.com/YOUR_USERNAME/repairai-files/main/samsung/a310f/boardview/boardview.json
```

### Viewer Performance Issues

For large boards:
1. Reduce visible layers
2. Limit search results to 10
3. Simplify component rendering

### Freezed Errors

If you see errors like "The getter 'copyWith' isn't defined":

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Development Tips

### Hot Reload

Most changes support hot reload, except:
- Model changes (requires code generation)
- Provider changes (may need restart)

### Debug Mode

Enable debug logging in `boardview_service.dart`:

```dart
Future<BoardViewData> loadBoardView({...}) async {
  print('🔍 Loading boardview: $manufacturer $model');
  print('📍 URL: $url');
  
  final response = await httpClient!.get(Uri.parse(url));
  print('📊 Status: ${response.statusCode}');
  
  // ... rest of code
}
```

### Testing Without Network

Create a mock service for testing:

```dart
class MockBoardViewService extends BoardViewService {
  @override
  Future<BoardViewData> loadBoardView({...}) async {
    // Return mock data
    return BoardViewData(...);
  }
}
```

## Next Steps

1. **Add More Devices**: Convert and add boardview files for popular devices
2. **Improve Performance**: Optimize rendering for large boards
3. **Add Features**: Implement measurement tools, annotations, etc.
4. **Offline Support**: Cache boardview data locally
5. **Community**: Enable user contributions

## Resources

- **Parser Documentation**: `repairai-files/scraper/PARSERS_README.md`
- **Integration Guide**: `repairai-files/BOARDVIEW_INTEGRATION_GUIDE.md`
- **Feature Spec**: `repairai-files/INTERACTIVE_SCHEMATIC_SPEC.md`
- **Implementation Status**: `repairai-files/IMPLEMENTATION_COMPLETE.md`

## Support

If you encounter issues:

1. Check this guide
2. Review error logs
3. Verify file paths and URLs
4. Test with sample data first
5. Check GitHub repository structure

## Quick Commands Reference

```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get

# Run app
flutter run

# Convert boardview file
cd repairai-files/scraper
node src/index.js boardview-convert --input board.brd --output ./output

# Run tests
flutter test
```

## Success Checklist

- [ ] Dependencies installed
- [ ] Code generated successfully
- [ ] GitHub URL configured
- [ ] App runs without errors
- [ ] Sample data loads
- [ ] Interactive viewer works
- [ ] Component selection works
- [ ] Search functionality works
- [ ] Net highlighting works
- [ ] Layer controls work

Once all items are checked, the feature is ready to use!
