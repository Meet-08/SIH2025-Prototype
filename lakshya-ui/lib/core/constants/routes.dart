import 'package:lakshya/features/auth/view/screen/student_login_screen.dart';
import 'package:lakshya/features/auth/view/screen/student_register_screen.dart';
import 'package:lakshya/features/features.dart';
import 'package:lakshya/features/parent/view/screens/parent_home_screen.dart';
import 'package:lakshya/features/student/view/screens/aptitude_screen.dart';
import 'package:lakshya/features/student/view/screens/student_layout_screen.dart';

final routes = {
  '/onboarding': (context) => const OnboardingScreen(),
  '/parent-home': (context) => const ParentHomeScreen(),
  '/student-login': (context) => const StudentLoginScreen(),
  '/student-register': (context) => const StudentRegisterScreen(),
  '/student-home': (context) => const StudentLayoutScreen(),
  '/aptitude-quiz': (context) => const AptitudeScreen(),
};
