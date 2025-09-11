import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/theme/app_colors.dart';

/// Custom reusable text field widget with icon and modern design
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 16,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color:
            backgroundColor ?? AppColors.surfaceVariant.withValues(alpha: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style:
                    textStyle ??
                    const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  hintText: hintText,
                  hintStyle:
                      hintStyle ??
                      TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      contentPadding ??
                      const EdgeInsets.symmetric(vertical: 16),
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Specialized email text field with built-in validation
class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? backgroundColor;
  final Color? iconColor;

  const EmailTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Enter your email address',
      icon: LucideIcons.mail,
      keyboardType: TextInputType.emailAddress,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}

/// Specialized password text field with built-in validation
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? backgroundColor;
  final Color? iconColor;
  final int? minLength;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.backgroundColor,
    this.iconColor,
    this.minLength,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Enter your password',
      icon: LucideIcons.lock,
      obscureText: true,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (minLength != null && value.length < minLength!) {
          return 'Password must be at least $minLength characters';
        }
        return null;
      },
    );
  }
}

/// Specialized phone text field with built-in validation
class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? backgroundColor;
  final Color? iconColor;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Enter your phone number',
      icon: LucideIcons.phone,
      keyboardType: TextInputType.phone,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Please enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }
}

/// Specialized name text field with built-in validation
class NameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? customIcon;

  const NameTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.backgroundColor,
    this.iconColor,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Enter your name',
      icon: customIcon ?? LucideIcons.user,
      keyboardType: TextInputType.name,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }
}
