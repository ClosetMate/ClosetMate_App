class UserMeasurements {
  final String gender;
  final double? height;
  final double? weight;
  
  // Male measurements
  final double? chest;
  final double? waist;
  final double? hips;
  final double? inseam;
  final double? neck;
  final double? shoulders;
  final double? biceps;
  final double? wrist;
  
  // Female measurements
  final double? bust;
  final double? underBust;
  final double? naturalWaist;
  final double? lowWaist;
  final double? hipCircumference;
  final double? thigh;
  final double? knee;
  final double? calf;
  final double? ankle;
  final double? armLength;
  final double? shoulderToWaist;
  final double? waistToHip;

  UserMeasurements({
    required this.gender,
    this.height,
    this.weight,
    // Male measurements
    this.chest,
    this.waist,
    this.hips,
    this.inseam,
    this.neck,
    this.shoulders,
    this.biceps,
    this.wrist,
    // Female measurements
    this.bust,
    this.underBust,
    this.naturalWaist,
    this.lowWaist,
    this.hipCircumference,
    this.thigh,
    this.knee,
    this.calf,
    this.ankle,
    this.armLength,
    this.shoulderToWaist,
    this.waistToHip,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'inseam': inseam,
      'neck': neck,
      'shoulders': shoulders,
      'biceps': biceps,
      'wrist': wrist,
      'bust': bust,
      'underBust': underBust,
      'naturalWaist': naturalWaist,
      'lowWaist': lowWaist,
      'hipCircumference': hipCircumference,
      'thigh': thigh,
      'knee': knee,
      'calf': calf,
      'ankle': ankle,
      'armLength': armLength,
      'shoulderToWaist': shoulderToWaist,
      'waistToHip': waistToHip,
    };
  }

  factory UserMeasurements.fromJson(Map<String, dynamic> json) {
    return UserMeasurements(
      gender: json['gender'] ?? '',
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      chest: json['chest']?.toDouble(),
      waist: json['waist']?.toDouble(),
      hips: json['hips']?.toDouble(),
      inseam: json['inseam']?.toDouble(),
      neck: json['neck']?.toDouble(),
      shoulders: json['shoulders']?.toDouble(),
      biceps: json['biceps']?.toDouble(),
      wrist: json['wrist']?.toDouble(),
      bust: json['bust']?.toDouble(),
      underBust: json['underBust']?.toDouble(),
      naturalWaist: json['naturalWaist']?.toDouble(),
      lowWaist: json['lowWaist']?.toDouble(),
      hipCircumference: json['hipCircumference']?.toDouble(),
      thigh: json['thigh']?.toDouble(),
      knee: json['knee']?.toDouble(),
      calf: json['calf']?.toDouble(),
      ankle: json['ankle']?.toDouble(),
      armLength: json['armLength']?.toDouble(),
      shoulderToWaist: json['shoulderToWaist']?.toDouble(),
      waistToHip: json['waistToHip']?.toDouble(),
    );
  }
}
