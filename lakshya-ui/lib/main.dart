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
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Fetch current user when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final authState = ref.watch(authViewModelProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lakshya - Career Guidance App',
      routes: routes,
      theme: AppTheme.lightTheme,
      home: authState?.isLoading == true
          ? const Scaffold(body: Center(child: Loader()))
          : currentUser != null
          ? const StudentHomeScreen()
          : const StudentLoginScreen(),
    );
  }
}
