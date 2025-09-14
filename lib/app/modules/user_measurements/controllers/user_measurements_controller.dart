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
  
  // Basic measurements
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  
  // Male measurements
  final chestController = TextEditingController();
  final waistController = TextEditingController();
  final hipsController = TextEditingController();
  final inseamController = TextEditingController();
  final neckController = TextEditingController();
  final shouldersController = TextEditingController();
  final bicepsController = TextEditingController();
  final wristController = TextEditingController();
  
  // Female measurements
  final bustController = TextEditingController();
  final underBustController = TextEditingController();
  final naturalWaistController = TextEditingController();
  final lowWaistController = TextEditingController();
  final hipCircumferenceController = TextEditingController();
  final thighController = TextEditingController();
  final kneeController = TextEditingController();
  final calfController = TextEditingController();
  final ankleController = TextEditingController();
  final armLengthController = TextEditingController();
  final shoulderToWaistController = TextEditingController();
  final waistToHipController = TextEditingController();



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
    heightController.text = saved.height?.toString() ?? '';
    weightController.text = saved.weight?.toString() ?? '';

    // Male
    chestController.text = saved.chest?.toString() ?? '';
    waistController.text = saved.waist?.toString() ?? '';
    hipsController.text = saved.hips?.toString() ?? '';
    inseamController.text = saved.inseam?.toString() ?? '';
    neckController.text = saved.neck?.toString() ?? '';
    shouldersController.text = saved.shoulders?.toString() ?? '';
    bicepsController.text = saved.biceps?.toString() ?? '';
    wristController.text = saved.wrist?.toString() ?? '';

    // Female
    bustController.text = saved.bust?.toString() ?? '';
    underBustController.text = saved.underBust?.toString() ?? '';
    naturalWaistController.text = saved.naturalWaist?.toString() ?? '';
    lowWaistController.text = saved.lowWaist?.toString() ?? '';
    hipCircumferenceController.text = saved.hipCircumference?.toString() ?? '';
    thighController.text = saved.thigh?.toString() ?? '';
    kneeController.text = saved.knee?.toString() ?? '';
    calfController.text = saved.calf?.toString() ?? '';
    ankleController.text = saved.ankle?.toString() ?? '';
    armLengthController.text = saved.armLength?.toString() ?? '';
    shoulderToWaistController.text = saved.shoulderToWaist?.toString() ?? '';
    waistToHipController.text = saved.waistToHip?.toString() ?? '';
  }

  bool get isMale => selectedGender.value == 'Male';
  bool get isFemale => selectedGender.value == 'Female';

  // Save partial measurements as user progresses
  void _savePartialMeasurements() async {
    try {
      final measurements = UserMeasurements(
        gender: selectedGender.value,
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        // Male measurements
        chest: isMale ? double.tryParse(chestController.text) : null,
        waist: isMale ? double.tryParse(waistController.text) : null,
        hips: isMale ? double.tryParse(hipsController.text) : null,
        inseam: isMale ? double.tryParse(inseamController.text) : null,
        neck: isMale ? double.tryParse(neckController.text) : null,
        shoulders: isMale ? double.tryParse(shouldersController.text) : null,
        biceps: isMale ? double.tryParse(bicepsController.text) : null,
        wrist: isMale ? double.tryParse(wristController.text) : null,
        // Female measurements
        bust: isFemale ? double.tryParse(bustController.text) : null,
        underBust: isFemale ? double.tryParse(underBustController.text) : null,
        naturalWaist: isFemale ? double.tryParse(naturalWaistController.text) : null,
        lowWaist: isFemale ? double.tryParse(lowWaistController.text) : null,
        hipCircumference: isFemale ? double.tryParse(hipCircumferenceController.text) : null,
        thigh: isFemale ? double.tryParse(thighController.text) : null,
        knee: isFemale ? double.tryParse(kneeController.text) : null,
        calf: isFemale ? double.tryParse(calfController.text) : null,
        ankle: isFemale ? double.tryParse(ankleController.text) : null,
        armLength: isFemale ? double.tryParse(armLengthController.text) : null,
        shoulderToWaist: isFemale ? double.tryParse(shoulderToWaistController.text) : null,
        waistToHip: isFemale ? double.tryParse(waistToHipController.text) : null,
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
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        // Male measurements
        chest: isMale ? double.tryParse(chestController.text) : null,
        waist: isMale ? double.tryParse(waistController.text) : null,
        hips: isMale ? double.tryParse(hipsController.text) : null,
        inseam: isMale ? double.tryParse(inseamController.text) : null,
        neck: isMale ? double.tryParse(neckController.text) : null,
        shoulders: isMale ? double.tryParse(shouldersController.text) : null,
        biceps: isMale ? double.tryParse(bicepsController.text) : null,
        wrist: isMale ? double.tryParse(wristController.text) : null,
        // Female measurements
        bust: isFemale ? double.tryParse(bustController.text) : null,
        underBust: isFemale ? double.tryParse(underBustController.text) : null,
        naturalWaist: isFemale ? double.tryParse(naturalWaistController.text) : null,
        lowWaist: isFemale ? double.tryParse(lowWaistController.text) : null,
        hipCircumference: isFemale ? double.tryParse(hipCircumferenceController.text) : null,
        thigh: isFemale ? double.tryParse(thighController.text) : null,
        knee: isFemale ? double.tryParse(kneeController.text) : null,
        calf: isFemale ? double.tryParse(calfController.text) : null,
        ankle: isFemale ? double.tryParse(ankleController.text) : null,
        armLength: isFemale ? double.tryParse(armLengthController.text) : null,
        shoulderToWaist: isFemale ? double.tryParse(shoulderToWaistController.text) : null,
        waistToHip: isFemale ? double.tryParse(waistToHipController.text) : null,
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

  @override
  void onClose() {
    heightController.dispose();
    weightController.dispose();
    chestController.dispose();
    waistController.dispose();
    hipsController.dispose();
    inseamController.dispose();
    neckController.dispose();
    shouldersController.dispose();
    bicepsController.dispose();
    wristController.dispose();
    bustController.dispose();
    underBustController.dispose();
    naturalWaistController.dispose();
    lowWaistController.dispose();
    hipCircumferenceController.dispose();
    thighController.dispose();
    kneeController.dispose();
    calfController.dispose();
    ankleController.dispose();
    armLengthController.dispose();
    shoulderToWaistController.dispose();
    waistToHipController.dispose();
    super.onClose();
  }
}
