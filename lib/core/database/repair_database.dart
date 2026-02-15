import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repair Database Service
/// Manages local storage of failure patterns, component cross-references, and repair statistics
class RepairDatabase {
  static const String _failurePatternsKey = 'failure_patterns';
  static const String _componentCrossRefsKey = 'component_cross_refs';
  static const String _repairStatsKey = 'repair_stats';
  static const String _toolRequirementsKey = 'tool_requirements';
  static const String _voltageReferencesKey = 'voltage_references';
  
  /// Initialize the database with default data
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Initialize with default failure patterns if not exists
    if (!prefs.containsKey(_failurePatternsKey)) {
      await _initializeDefaultFailurePatterns();
    }
    
    // Initialize with default voltage references if not exists
    if (!prefs.containsKey(_voltageReferencesKey)) {
      await _initializeDefaultVoltageReferences();
    }
  }
  
  /// Initialize default failure patterns
  Future<void> _initializeDefaultFailurePatterns() async {
    final defaultPatterns = [
      FailurePattern(
        id: 'fp_001',
        symptom: 'Won\'t turn on',
        componentTypes: ['PMIC', 'Power IC', 'Charging IC'],
        probability: 0.7,
        testPoints: [
          TestPoint(name: 'VBAT', expectedVoltage: '3.7-4.2V', description: 'Battery voltage'),
          TestPoint(name: 'VCC_MAIN', expectedVoltage: '3.7-4.2V', description: 'Main power rail'),
          TestPoint(name: 'VIO', expectedVoltage: '1.8V', description: 'I/O voltage'),
        ],
        commonCauses: [
          'Dead battery',
          'Short on main power rail',
          'PMIC failure',
          'Corroded battery connector',
        ],
        repairSteps: [
          'Check battery voltage with multimeter',
          'Check for shorts on VBAT line',
          'Check PMIC output voltages',
          'Inspect battery connector for corrosion',
        ],
      ),
      FailurePattern(
        id: 'fp_002',
        symptom: 'Not charging',
        componentTypes: ['Charging IC', 'USB Controller', 'Charging Port'],
        probability: 0.8,
        testPoints: [
          TestPoint(name: 'VBUS', expectedVoltage: '5V', description: 'USB bus voltage'),
          TestPoint(name: 'VBAT', expectedVoltage: '3.7-4.2V', description: 'Battery voltage'),
          TestPoint(name: 'CHG_EN', expectedVoltage: '1.8-3.3V', description: 'Charge enable signal'),
        ],
        commonCauses: [
          'Damaged charging port',
          'Charging IC failure',
          'Broken USB data lines',
          'Battery temperature sensor fault',
        ],
        repairSteps: [
          'Inspect charging port for damage',
          'Check VBUS voltage at charging IC',
          'Check USB data line continuity',
          'Replace charging IC if no output',
        ],
      ),
      FailurePattern(
        id: 'fp_003',
        symptom: 'No display',
        componentTypes: ['Display IC', 'Backlight IC', 'Display Connector'],
        probability: 0.75,
        testPoints: [
          TestPoint(name: 'VDD_LCD', expectedVoltage: '3.3V', description: 'Display power'),
          TestPoint(name: 'BACKLIGHT', expectedVoltage: '15-25V', description: 'Backlight voltage'),
          TestPoint(name: 'RESET', expectedVoltage: '1.8V', description: 'Display reset signal'),
        ],
        commonCauses: [
          'Damaged display connector',
          'Backlight IC failure',
          'Broken display flex cable',
          'Display driver failure',
        ],
        repairSteps: [
          'Check display connector for damage',
          'Test backlight voltage',
          'Check display power rails',
          'Inspect flex cable for tears',
        ],
      ),
      FailurePattern(
        id: 'fp_004',
        symptom: 'No sound',
        componentTypes: ['Audio IC', 'Audio Amplifier', 'Speaker'],
        probability: 0.65,
        testPoints: [
          TestPoint(name: 'AUD_VDD', expectedVoltage: '3.3V', description: 'Audio IC power'),
          TestPoint(name: 'SPK+', expectedVoltage: 'AC signal', description: 'Speaker positive'),
          TestPoint(name: 'SPK-', expectedVoltage: 'AC signal', description: 'Speaker negative'),
        ],
        commonCauses: [
          'Speaker failure',
          'Audio IC failure',
          'Broken audio traces',
          'Water damage to audio circuit',
        ],
        repairSteps: [
          'Test speaker resistance (typically 4-8 ohms)',
          'Check audio IC power supply',
          'Check audio signal path',
          'Replace audio IC if no output',
        ],
      ),
      FailurePattern(
        id: 'fp_005',
        symptom: 'WiFi/Bluetooth issues',
        componentTypes: ['WiFi Module', 'Bluetooth IC', 'RF Switch'],
        probability: 0.6,
        testPoints: [
          TestPoint(name: 'WLAN_VDD', expectedVoltage: '3.3V', description: 'WiFi power'),
          TestPoint(name: 'BT_VDD', expectedVoltage: '3.3V', description: 'Bluetooth power'),
          TestPoint(name: 'ANT', expectedVoltage: 'N/A', description: 'Antenna connection'),
        ],
        commonCauses: [
          'Antenna connector damage',
          'WiFi/Bluetooth module failure',
          'RF switch failure',
          'Crystal oscillator failure',
        ],
        repairSteps: [
          'Check antenna connector',
          'Test WiFi module power supply',
          'Check crystal oscillator (typically 37.4MHz or 40MHz)',
          'Replace WiFi module if faulty',
        ],
      ),
      FailurePattern(
        id: 'fp_006',
        symptom: 'Overheating',
        componentTypes: ['PMIC', 'CPU', 'Charging IC', 'Power Amplifier'],
        probability: 0.55,
        testPoints: [
          TestPoint(name: 'VBAT', expectedVoltage: '3.7-4.2V', description: 'Battery voltage'),
          TestPoint(name: 'VCC_MAIN', expectedVoltage: '3.7-4.2V', description: 'Main power'),
          TestPoint(name: 'TEMP', expectedVoltage: 'Variable', description: 'Temperature sensor'),
        ],
        commonCauses: [
          'Short on power rail',
          'Failed component drawing excess current',
          'Battery degradation',
          'PMIC failure',
        ],
        repairSteps: [
          'Use thermal camera to identify hot spot',
          'Check current draw in sleep mode',
          'Check for shorts on power rails',
          'Replace overheating component',
        ],
      ),
      FailurePattern(
        id: 'fp_007',
        symptom: 'Camera not working',
        componentTypes: ['Camera Module', 'Camera IC', 'Camera Connector'],
        probability: 0.7,
        testPoints: [
          TestPoint(name: 'CAM_VDD', expectedVoltage: '2.8V', description: 'Camera power'),
          TestPoint(name: 'CAM_DVDD', expectedVoltage: '1.2V', description: 'Camera digital power'),
          TestPoint(name: 'MCLK', expectedVoltage: 'AC signal', description: 'Master clock'),
        ],
        commonCauses: [
          'Damaged camera module',
          'Camera connector damage',
          'Camera IC failure',
          'Broken flex cable',
        ],
        repairSteps: [
          'Check camera connector for damage',
          'Test camera power rails',
          'Check camera clock signal',
          'Replace camera module',
        ],
      ),
      FailurePattern(
        id: 'fp_008',
        symptom: 'Touch not responding',
        componentTypes: ['Touch Controller', 'Digitizer', 'Touch IC'],
        probability: 0.75,
        testPoints: [
          TestPoint(name: 'TOUCH_VDD', expectedVoltage: '3.3V', description: 'Touch power'),
          TestPoint(name: 'TOUCH_INT', expectedVoltage: '1.8V', description: 'Touch interrupt'),
          TestPoint(name: 'TOUCH_SDA', expectedVoltage: '1.8V', description: 'I2C data'),
        ],
        commonCauses: [
          'Digitizer damage',
          'Touch controller failure',
          'Broken touch flex cable',
          'Cracked glass affecting digitizer',
        ],
        repairSteps: [
          'Inspect digitizer for damage',
          'Check touch controller power',
          'Test I2C communication',
          'Replace digitizer assembly',
        ],
      ),
      FailurePattern(
        id: 'fp_009',
        symptom: 'Battery drain',
        componentTypes: ['PMIC', 'Power Amplifier', 'Any IC on power rail'],
        probability: 0.5,
        commonCauses: [
          'Leaky capacitor',
          'Partial short on power rail',
          'Background process issue',
          'Degraded battery',
        ],
        testPoints: [
          TestPoint(name: 'VBAT', expectedVoltage: '3.7-4.2V', description: 'Battery voltage'),
          TestPoint(name: 'SLEEP_CURRENT', expectedVoltage: '<10mA', description: 'Sleep current'),
        ],
        repairSteps: [
          'Measure sleep current',
          'Use thermal camera to find heat source',
          'Check for leaky capacitors',
          'Replace battery if degraded',
        ],
      ),
      FailurePattern(
        id: 'fp_010',
        symptom: 'Boot loop',
        componentTypes: ['CPU', 'eMMC/UFS', 'PMIC', 'Memory'],
        probability: 0.6,
        testPoints: [
          TestPoint(name: 'VDD_CPU', expectedVoltage: '0.8-1.1V', description: 'CPU voltage'),
          TestPoint(name: 'VDD_MEM', expectedVoltage: '1.8V', description: 'Memory voltage'),
          TestPoint(name: 'RESET', expectedVoltage: '1.8V', description: 'Reset signal'),
        ],
        commonCauses: [
          'Corrupted firmware',
          'eMMC/UFS failure',
          'PMIC instability',
          'Memory failure',
        ],
        repairSteps: [
          'Try firmware flash',
          'Check eMMC/UFS health',
          'Check PMIC output stability',
          'Check memory power and signals',
        ],
      ),
    ];
    
    await saveFailurePatterns(defaultPatterns);
  }
  
  /// Initialize default voltage references
  Future<void> _initializeDefaultVoltageReferences() async {
    final defaultRefs = [
      VoltageReference(
        name: 'VBAT',
        description: 'Battery voltage',
        expectedVoltage: '3.7-4.2V',
        typicalValue: 3.85,
        tolerance: 0.15,
        category: 'power',
      ),
      VoltageReference(
        name: 'VCC_MAIN',
        description: 'Main power rail',
        expectedVoltage: '3.7-4.2V',
        typicalValue: 3.85,
        tolerance: 0.15,
        category: 'power',
      ),
      VoltageReference(
        name: 'VBUS',
        description: 'USB bus voltage',
        expectedVoltage: '5V',
        typicalValue: 5.0,
        tolerance: 0.25,
        category: 'power',
      ),
      VoltageReference(
        name: 'VIO',
        description: 'I/O voltage',
        expectedVoltage: '1.8V',
        typicalValue: 1.8,
        tolerance: 0.1,
        category: 'digital',
      ),
      VoltageReference(
        name: 'VDD_CPU',
        description: 'CPU core voltage',
        expectedVoltage: '0.8-1.1V',
        typicalValue: 0.95,
        tolerance: 0.15,
        category: 'digital',
      ),
      VoltageReference(
        name: 'VDD_MEM',
        description: 'Memory voltage',
        expectedVoltage: '1.8V or 1.2V',
        typicalValue: 1.8,
        tolerance: 0.1,
        category: 'digital',
      ),
      VoltageReference(
        name: 'VDD_LCD',
        description: 'Display power',
        expectedVoltage: '3.3V or 5V',
        typicalValue: 3.3,
        tolerance: 0.2,
        category: 'display',
      ),
      VoltageReference(
        name: 'BACKLIGHT',
        description: 'Backlight voltage',
        expectedVoltage: '15-25V',
        typicalValue: 20.0,
        tolerance: 5.0,
        category: 'display',
      ),
      VoltageReference(
        name: 'AUD_VDD',
        description: 'Audio IC power',
        expectedVoltage: '3.3V',
        typicalValue: 3.3,
        tolerance: 0.2,
        category: 'audio',
      ),
      VoltageReference(
        name: 'CAM_VDD',
        description: 'Camera power',
        expectedVoltage: '2.8V',
        typicalValue: 2.8,
        tolerance: 0.2,
        category: 'camera',
      ),
    ];
    
    await saveVoltageReferences(defaultRefs);
  }
  
  // ============ Failure Patterns ============
  
  Future<List<FailurePattern>> getFailurePatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_failurePatternsKey);
      
      if (data == null) return [];
      
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => FailurePattern.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting failure patterns: $e');
      return [];
    }
  }
  
  Future<void> saveFailurePatterns(List<FailurePattern> patterns) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _failurePatternsKey,
        jsonEncode(patterns.map((p) => p.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving failure patterns: $e');
    }
  }
  
  Future<List<FailurePattern>> getPatternsForSymptom(String symptom) async {
    final patterns = await getFailurePatterns();
    return patterns.where((p) => 
      p.symptom.toLowerCase().contains(symptom.toLowerCase())
    ).toList();
  }
  
  // ============ Component Cross-References ============
  
  Future<List<ComponentCrossRef>> getComponentCrossRefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_componentCrossRefsKey);
      
      if (data == null) return [];
      
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => ComponentCrossRef.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting component cross-refs: $e');
      return [];
    }
  }
  
  Future<void> saveComponentCrossRefs(List<ComponentCrossRef> refs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _componentCrossRefsKey,
        jsonEncode(refs.map((r) => r.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving component cross-refs: $e');
    }
  }
  
  Future<void> addComponentCrossRef(ComponentCrossRef ref) async {
    final refs = await getComponentCrossRefs();
    refs.add(ref);
    await saveComponentCrossRefs(refs);
  }
  
  // ============ Repair Statistics ============
  
  Future<List<RepairStatistic>> getRepairStatistics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_repairStatsKey);
      
      if (data == null) return [];
      
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => RepairStatistic.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting repair stats: $e');
      return [];
    }
  }
  
  Future<void> saveRepairStatistics(List<RepairStatistic> stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _repairStatsKey,
        jsonEncode(stats.map((s) => s.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving repair stats: $e');
    }
  }
  
  Future<void> recordRepairAttempt({
    required String deviceModel,
    required String symptom,
    required String componentReplaced,
    required bool successful,
    int? repairTimeMinutes,
  }) async {
    final stats = await getRepairStatistics();
    stats.add(RepairStatistic(
      id: 'stat_${DateTime.now().millisecondsSinceEpoch}',
      deviceModel: deviceModel,
      symptom: symptom,
      componentReplaced: componentReplaced,
      successful: successful,
      repairTimeMinutes: repairTimeMinutes,
      timestamp: DateTime.now(),
    ));
    await saveRepairStatistics(stats);
  }
  
  // ============ Voltage References ============
  
  Future<List<VoltageReference>> getVoltageReferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_voltageReferencesKey);
      
      if (data == null) return [];
      
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => VoltageReference.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting voltage references: $e');
      return [];
    }
  }
  
  Future<void> saveVoltageReferences(List<VoltageReference> refs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _voltageReferencesKey,
        jsonEncode(refs.map((r) => r.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving voltage references: $e');
    }
  }
  
  Future<List<VoltageReference>> getVoltageReferencesByCategory(String category) async {
    final refs = await getVoltageReferences();
    return refs.where((r) => r.category == category).toList();
  }
  
  // ============ Tool Requirements ============
  
  Future<Map<String, List<String>>> getToolRequirements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_toolRequirementsKey);
      
      if (data == null) {
        return _getDefaultToolRequirements();
      }
      
      final Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
    } catch (e) {
      debugPrint('Error getting tool requirements: $e');
      return _getDefaultToolRequirements();
    }
  }
  
  Map<String, List<String>> _getDefaultToolRequirements() {
    return {
      'board_level': [
        'Soldering iron (temperature controlled)',
        'Hot air rework station',
        'Solder wick',
        'Flux (no-clean or rosin)',
        'Solder paste',
        'Tweezers (anti-static)',
        'Magnifying glass or microscope',
        'PCB holder',
      ],
      'diagnostic': [
        'Digital multimeter',
        'USB ammeter',
        'Thermal camera (optional but helpful)',
        'Oscilloscope (for advanced diagnostics)',
      ],
      'disassembly': [
        'Precision screwdriver set',
        'Plastic spudgers',
        'Heat gun (for adhesive)',
        'Suction cups (for display removal)',
      ],
      'testing': [
        'USB cable',
        'Known-good battery',
        'Known-good display (for testing)',
        'External power supply (DC power supply)',
      ],
    };
  }
}

