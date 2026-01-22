import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/utils/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text('Selamat Datang', style: AppTypography.heading1)
                      .animate().fade(duration: 400.ms),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Silakan login untuk melanjutkan', style: AppTypography.bodyMedium)
                      .animate().fade(delay: 100.ms, duration: 400.ms),
                  
                  const SizedBox(height: AppSpacing.xl),

                  // Email Field
                  Text('Email', style: AppTypography.bodyLarge)
                      .animate().fade(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Masukkan email Anda',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Email tidak boleh kosong';
                      if (!value!.contains('@')) return 'Email tidak valid';
                      return null;
                    },
                    onChanged: (value) {},
                  ).animate().fade(delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Password Field
                  Text('Password', style: AppTypography.bodyLarge)
                      .animate().fade(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Password tidak boleh kosong' : null,
                    onChanged: (value) {},
                  ).animate().fade(delay: 500.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.md),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Lupa Password?', style: TextStyle(color: AppColors.primary)),
                    ),
                  ).animate().fade(delay: 600.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Implement login logic here
                          context.go('/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                      ),
                    ),
                  ).animate().fade(delay: 700.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Sign Up Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Belum punya akun? ',
                        style: AppTypography.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Daftar Sekarang',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push('/register'),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(delay: 800.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
