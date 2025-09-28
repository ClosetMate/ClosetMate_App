import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/models/user_measurements.dart';
import 'package:closet_mate/app/data/local/my_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMeasurementsController extends GetxController {
  
  // Gender selection
  var selectedGender = ''.obs;
  
  // Track if this is an update (from settings) or initial setup
  var isUpdateMode = false.obs;
  
  // Track current step in the flow
  var currentStep = 0.obs;
  
  // Basic measurements - using RxDouble for sliders
  var height = 170.0.obs; // Range: 120-220
  var weight = 70.0.obs; // Range: 30-150
  
  // Male measurements
  var chest = 90.0.obs; // Range: 60-150
  var waist = 80.0.obs; // Range: 50-150
  var hips = 95.0.obs; // Range: 70-150
  var inseam = 80.0.obs; // Range: 50-120
  var neck = 40.0.obs; // Range: 30-60
  var shoulders = 45.0.obs; // Range: 30-70
  var biceps = 35.0.obs; // Range: 20-60
  var wrist = 18.0.obs; // Range: 12-30
  
  // Female measurements
  var bust = 85.0.obs; // Range: 60-150
  var underBust = 75.0.obs; // Range: 50-140
  var naturalWaist = 70.0.obs; // Range: 50-150
  var lowWaist = 75.0.obs; // Range: 50-150
  var hipCircumference = 95.0.obs; // Range: 70-150
  var thigh = 55.0.obs; // Range: 30-80
  var knee = 35.0.obs; // Range: 20-60
  var calf = 35.0.obs; // Range: 20-60
  var ankle = 22.0.obs; // Range: 15-35
  var armLength = 60.0.obs; // Range: 40-80
  var shoulderToWaist = 40.0.obs; // Range: 20-60
  var waistToHip = 20.0.obs; // Range: 10-40



  @override
  void onInit() {
    super.onInit();
    // Check if this is an update from settings
    isUpdateMode.value = Get.arguments != null && Get.arguments['isUpdate'] == true;
    _loadExistingMeasurements();
    
    // Set initial step based on mode
    if (isUpdateMode.value) {
      currentStep.value = 0; // Start from gender selection for updates
    } else {
      currentStep.value = 0; // Start from gender selection for new users
    }
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // Navigation methods for multi-step flow
  void nextToBasicMeasurements() {
    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select your gender",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Save gender selection
    _savePartialMeasurements();
    
    // Navigate to basic measurements with current arguments
    Get.toNamed(Routes.BASIC_MEASUREMENTS, arguments: Get.arguments);
  }

  void nextToDetailedMeasurements() {
    // Save basic measurements
    _savePartialMeasurements();
    
    // Check if this is from signup (new user) or from settings (update)
    if (isUpdateMode.value) {
      // For updates from settings, show detailed measurements
      Get.toNamed(Routes.DETAILED_MEASUREMENTS, arguments: Get.arguments);
    } else {
      // For new users from signup, skip detailed measurements and go to home
      Get.snackbar(
        "Success",
        "Basic measurements saved! You can add detailed measurements later in settings.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.BASE);
    }
  }

  void _loadExistingMeasurements() {
    final UserMeasurements? saved = MySharedPref.getUserMeasurements();
    if (saved == null) return;

    selectedGender.value = saved.gender;
    height.value = (saved.height ?? 170.0).clamp(120.0, 220.0);
    weight.value = (saved.weight ?? 70.0).clamp(30.0, 150.0);

    // Male measurements with proper clamping
    chest.value = (saved.chest ?? 90.0).clamp(60.0, 150.0);
    waist.value = (saved.waist ?? 80.0).clamp(50.0, 150.0);
    hips.value = (saved.hips ?? 95.0).clamp(70.0, 150.0);
    inseam.value = (saved.inseam ?? 80.0).clamp(50.0, 120.0);
    neck.value = (saved.neck ?? 40.0).clamp(30.0, 60.0);
    shoulders.value = (saved.shoulders ?? 45.0).clamp(30.0, 70.0);
    biceps.value = (saved.biceps ?? 35.0).clamp(20.0, 60.0);
    wrist.value = (saved.wrist ?? 18.0).clamp(12.0, 30.0);

    // Female measurements with proper clamping
    bust.value = (saved.bust ?? 85.0).clamp(60.0, 150.0);
    underBust.value = (saved.underBust ?? 75.0).clamp(50.0, 140.0);
    naturalWaist.value = (saved.naturalWaist ?? 70.0).clamp(50.0, 150.0);
    lowWaist.value = (saved.lowWaist ?? 75.0).clamp(50.0, 150.0);
    hipCircumference.value = (saved.hipCircumference ?? 95.0).clamp(70.0, 150.0);
    thigh.value = (saved.thigh ?? 55.0).clamp(30.0, 80.0);
    knee.value = (saved.knee ?? 35.0).clamp(20.0, 60.0);
    calf.value = (saved.calf ?? 35.0).clamp(20.0, 60.0);
    ankle.value = (saved.ankle ?? 22.0).clamp(15.0, 35.0);
    armLength.value = (saved.armLength ?? 60.0).clamp(40.0, 80.0);
    shoulderToWaist.value = (saved.shoulderToWaist ?? 40.0).clamp(20.0, 60.0);
    waistToHip.value = (saved.waistToHip ?? 20.0).clamp(10.0, 40.0);
  }

  bool get isMale => selectedGender.value == 'Male';
  bool get isFemale => selectedGender.value == 'Female';

  // Save partial measurements as user progresses
  void _savePartialMeasurements() async {
    try {
      final measurements = UserMeasurements(
        gender: selectedGender.value,
        height: height.value,
        weight: weight.value,
        // Male measurements
        chest: isMale ? chest.value : null,
        waist: isMale ? waist.value : null,
        hips: isMale ? hips.value : null,
        inseam: isMale ? inseam.value : null,
        neck: isMale ? neck.value : null,
        shoulders: isMale ? shoulders.value : null,
        biceps: isMale ? biceps.value : null,
        wrist: isMale ? wrist.value : null,
        // Female measurements
        bust: isFemale ? bust.value : null,
        underBust: isFemale ? underBust.value : null,
        naturalWaist: isFemale ? naturalWaist.value : null,
        lowWaist: isFemale ? lowWaist.value : null,
        hipCircumference: isFemale ? hipCircumference.value : null,
        thigh: isFemale ? thigh.value : null,
        knee: isFemale ? knee.value : null,
        calf: isFemale ? calf.value : null,
        ankle: isFemale ? ankle.value : null,
        armLength: isFemale ? armLength.value : null,
        shoulderToWaist: isFemale ? shoulderToWaist.value : null,
        waistToHip: isFemale ? waistToHip.value : null,
      );

      await MySharedPref.setUserMeasurements(measurements);
    } catch (e) {
      // Silent fail for partial saves
    }
  }

  void saveMeasurements() async {
    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select your gender",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }



    try {
      // Create measurements object (currently unused but ready for backend integration)
      final measurements = UserMeasurements(
        gender: selectedGender.value,
        height: height.value,
        weight: weight.value,
        // Male measurements
        chest: isMale ? chest.value : null,
        waist: isMale ? waist.value : null,
        hips: isMale ? hips.value : null,
        inseam: isMale ? inseam.value : null,
        neck: isMale ? neck.value : null,
        shoulders: isMale ? shoulders.value : null,
        biceps: isMale ? biceps.value : null,
        wrist: isMale ? wrist.value : null,
        // Female measurements
        bust: isFemale ? bust.value : null,
        underBust: isFemale ? underBust.value : null,
        naturalWaist: isFemale ? naturalWaist.value : null,
        lowWaist: isFemale ? lowWaist.value : null,
        hipCircumference: isFemale ? hipCircumference.value : null,
        thigh: isFemale ? thigh.value : null,
        knee: isFemale ? knee.value : null,
        calf: isFemale ? calf.value : null,
        ankle: isFemale ? ankle.value : null,
        armLength: isFemale ? armLength.value : null,
        shoulderToWaist: isFemale ? shoulderToWaist.value : null,
        waistToHip: isFemale ? waistToHip.value : null,
      );

      // Save locally
      await MySharedPref.setUserMeasurements(measurements);

      Get.snackbar(
        "Success",
        isUpdateMode.value ? "Measurements updated successfully!" : "Measurements saved successfully!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate based on mode with a small delay to show the success message
      await Future.delayed(const Duration(milliseconds: 500));
      if (isUpdateMode.value) {
        Get.toNamed(Routes.BASE); // Go back to settings
      } else {
        Get.offAllNamed(Routes.BASE); // Go to home for initial setup
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save measurements. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void skipMeasurements() {
    // Save whatever data we have so far
    if (selectedGender.value.isNotEmpty) {
      _savePartialMeasurements();
    }
    
    if (isUpdateMode.value) {
      // If in update mode, just go back to settings
      Get.back();
    } else {
      // If in initial setup mode, show info and go to home
      Get.snackbar(
        "Info",
        "You can add measurements later in your profile",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.BASE);
    }
  }

}
