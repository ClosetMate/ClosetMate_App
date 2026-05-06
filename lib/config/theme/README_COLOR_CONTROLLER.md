# Color Theme Controller

An interactive color and theme controller screen for experimenting with different color patterns in your Flutter app.

## How to Access

1. Navigate to the **Profile** screen in your app
2. Tap on **"Color Theme Controller"** in the options list
3. You'll be taken to the interactive color controller screen

## Features

### 🎨 **Theme Toggle**
- Switch between Light and Dark themes
- See how colors adapt to different themes

### 🎯 **Predefined Color Schemes**
- **Default**: Your current app colors
- **Ocean Blue**: Cool blue tones
- **Forest Green**: Natural green palette
- **Sunset Orange**: Warm orange tones
- **Royal Purple**: Elegant purple scheme
- **Midnight Dark**: Dark theme with blue accents

### 🎨 **Custom Color Picker**
- Tap on any color to open a color picker
- Choose from a wide range of predefined colors
- See hex codes for each color
- Real-time preview of changes

### 👀 **Live Preview**
- See how your color choices look in a realistic app interface
- Preview includes:
  - App bar
  - Text elements
  - Buttons
  - Chips
  - Background colors

### 📋 **Export Options**
- **Copy to Clipboard**: Generates Dart code with your color scheme
- **Save to File**: (Coming soon) Save your color scheme to a file

## How to Use

1. **Try Predefined Schemes**: Tap on any scheme card to instantly apply those colors
2. **Customize Colors**: Tap on individual color pickers to change specific colors
3. **Toggle Theme**: Use the theme toggle to see how colors look in light vs dark mode
4. **Preview**: Scroll down to see a live preview of your color choices
5. **Export**: Use the export buttons to get the Dart code for your color scheme

## Generated Code Example

When you export, you'll get code like this:

```dart
// Generated Color Scheme
class CustomColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFFE3F2FD);
  static const Color accent = Color(0xFF00BCD4);
  static const Color background = Color(0xFFF5F9FF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1976D2);
}
```

## Tips for Good Color Schemes

1. **Contrast**: Ensure text is readable against backgrounds
2. **Consistency**: Use similar colors for similar UI elements
3. **Accessibility**: Consider color blindness and visual impairments
4. **Brand Identity**: Choose colors that reflect your app's personality
5. **Theme Adaptation**: Test both light and dark themes

## Integration with Your App

To use a color scheme you've created:

1. Copy the generated code
2. Replace the colors in `lib/config/theme/app_colors.dart`
3. Or create a new color scheme file and import it
4. Update your theme configuration to use the new colors

## Navigation

- **Back Button**: Returns to the profile screen
- **Theme Toggle**: Switch between light/dark mode
- **Export Buttons**: Copy colors or save to file

Enjoy experimenting with your app's color scheme! 🎨 