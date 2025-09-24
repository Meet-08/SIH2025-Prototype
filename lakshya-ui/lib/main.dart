import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/constants/routes.dart';
import 'package:lakshya/core/provider/current_user_notifier.dart';
import 'package:lakshya/features/auth/view/screen/student_login_screen.dart';
import 'package:lakshya/features/auth/viewmodel/auth_view_model.dart';
import 'package:lakshya/features/student/view/screens/student_home_screen.dart';

import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).fetchCurrentUser();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lakshya - Career Guidance App',
      routes: routes,
      theme: AppTheme.lightTheme,
      home: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(currentUserProvider);
          return user != null
              ? const StudentHomeScreen()
              : const StudentLoginScreen();
        },
      ),
    );
  }
}
