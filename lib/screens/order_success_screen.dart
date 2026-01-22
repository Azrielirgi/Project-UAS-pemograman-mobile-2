import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/utils/app_constants.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Auto redirect after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/orders');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Animation
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 100,
                    color: AppColors.success,
                  ),
                ).animate().scale(duration: 600.ms),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Pesanan Berhasil!',
                  style: AppTypography.heading1.copyWith(color: AppColors.white),
                  textAlign: TextAlign.center,
                ).animate().fade(delay: 200.ms, duration: 600.ms),

                const SizedBox(height: AppSpacing.md),

                Text(
                  'Terima kasih telah memesan. Pesanan Anda akan segera disiapkan.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
                  textAlign: TextAlign.center,
                ).animate().fade(delay: 400.ms, duration: 600.ms),

                const SizedBox(height: AppSpacing.xl),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Estimasi Pengiriman',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '30 - 45 menit',
                        style: AppTypography.heading2.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 600.ms, duration: 600.ms),

                const SizedBox(height: AppSpacing.xl),

                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => context.go('/orders'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                    ),
                    child: const Text(
                      'Lihat Status Pesanan',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ).animate().fade(delay: 800.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
