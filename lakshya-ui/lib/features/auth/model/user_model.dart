class UserModel {
  final int studentId;
  final String name;
  final String email;
  final int age;
  final String className;
  final String city;

  UserModel({
    required this.studentId,
    required this.name,
    required this.email,
    required this.age,
    required this.className,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      studentId: json['student_id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      className: json['class_name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'name': name,
      'email': email,
      'age': age,
      'class_name': className,
      'city': city,
    };
  }

  @override
  String toString() {
    return 'UserModel(studentId: $studentId, name: $name, email: $email, age: $age, className: $className, city: $city)';
  }
}