// ============ Data Models ============

/// Failure pattern for a specific symptom
class FailurePattern {
  final String id;
  final String symptom;
  final List<String> componentTypes;
  final double probability;
  final List<TestPoint> testPoints;
  final List<String> commonCauses;
  final List<String> repairSteps;
  
  const FailurePattern({
    required this.id,
    required this.symptom,
    required this.componentTypes,
    required this.probability,
    required this.testPoints,
    required this.commonCauses,
    required this.repairSteps,
  });
  
  factory FailurePattern.fromJson(Map<String, dynamic> json) {
    return FailurePattern(
      id: json['id'] ?? '',
      symptom: json['symptom'] ?? '',
      componentTypes: List<String>.from(json['componentTypes'] ?? []),
      probability: (json['probability'] ?? 0.0).toDouble(),
      testPoints: (json['testPoints'] as List?)
          ?.map((e) => TestPoint.fromJson(e))
          .toList() ?? [],
      commonCauses: List<String>.from(json['commonCauses'] ?? []),
      repairSteps: List<String>.from(json['repairSteps'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symptom': symptom,
      'componentTypes': componentTypes,
      'probability': probability,
      'testPoints': testPoints.map((t) => t.toJson()).toList(),
      'commonCauses': commonCauses,
      'repairSteps': repairSteps,
    };
  }
}

/// Test point for voltage measurement
class TestPoint {
  final String name;
  final String expectedVoltage;
  final String description;
  
  const TestPoint({
    required this.name,
    required this.expectedVoltage,
    required this.description,
  });
  
  factory TestPoint.fromJson(Map<String, dynamic> json) {
    return TestPoint(
      name: json['name'] ?? '',
      expectedVoltage: json['expectedVoltage'] ?? '',
      description: json['description'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expectedVoltage': expectedVoltage,
      'description': description,
    };
  }
}

/// Component cross-reference for replacement parts
class ComponentCrossRef {
  final String originalRef;
  final String originalValue;
  final String? replacementPart;
  final String? alternativeParts;
  final String? notes;
  
  const ComponentCrossRef({
    required this.originalRef,
    required this.originalValue,
    this.replacementPart,
    this.alternativeParts,
    this.notes,
  });
  
  factory ComponentCrossRef.fromJson(Map<String, dynamic> json) {
    return ComponentCrossRef(
      originalRef: json['originalRef'] ?? '',
      originalValue: json['originalValue'] ?? '',
      replacementPart: json['replacementPart'],
      alternativeParts: json['alternativeParts'],
      notes: json['notes'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'originalRef': originalRef,
      'originalValue': originalValue,
      'replacementPart': replacementPart,
      'alternativeParts': alternativeParts,
      'notes': notes,
    };
  }
}

/// Repair statistic for tracking
class RepairStatistic {
  final String id;
  final String deviceModel;
  final String symptom;
  final String componentReplaced;
  final bool successful;
  final int? repairTimeMinutes;
  final DateTime timestamp;
  
  const RepairStatistic({
    required this.id,
    required this.deviceModel,
    required this.symptom,
    required this.componentReplaced,
    required this.successful,
    this.repairTimeMinutes,
    required this.timestamp,
  });
  
  factory RepairStatistic.fromJson(Map<String, dynamic> json) {
    return RepairStatistic(
      id: json['id'] ?? '',
      deviceModel: json['deviceModel'] ?? '',
      symptom: json['symptom'] ?? '',
      componentReplaced: json['componentReplaced'] ?? '',
      successful: json['successful'] ?? false,
      repairTimeMinutes: json['repairTimeMinutes'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceModel': deviceModel,
      'symptom': symptom,
      'componentReplaced': componentReplaced,
      'successful': successful,
      'repairTimeMinutes': repairTimeMinutes,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Voltage reference for test points
class VoltageReference {
  final String name;
  final String description;
  final String expectedVoltage;
  final double typicalValue;
  final double tolerance;
  final String category;
  
  const VoltageReference({
    required this.name,
    required this.description,
    required this.expectedVoltage,
    required this.typicalValue,
    required this.tolerance,
    required this.category,
  });
  
  factory VoltageReference.fromJson(Map<String, dynamic> json) {
    return VoltageReference(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      expectedVoltage: json['expectedVoltage'] ?? '',
      typicalValue: (json['typicalValue'] ?? 0.0).toDouble(),
      tolerance: (json['tolerance'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'expectedVoltage': expectedVoltage,
      'typicalValue': typicalValue,
      'tolerance': tolerance,
      'category': category,
    };
  }
  
  double get minValue => typicalValue - tolerance;
  double get maxValue => typicalValue + tolerance;
  
  bool isInRange(double measuredValue) {
    return measuredValue >= minValue && measuredValue <= maxValue;
  }
}
