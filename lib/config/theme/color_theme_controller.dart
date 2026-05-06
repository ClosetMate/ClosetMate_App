import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_colors.dart';
import 'dynamic_color_controller.dart';

/// Simplified Color Theme Controller
/// Shows all configured colors from ThemeColors with light/dark variants
class ColorThemeController extends StatefulWidget {
  const ColorThemeController({super.key});

  @override
  State<ColorThemeController> createState() => _ColorThemeControllerState();
}

class _ColorThemeControllerState extends State<ColorThemeController> {
  late DynamicColorController _colorController;

  @override
  void initState() {
    super.initState();
    _colorController = Get.find<DynamicColorController>();
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Get.isDarkMode == false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Theme Controller'),
        backgroundColor: ThemeColors.getBackground(isLightTheme),
        // foregroundColor: ThemeColors.getButtonText(isLightTheme),
        iconTheme: IconThemeData(
          color: ThemeColors.getButtonBackground(isLightTheme),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Colors Configuration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(isLightTheme),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap any color to change it. Changes apply immediately across the app.',
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.getTextSecondary(isLightTheme),
              ),
            ),
            const SizedBox(height: 24),

            // Primary Colors
            _buildColorSection('Primary Colors', [
              _buildColorItem('Primary', ThemeColors.getPrimary),
              _buildColorItem('Secondary', ThemeColors.getSecondary),
              _buildColorItem('Accent', ThemeColors.getAccent),
            ]),

            // Background Colors
            _buildColorSection('Background Colors', [
              _buildColorItem('Background', ThemeColors.getBackground),
              _buildColorItem('Scaffold Background', ThemeColors.getScaffoldBackground),
              _buildColorItem('Card Background', ThemeColors.getCardBackground),
            ]),

            // Text Colors
            _buildColorSection('Text Colors', [
              _buildColorItem('Text Primary', ThemeColors.getTextPrimary),
              _buildColorItem('Text Secondary', ThemeColors.getTextSecondary),
              _buildColorItem('Text Hint', ThemeColors.getTextHint),
            ]),

            // Interactive Colors
            _buildColorSection('Interactive Colors', [
              _buildColorItem('Button Text', ThemeColors.getButtonText),
              _buildColorItem('Button Background', ThemeColors.getButtonBackground),
              _buildColorItem('Chip Text', ThemeColors.getChipText),
              _buildColorItem('Icon', ThemeColors.getIcon),
              _buildColorItem('App Bar Icon', ThemeColors.getAppBarIcon),
            ]),

            // Utility Colors
            _buildColorSection('Utility Colors', [
              _buildColorItem('Divider', ThemeColors.getDivider),
              _buildColorItem('Progress Indicator', ThemeColors.getProgressIndicator),
              _buildColorItem('Currency', ThemeColors.getCurrency),
            ]),

            // Status Colors (same for both themes)
            _buildColorSection('Status Colors', [
              _buildStatusColorItem('Success', ThemeColors.getSuccess()),
              _buildStatusColorItem('Warning', ThemeColors.getWarning()),
              _buildStatusColorItem('Error', ThemeColors.getError()),
              _buildStatusColorItem('Info', ThemeColors.getInfo()),
            ]),

            const SizedBox(height: 24),

