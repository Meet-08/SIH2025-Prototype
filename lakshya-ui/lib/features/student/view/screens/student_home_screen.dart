import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/provider/current_user_notifier.dart';
import 'package:lakshya/features/student/view/widgets/feature_card.dart';
import 'package:lakshya/features/student/view/widgets/home_screen_card.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => print('Profile Tapped'),
              child: CircleAvatar(
                backgroundImage: currentUser?.profilePictureUrl != null
                    ? NetworkImage(currentUser!.profilePictureUrl!)
                    : const AssetImage(
                            'assets/images/Default_Profile_Picture.png',
                          )
                          as ImageProvider,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                          ref
                              .read(currentUserNotifierProvider.notifier)
                              .logout();
                          if (mounted) {
                            context.pushNamedAndRemoveUntil(
                              '/student-login',
                              (route) => false,
                            );
                          }
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Welcome, ${currentUser!.name}',
                  style: context.textTheme.displaySmall,
                ),
              ),

              const SizedBox(height: 20),
              const HomeScreenCard(),

              const SizedBox(height: 20),
              FeatureCard(
                title: "Aptitude Quiz",
                description:
                    "Discover your strengths and interests. Take or retake the quiz anytime.",
                icon: Icons.menu_book_rounded,
                onTap: () => context.pushNamed("/aptitude-quiz"),
              ),
              FeatureCard(
                title: "Explore your Career Path",
                description:
                    "Find the best career options tailored to your profile.",
                icon: CupertinoIcons.compass,
                onTap: () {
                  //TODO: Navigate to Explore your Career Path Screen
                },
              ),
              FeatureCard(
                title: "Colleges",
                description: "Explore top colleges and universities.",
                icon: Icons.school,
                onTap: () => print('Colleges Tapped'),
              ),

              FeatureCard(
                title: "Scholarships",
                description: "Find scholarships that suit your profile.",
                icon: Icons.card_giftcard,
                onTap: () => print('Scholarships Tapped'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
