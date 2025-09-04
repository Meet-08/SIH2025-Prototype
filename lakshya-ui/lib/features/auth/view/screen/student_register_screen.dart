import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/utils/show_snackbar.dart';
import 'package:lakshya/core/widgets/loader.dart';
import 'package:lakshya/features/auth/view/widgets/app_text_field.dart';
import 'package:lakshya/features/auth/viewmodel/auth_view_model.dart';

class StudentRegisterScreen extends ConsumerStatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  ConsumerState<StudentRegisterScreen> createState() =>
      _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends ConsumerState<StudentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _classController = TextEditingController();
  final _cityController = TextEditingController();

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref
        .read(authViewModelProvider.notifier)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          className: _classController.text.trim(),
          city: _cityController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          context.pushNamedAndRemoveUntil('/student-home', (_) => false);
        },
        error: (error, stackTrace) {
          showSnackbar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const Loader()
              : Container(
                  margin: const EdgeInsets.all(24),
                  height: double.infinity,
                  width: 350,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.primaryContainer,
                              child: Icon(
                                Icons.person_outlined,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 16.0),
                            Text(
                              'Create your profile',
                              style: context.textTheme.displayMedium?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16.0),
                            Text(
                              'Tell us a bit about yourself to get started',
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24.0),
                            AppTextField(
                              label: 'Full Name',
                              hintText: 'Enter your full name',
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12.0),
                            AppTextField(
                              label: 'Email',
                              hintText: 'Enter your email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }

                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12.0),
                            AppTextField(
                              label: 'Password',
                              hintText: 'Enter your password',
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12.0),
                            AppTextField(
                              label: 'Age',
                              hintText: 'Enter your age',
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your age';
                                }

                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid age';
                                }

                                if (int.parse(value) < 18 ||
                                    int.parse(value) > 25) {
                                  return 'Age must be between 18 and 25';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18.0),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Class',
                                hintText: 'Select your class',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: _classController.text.isNotEmpty
                                  ? _classController.text
                                  : null,
                              items: ['9th', '10th', '11th', '12th']
                                  .map(
                                    (className) => DropdownMenuItem(
                                      value: className,
                                      child: Text(className),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                _classController.text = value ?? '';
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your class';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12.0),
                            AppTextField(
                              label: 'City',
                              hintText: 'Enter your city',
                              controller: _cityController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your city';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.pushNamed('/student-login');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surfaceContainer,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Continue"),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