            // Reset Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _resetToDefaultColors,
                icon: const Icon(Icons.restore),
                label: const Text('Reset to Default Colors'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(String title, List<Widget> children) {
    bool isLightTheme = Get.isDarkMode == false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeColors.getTextPrimary(isLightTheme),
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildColorItem(String label, Color Function(bool) colorFunction) {
    final lightColor = colorFunction(true);
    final darkColor = colorFunction(false);
    bool isLightTheme = Get.isDarkMode == false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Label
          SizedBox(
            width: 140,
        child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ThemeColors.getTextSecondary(isLightTheme),
          ),
        ),
          ),
          
          // Light Theme Color
          Expanded(
            child: _buildColorBox(
              'Light',
              lightColor,
              () => _showColorPicker(label, lightColor, true),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Dark Theme Color
          Expanded(
            child: _buildColorBox(
              'Dark',
              darkColor,
              () => _showColorPicker(label, darkColor, false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusColorItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
          children: [
          // Label
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Color (same for both themes)
          Expanded(
            child: _buildColorBox(
              'Both Themes',
              color,
              () => _showStatusColorPicker(label, color),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Empty space to align with other rows
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildColorBox(String themeLabel, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              themeLabel,
              style: TextStyle(
                color: _getContrastColor(color),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
              style: TextStyle(
                color: _getContrastColor(color),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _showColorPicker(String label, Color currentColor, bool isLight) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change $label (${isLight ? 'Light' : 'Dark'} Theme)'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 600,
            maxWidth: 500,
          ),
          child: SizedBox(
            height: 550,
            width: 450,
          child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                _updateColor(label, color, isLight);
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showStatusColorPicker(String label, Color currentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change $label'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 600,
            maxWidth: 500,
          ),
          child: SizedBox(
            height: 550,
            width: 450,
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                _updateStatusColor(label, color);
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _updateColor(String label, Color newColor, bool isLight) {
    setState(() {
      switch (label) {
        case 'Primary':
          _colorController.updatePrimaryColor(newColor, isLight);
          break;
        case 'Secondary':
          _colorController.updateSecondaryColor(newColor, isLight);
          break;
        case 'Accent':
          _colorController.updateAccentColor(newColor, isLight);
          break;
        case 'Background':
          _colorController.updateBackgroundColor(newColor, isLight);
          break;
        case 'Card Background':
          _colorController.updateCardColor(newColor, isLight);
          break;
        case 'Text Primary':
          _colorController.updateTextColor(newColor, isLight);
          break;
        case 'Text Secondary':
          _colorController.updateTextSecondaryColor(newColor, isLight);
          break;
        case 'Text Hint':
          _colorController.updateTextHintColor(newColor, isLight);
          break;
        case 'Button Text':
          _colorController.updateButtonTextColor(newColor, isLight);
          break;
        case 'Button Background':
          _colorController.updateButtonBackgroundColor(newColor, isLight);
          break;
        case 'Chip Text':
          _colorController.updateChipTextColor(newColor, isLight);
          break;
        case 'Icon':
          _colorController.updateIconColor(newColor, isLight);
          break;
        case 'App Bar Icon':
          _colorController.updateAppBarIconColor(newColor, isLight);
          break;
        case 'Divider':
          _colorController.updateDividerColor(newColor, isLight);
          break;
        case 'Progress Indicator':
          _colorController.updateProgressIndicatorColor(newColor, isLight);
          break;
        case 'Currency':
          _colorController.updateCurrencyColor(newColor, isLight);
          break;
      }
    });
  }

  void _updateStatusColor(String label, Color newColor) {
    // Status colors are not currently customizable through the dynamic controller
    // This would require extending the controller to support status colors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label color customization coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _resetToDefaultColors() async {
    await _colorController.resetToDefaultColors();
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Colors reset to default successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/// Advanced Color Picker Widget with full color selection capabilities
class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final Function(Color) onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> with TickerProviderStateMixin {
  late Color currentColor;
  late TabController _tabController;
  late List<Color> _colorWheel;

  @override
  void initState() {
    super.initState();
    currentColor = widget.pickerColor;
    _tabController = TabController(length: 3, vsync: this);
    _colorWheel = _generateColorWheel();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: [
          // Color preview
          Container(
          height: 80,
          width: double.infinity,
            decoration: BoxDecoration(
              color: currentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            ),
            child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#${currentColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: TextStyle(
                  color: _getContrastColor(currentColor),
                    fontSize: 20,
                  fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'RGB(${currentColor.red}, ${currentColor.green}, ${currentColor.blue})',
                  style: TextStyle(
                    color: _getContrastColor(currentColor),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Tab bar for different picker modes
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Wheel', icon: Icon(Icons.color_lens)),
            Tab(text: 'RGB', icon: Icon(Icons.tune)),
            Tab(text: 'Presets', icon: Icon(Icons.palette)),
          ],
        ),
        const SizedBox(height: 16),
        
        // Tab content
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildColorWheel(),
              _buildRGBSliders(),
              _buildPresetColors(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorWheel() {
    return Center(
      child: Column(
        children: [
          Text(
            'Color Wheel (Tap to select)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: _colorWheel.length,
              itemBuilder: (context, index) {
                if (index >= _colorWheel.length) return const SizedBox.shrink();
                
                final color = _colorWheel[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentColor = color;
                    });
                    widget.onColorChanged(currentColor);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: currentColor == color 
                            ? Colors.white 
                            : Colors.grey.withOpacity(0.3),
                        width: currentColor == color ? 3 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRGBSliders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'RGB Sliders',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          
          // Red slider
          Row(
            children: [
              const Text('R:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: currentColor.red.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    setState(() {
                      currentColor = Color.fromARGB(
                        currentColor.alpha,
                        value.round(),
                        currentColor.green,
                        currentColor.blue,
                      );
                    });
                    widget.onColorChanged(currentColor);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${currentColor.red}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          
          // Green slider
          Row(
            children: [
              const Text('G:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: currentColor.green.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      currentColor = Color.fromARGB(
                        currentColor.alpha,
                        currentColor.red,
                        value.round(),
                        currentColor.blue,
                      );
                    });
                    widget.onColorChanged(currentColor);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${currentColor.green}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          
          // Blue slider
          Row(
            children: [
              const Text('B:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: currentColor.blue.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      currentColor = Color.fromARGB(
                        currentColor.alpha,
                        currentColor.red,
                        currentColor.green,
                        value.round(),
                      );
                    });
                    widget.onColorChanged(currentColor);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${currentColor.blue}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Alpha slider
          Row(
            children: [
              const Text('A:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: currentColor.alpha.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  activeColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      currentColor = Color.fromARGB(
                        value.round(),
                        currentColor.red,
                        currentColor.green,
                        currentColor.blue,
                      );
                    });
                    widget.onColorChanged(currentColor);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${currentColor.alpha}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetColors() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Preset Colors',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          
          // Basic colors
          _buildColorSection('Basic Colors', _basicColors),
          const SizedBox(height: 16),
          
          // Material colors
          _buildColorSection('Material Colors', _materialColors),
          const SizedBox(height: 16),
          
          // Custom colors
          _buildColorSection('Custom Colors', _customColors),
        ],
      ),
    );
  }

  Widget _buildColorSection(String title, List<Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentColor = color;
                });
                widget.onColorChanged(currentColor);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: currentColor == color 
                        ? Colors.white 
                        : Colors.grey.withOpacity(0.3),
                    width: currentColor == color ? 3 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  List<Color> _generateColorWheel() {
    List<Color> colors = [];
    
    // Generate colors with different hues, saturations, and lightness
    for (int hue = 0; hue < 360; hue += 30) {
      for (int saturation = 50; saturation <= 100; saturation += 25) {
        for (int lightness = 30; lightness <= 70; lightness += 20) {
          try {
            final hsl = HSLColor.fromAHSL(
              1.0, 
              hue.toDouble(), 
              (saturation / 100).clamp(0.0, 1.0), 
              (lightness / 100).clamp(0.0, 1.0)
            );
            colors.add(hsl.toColor());
          } catch (e) {
            // Skip invalid colors
            continue;
          }
        }
      }
    }
    
    return colors;
  }

  // Basic colors
  final List<Color> _basicColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];

  // Material colors
  final List<Color> _materialColors = [
    Colors.red[50]!, Colors.red[100]!, Colors.red[200]!, Colors.red[300]!,
    Colors.red[400]!, Colors.red[500]!, Colors.red[600]!, Colors.red[700]!,
    Colors.red[800]!, Colors.red[900]!,
    
    Colors.blue[50]!, Colors.blue[100]!, Colors.blue[200]!, Colors.blue[300]!,
    Colors.blue[400]!, Colors.blue[500]!, Colors.blue[600]!, Colors.blue[700]!,
    Colors.blue[800]!, Colors.blue[900]!,
    
    Colors.green[50]!, Colors.green[100]!, Colors.green[200]!, Colors.green[300]!,
    Colors.green[400]!, Colors.green[500]!, Colors.green[600]!, Colors.green[700]!,
    Colors.green[800]!, Colors.green[900]!,
    
    Colors.orange[50]!, Colors.orange[100]!, Colors.orange[200]!, Colors.orange[300]!,
    Colors.orange[400]!, Colors.orange[500]!, Colors.orange[600]!, Colors.orange[700]!,
    Colors.orange[800]!, Colors.orange[900]!,
    
    Colors.purple[50]!, Colors.purple[100]!, Colors.purple[200]!, Colors.purple[300]!,
    Colors.purple[400]!, Colors.purple[500]!, Colors.purple[600]!, Colors.purple[700]!,
    Colors.purple[800]!, Colors.purple[900]!,
  ];

  // Custom colors
  final List<Color> _customColors = [
    const Color(0xFF1A1A1A), // Dark charcoal
    const Color(0xFF2D2D2D), // Dark gray
    const Color(0xFF404040), // Medium gray
    const Color(0xFF666666), // Light gray
    const Color(0xFF999999), // Lighter gray
    const Color(0xFFCCCCCC), // Very light gray
    const Color(0xFFE5E5E5), // Almost white
    const Color(0xFFF5F5F5), // Off white
    
    const Color(0xFF8B0000), // Dark red
    const Color(0xFFDC143C), // Crimson
    const Color(0xFFFF1493), // Deep pink
    const Color(0xFF4B0082), // Indigo
    const Color(0xFF000080), // Navy
    const Color(0xFF006400), // Dark green
    const Color(0xFF8B4513), // Saddle brown
    const Color(0xFFDAA520), // Goldenrod
  ];
} 