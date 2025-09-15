import 'package:lakshya/features/auth/view/screen/student_login_screen.dart';
import 'package:lakshya/features/auth/view/screen/student_register_screen.dart';
import 'package:lakshya/features/student/view/screens/aptitude_screen.dart';
import 'package:lakshya/features/student/view/screens/college_screen.dart';
import 'package:lakshya/features/student/view/screens/course_to_career_mapping_screen.dart';
import 'package:lakshya/features/student/view/screens/result_screen.dart';
import 'package:lakshya/features/student/view/screens/scholarship_screen.dart';
import 'package:lakshya/features/student/view/screens/student_home_screen.dart';
import 'package:lakshya/features/student/view/screens/timeline_screen.dart';

final routes = {
  '/student-login': (context) => const StudentLoginScreen(),
  '/student-register': (context) => const StudentRegisterScreen(),
  '/student-home': (context) => const StudentHomeScreen(),
  '/aptitude-quiz': (context) => const AptitudeScreen(),
  '/aptitude-result': (context) => const ResultScreen(),
  '/course-to-career-mapping': (context) => const CourseToCareerMappingScreen(),
  '/timeline': (context) => const TimelineScreen(),
  '/colleges': (context) => const CollegeScreen(),
  '/scholarship': (context) => const ScholarshipScreen(),
};
