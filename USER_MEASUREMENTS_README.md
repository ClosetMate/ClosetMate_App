# User Measurements Feature

## Overview
The User Measurements feature allows users to input their body measurements after signing up, which helps the shopping app provide better size recommendations and fit suggestions.

## Features

### Gender Selection
- Users can select between Male and Female
- Visual cards with icons for easy selection
- Different measurement fields based on gender selection

### Basic Measurements
- Height (cm)
- Weight (kg)

### Male-Specific Measurements
- Chest (cm)
- Waist (cm)
- Hips (cm)
- Inseam (cm)
- Neck (cm)
- Shoulders (cm)
- Biceps (cm)
- Wrist (cm)

### Female-Specific Measurements
- Bust (cm)
- Under Bust (cm)
- Natural Waist (cm)
- Low Waist (cm)
- Hip Circumference (cm)
- Thigh (cm)
- Knee (cm)
- Calf (cm)
- Ankle (cm)
- Arm Length (cm)
- Shoulder to Waist (cm)
- Waist to Hip (cm)

## Navigation Flow

### Initial Setup
1. User completes signup
2. Automatically navigates to User Measurements screen
3. User can either:
   - Fill in measurements and save
   - Skip for now and add later

### Update Measurements
1. User goes to Settings
2. Taps "Update Measurements" option
3. Navigates to User Measurements screen in update mode
4. User can modify existing measurements or cancel

## Files Created/Modified

### New Files
- `lib/models/user_measurements.dart` - Data model for user measurements
- `lib/app/modules/user_measurements/controllers/user_measurements_controller.dart` - Business logic
- `lib/app/modules/user_measurements/bindings/user_measurements_binding.dart` - Dependency injection
- `lib/app/modules/user_measurements/views/user_measurements_view.dart` - UI implementation

### Modified Files
- `lib/app/routes/app_routes.dart` - Added USER_MEASUREMENTS route
- `lib/app/routes/app_pages.dart` - Added route configuration
- `lib/app/modules/signup/controllers/signup_controller.dart` - Updated navigation flow
- `lib/app/modules/settings/controllers/settings_controller.dart` - Added measurements navigation
- `lib/app/modules/settings/views/settings_view.dart` - Added measurements option in settings

## Usage

### For Users

#### Initial Setup
1. Complete the signup process
2. Select your gender (Male/Female)
3. Enter your basic measurements (height, weight)
4. Fill in gender-specific measurements
5. Click "Save Measurements" or "Skip for now"

#### Update Measurements
1. Go to Settings in the app
2. Tap "Update Measurements" option
3. Modify your measurements as needed
4. Click "Update Measurements" or "Cancel"

### For Developers
The measurements are currently stored in a `UserMeasurements` object. To integrate with a backend:

1. Modify the `saveMeasurements()` method in `UserMeasurementsController`
2. Add API calls to save measurements to your backend
3. Implement measurement retrieval for the profile section

## Future Enhancements
- Add measurement unit selection (cm/inches)
- Include measurement diagrams/guides
- Add measurement validation ranges
- Integrate with size recommendation algorithm
- Add measurement history tracking
