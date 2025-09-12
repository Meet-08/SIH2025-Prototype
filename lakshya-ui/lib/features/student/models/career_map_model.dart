class CareerMapModel {
  final String careerField;
  final After10thData after10th;
  final After12thData after12th;
  final Map<String, CourseData> courses;

  CareerMapModel({
    required this.careerField,
    required this.after10th,
    required this.after12th,
    required this.courses,
  });

  factory CareerMapModel.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw ArgumentError('CareerMapModel.fromMap: data is null');
    }

    final coursesMap = <String, CourseData>{};
    final coursesData = (data['courses'] is Map)
        ? Map<String, dynamic>.from(data['courses'])
        : <String, dynamic>{};

    coursesData.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        coursesMap[key] = CourseData.fromMap(value);
      }
    });

    return CareerMapModel(
      careerField: (data['careerField'] ?? '') as String,
      after10th: After10thData.fromMap(
        data['after10th'] as Map<String, dynamic>? ?? {},
      ),
      after12th: After12thData.fromMap(
        data['after12th'] as Map<String, dynamic>? ?? {},
      ),
      courses: coursesMap,
    );
  }

  Map<String, dynamic> toMap() {
    final coursesMap = <String, dynamic>{};
    courses.forEach((key, value) {
      coursesMap[key] = value.toMap();
    });

    return {
      'careerField': careerField,
      'after10th': after10th.toMap(),
      'after12th': after12th.toMap(),
      'courses': coursesMap,
    };
  }

  @override
  String toString() {
    return 'CareerMapModel(careerField: $careerField, after10th: ${after10th.toMap()}, after12th: ${after12th.toMap()}, courses: ${courses.length} courses)';
  }
}

class After10thData {
  final String recommendedStream;
  final List<String> subjects;

  After10thData({required this.recommendedStream, required this.subjects});

  factory After10thData.fromMap(Map<String, dynamic> data) {
    return After10thData(
      recommendedStream: data['recommendedStream'] as String? ?? '',
      subjects: List<String>.from(data['subjects'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'recommendedStream': recommendedStream, 'subjects': subjects};
  }
}

class After12thData {
  final List<String> entranceExams;

  After12thData({required this.entranceExams});

  factory After12thData.fromMap(Map<String, dynamic> data) {
    return After12thData(
      entranceExams: List<String>.from(data['entranceExams'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'entranceExams': entranceExams};
  }
}

class CourseData {
  final String name;
  final String duration;
  final List<String> specializations;
  final List<String> keySubjects;
  final CareerPathsData careerPaths;

  CourseData({
    required this.name,
    required this.duration,
    required this.specializations,
    required this.keySubjects,
    required this.careerPaths,
  });

  factory CourseData.fromMap(Map<String, dynamic> data) {
    return CourseData(
      name: data['name'] as String? ?? '',
      duration: data['duration'] as String? ?? '',
      specializations: List<String>.from(data['specializations'] ?? []),
      keySubjects: List<String>.from(data['keySubjects'] ?? []),
      careerPaths: CareerPathsData.fromMap(
        data['careerPaths'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
      'specializations': specializations,
      'keySubjects': keySubjects,
      'careerPaths': careerPaths.toMap(),
    };
  }

  @override
  String toString() {
    return 'CourseData(name: $name, duration: $duration, specializations: $specializations, keySubjects: $keySubjects, careerPaths: ${careerPaths.toMap()})';
  }
}

class CareerPathsData {
  final List<String> industries;
  final List<String> jobRoles;
  final List<String> governmentExams;
  final List<String> entrepreneurialOptions;
  final List<String> higherEducation;

  CareerPathsData({
    required this.industries,
    required this.jobRoles,
    required this.governmentExams,
    required this.entrepreneurialOptions,
    required this.higherEducation,
  });

  factory CareerPathsData.fromMap(Map<String, dynamic> data) {
    return CareerPathsData(
      industries: List<String>.from(data['industries'] ?? []),
      jobRoles: List<String>.from(data['jobRoles'] ?? []),
      governmentExams: List<String>.from(data['governmentExams'] ?? []),
      entrepreneurialOptions: List<String>.from(
        data['entrepreneurialOptions'] ?? [],
      ),
      higherEducation: List<String>.from(data['higherEducation'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'industries': industries,
      'jobRoles': jobRoles,
      'governmentExams': governmentExams,
      'entrepreneurialOptions': entrepreneurialOptions,
      'higherEducation': higherEducation,
    };
  }
}
