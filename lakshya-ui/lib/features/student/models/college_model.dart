class DegreeInfo {
  final String degreeName;
  final int? cutoff;
  final String? cutoffStream;

  DegreeInfo({required this.degreeName, this.cutoff, this.cutoffStream});

  factory DegreeInfo.fromJson(Map<String, dynamic> json) {
    return DegreeInfo(
      degreeName: json['degree_name'] as String,
      cutoff: json['cutoff'] is int ? json['cutoff'] as int : null,
      cutoffStream: json['cutoff_stream'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree_name': degreeName,
      'cutoff': cutoff,
      'cutoff_stream': cutoffStream,
    };
  }

  @override
  String toString() =>
      'DegreeInfo(degreeName: $degreeName, cutoff: $cutoff, cutoffStream: $cutoffStream)';
}

class CollegeModel {
  final int collegeId;
  final String collegeName;
  final String location;
  final String district;
  final String state;
  final List<String> facilities;
  final List<DegreeInfo> degrees;

  CollegeModel({
    required this.collegeId,
    required this.collegeName,
    required this.location,
    required this.district,
    required this.state,
    required this.facilities,
    required this.degrees,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json) {
    return CollegeModel(
      collegeId: json['college_id'] as int,
      collegeName: json['college_name'] as String,
      location: json['location'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      facilities:
          (json['facilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[],
      degrees:
          (json['degrees'] as List<dynamic>?)
              ?.map((e) => DegreeInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <DegreeInfo>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'college_id': collegeId,
      'college_name': collegeName,
      'location': location,
      'district': district,
      'state': state,
      'facilities': facilities,
      'degrees': degrees.map((d) => d.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'CollegeModel(collegeId: $collegeId, collegeName: $collegeName, location: $location, district: $district, state: $state, facilities: $facilities, degrees: $degrees)';
}
