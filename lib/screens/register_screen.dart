import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/utils/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Daftar Akun'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                _buildFormField(
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  icon: Icons.person,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null,
                  onChanged: (value) {},
                  delay: 0,
                ),

                const SizedBox(height: AppSpacing.md),

                // Email
                _buildFormField(
                  label: 'Email',
                  hintText: 'Masukkan email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email tidak boleh kosong';
                    if (!value!.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                  onChanged: (value) {},
                  delay: 100,
                ),

                const SizedBox(height: AppSpacing.md),

                // Phone Number
                _buildFormField(
                  label: 'Nomor Telepon',
                  hintText: 'Masukkan nomor telepon',
                  icon: Icons.phone,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Nomor telepon tidak boleh kosong' : null,
                  onChanged: (value) {},
                  delay: 200,
                ),

                const SizedBox(height: AppSpacing.md),

                // Address
                _buildFormField(
                  label: 'Alamat',
                  hintText: 'Masukkan alamat lengkap',
                  icon: Icons.location_on,
                  maxLines: 2,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Alamat tidak boleh kosong' : null,
                  onChanged: (value) {},
                  delay: 300,
                ),

                const SizedBox(height: AppSpacing.md),

                // City
                _buildFormField(
                  label: 'Kota',
                  hintText: 'Masukkan kota',
                  icon: Icons.domain,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Kota tidak boleh kosong' : null,
                  onChanged: (value) {},
                  delay: 400,
                ),

                const SizedBox(height: AppSpacing.md),

                // Password
                Text('Password', style: AppTypography.bodyLarge)
                    .animate().fade(delay: const Duration(milliseconds: 500), duration: 400.ms),
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
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Password tidak boleh kosong';
                    if (value!.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                  onChanged: (value) => _password = value,
                ).animate().fade(delay: const Duration(milliseconds: 500), duration: 400.ms),

                const SizedBox(height: AppSpacing.md),

                // Confirm Password
                Text('Konfirmasi Password', style: AppTypography.bodyLarge)
                    .animate().fade(delay: const Duration(milliseconds: 600), duration: 400.ms),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Konfirmasi password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Konfirmasi password tidak boleh kosong';
                    if (value != _password) return 'Password tidak cocok';
                    return null;
                  },
                  onChanged: (value) {},
                ).animate().fade(delay: const Duration(milliseconds: 600), duration: 400.ms),

                const SizedBox(height: AppSpacing.lg),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Implement registration logic here
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(fontSize: 16, color: AppColors.white),
                    ),
                  ),
                ).animate().fade(delay: const Duration(milliseconds: 700), duration: 400.ms),

                const SizedBox(height: AppSpacing.lg),

                // Login Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: AppTypography.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(delay: const Duration(milliseconds: 800), duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    required Function(String) onChanged,
    int maxLines = 1,
    int delay = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodyLarge),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          ),
          validator: validator,
          onChanged: onChanged,
        ).animate().fade(delay: Duration(milliseconds: delay), duration: 400.ms),
      ],
    );
  }
}
