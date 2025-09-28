import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Interactive Color and Theme Controller Screen
/// Allows experimenting with different color patterns for the app
class ColorThemeController extends StatefulWidget {
  const ColorThemeController({super.key});

  @override
  State<ColorThemeController> createState() => _ColorThemeControllerState();
}

class _ColorThemeControllerState extends State<ColorThemeController> {
  bool isLightTheme = true;
  
  // Color controllers for experimentation
  Color primaryColor = AppColors.primary;
  Color secondaryColor = AppColors.secondary;
  Color accentColor = AppColors.accent;
  Color backgroundColor = AppColors.backgroundLight;
  Color cardColor = AppColors.cardLight;
  Color textColor = AppColors.textPrimaryLight;
  
  // Predefined color schemes
  final List<ColorScheme> predefinedSchemes = [
    ColorScheme(
      name: 'Default',
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      accent: AppColors.accent,
      background: AppColors.backgroundLight,
      card: AppColors.cardLight,
      text: AppColors.textPrimaryLight,
    ),
    ColorScheme(
      name: 'Ocean Blue',
      primary: Color(0xFF2196F3),
      secondary: Color(0xFFE3F2FD),
      accent: Color(0xFF00BCD4),
      background: Color(0xFFF5F9FF),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF1976D2),
    ),
    ColorScheme(
      name: 'Forest Green',
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFFE8F5E8),
      accent: Color(0xFF8BC34A),
      background: Color(0xFFF5FFF5),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF2E7D32),
    ),
    ColorScheme(
      name: 'Sunset Orange',
      primary: Color(0xFFFF5722),
      secondary: Color(0xFFFFEBEE),
      accent: Color(0xFFFF9800),
      background: Color(0xFFFFF8F5),
      card: Color(0xFFFFFFFF),
      text: Color(0xFFD84315),
    ),
    ColorScheme(
      name: 'Royal Purple',
      primary: Color(0xFF9C27B0),
      secondary: Color(0xFFF3E5F5),
      accent: Color(0xFFE91E63),
      background: Color(0xFFFDF5FF),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF7B1FA2),
    ),
    ColorScheme(
      name: 'Midnight Dark',
      primary: Color(0xFF424242),
      secondary: Color(0xFFE0E0E0),
      accent: Color(0xFF64B5F6),
      background: Color(0xFF303030),
      card: Color(0xFF424242),
      text: Color(0xFFE0E0E0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Color Theme Controller'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isLightTheme ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                isLightTheme = !isLightTheme;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Toggle
            _buildThemeToggle(),
            SizedBox(height: 24),
            
            // Predefined Schemes
            _buildPredefinedSchemes(),
            SizedBox(height: 24),
            
            // Color Customization
            _buildColorCustomization(),
            SizedBox(height: 24),
            
            // Preview Section
            _buildPreviewSection(),
            SizedBox(height: 24),
            
            // Export Section
            _buildExportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Card(
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildThemeButton(
                    'Light Theme',
                    isLightTheme,
                    () => setState(() => isLightTheme = true),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildThemeButton(
                    'Dark Theme',
                    !isLightTheme,
                    () => setState(() => isLightTheme = false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPredefinedSchemes() {
    return Card(
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predefined Color Schemes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: predefinedSchemes.map((scheme) {
                return _buildSchemeButton(scheme);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeButton(ColorScheme scheme) {
    bool isSelected = scheme.primary == primaryColor;
    return GestureDetector(
      onTap: () {
        setState(() {
          primaryColor = scheme.primary;
          secondaryColor = scheme.secondary;
          accentColor = scheme.accent;
          backgroundColor = scheme.background;
          cardColor = scheme.card;
          textColor = scheme.text;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              scheme.name,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColorDot(scheme.primary),
                _buildColorDot(scheme.secondary),
                _buildColorDot(scheme.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 16,
      height: 16,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildColorCustomization() {
    return Card(
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customize Colors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildColorPicker('Primary Color', primaryColor, (color) {
              setState(() => primaryColor = color);
            }),
            SizedBox(height: 12),
            _buildColorPicker('Secondary Color', secondaryColor, (color) {
              setState(() => secondaryColor = color);
            }),
            SizedBox(height: 12),
            _buildColorPicker('Accent Color', accentColor, (color) {
              setState(() => accentColor = color);
            }),
            SizedBox(height: 12),
            _buildColorPicker('Background Color', backgroundColor, (color) {
              setState(() => backgroundColor = color);
            }),
            SizedBox(height: 12),
            _buildColorPicker('Card Color', cardColor, (color) {
              setState(() => cardColor = color);
            }),
            SizedBox(height: 12),
            _buildColorPicker('Text Color', textColor, (color) {
              setState(() => textColor = color);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(String label, Color currentColor, Function(Color) onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(color: textColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => _showColorPicker(currentColor, onChanged),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: currentColor,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: TextStyle(
                    color: _getContrastColor(currentColor),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(Color initialColor, Function(Color) onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: onChanged,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Widget _buildPreviewSection() {
    return Card(
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // App Bar Preview
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'App Bar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Content Preview
                  Text(
                    'Sample Text',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is how your text will look with the selected colors.',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Button Preview
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Primary Button'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: textColor,
                          ),
                          child: Text('Secondary'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // Chip Preview
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text('Chip 1'),
                        backgroundColor: accentColor,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      Chip(
                        label: Text('Chip 2'),
                        backgroundColor: secondaryColor,
                        labelStyle: TextStyle(color: textColor),
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

  Widget _buildExportSection() {
    return Card(
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Colors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportToClipboard,
                    icon: Icon(Icons.copy),
                    label: Text('Copy to Clipboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportToFile,
                    icon: Icon(Icons.download),
                    label: Text('Save to File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _exportToClipboard() {
    final colorCode = '''
// Generated Color Scheme
class CustomColors {
  static const Color primary = Color(0x${primaryColor.value.toRadixString(16)});
  static const Color secondary = Color(0x${secondaryColor.value.toRadixString(16)});
  static const Color accent = Color(0x${accentColor.value.toRadixString(16)});
  static const Color background = Color(0x${backgroundColor.value.toRadixString(16)});
  static const Color card = Color(0x${cardColor.value.toRadixString(16)});
  static const Color text = Color(0x${textColor.value.toRadixString(16)});
}
''';
    
    // In a real app, you'd use Clipboard.setData()
    print('Color scheme copied to console:');
    print(colorCode);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Color scheme copied to console'),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _exportToFile() {
    // In a real app, you'd implement file saving
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export to file feature coming soon!'),
        backgroundColor: accentColor,
      ),
    );
  }
}

/// Color Scheme Model
class ColorScheme {
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color card;
  final Color text;

  ColorScheme({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.card,
    required this.text,
  });
}

/// Simple Color Picker Widget
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

class _ColorPickerState extends State<ColorPicker> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          // Color preview
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text(
                '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
                style: TextStyle(
                  color: _getContrastColor(currentColor),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Color palette
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _predefinedColors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentColor = _predefinedColors[index];
                    });
                    widget.onColorChanged(currentColor);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _predefinedColors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentColor == _predefinedColors[index] 
                            ? Colors.white 
                            : Colors.grey.withOpacity(0.3),
                        width: currentColor == _predefinedColors[index] ? 3 : 1,
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

  Color _getContrastColor(Color backgroundColor) {
    double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  final List<Color> _predefinedColors = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
    Colors.brown, Colors.grey, Colors.blueGrey, Colors.black,
    Colors.white, Colors.red[100]!, Colors.blue[100]!, Colors.green[100]!,
    Colors.yellow[100]!, Colors.orange[100]!, Colors.purple[100]!, Colors.pink[100]!,
    Colors.teal[100]!, Colors.indigo[100]!, Colors.cyan[100]!, Colors.lime[100]!,
    Colors.amber[100]!, Colors.deepOrange[100]!, Colors.deepPurple[100]!, Colors.lightBlue[100]!,
  ];
} 