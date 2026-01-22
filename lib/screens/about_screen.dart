import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/utils/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Tentang Kami'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Catering System',
                    style: AppTypography.heading2.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Layanan Pemesan Catering Terbaik',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tentang Kami', style: AppTypography.heading3)
                      .animate().fade(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Catering System adalah platform inovatif yang memudahkan Anda untuk memesan catering berkualitas tinggi dengan menu beragam dan harga terjangkau. Kami berkomitmen untuk memberikan layanan terbaik dengan pengiriman cepat dan tepat waktu.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.justify,
                  ).animate().fade(delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Visi Kami', style: AppTypography.heading3)
                      .animate().fade(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Menjadi platform catering terdepan yang menghubungkan pelanggan dengan penyedia catering terbaik di kota.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.justify,
                  ).animate().fade(delay: 500.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Misi Kami', style: AppTypography.heading3)
                      .animate().fade(delay: 600.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MissionItem('Menyediakan menu catering berkualitas tinggi'),
                      _MissionItem('Memberikan pengalaman pemesanan yang mudah dan cepat'),
                      _MissionItem('Menjamin pengiriman tepat waktu dan aman'),
                      _MissionItem('Memberikan harga yang kompetitif dan terjangkau'),
                      _MissionItem('Meningkatkan kepuasan pelanggan'),
                    ],
                  ).animate().fade(delay: 700.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Kontak Kami', style: AppTypography.heading3)
                      .animate().fade(delay: 800.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.md),

                  _ContactItem(
                    icon: Icons.email,
                    label: 'Email',
                    value: 'info@cateringsystem.com',
                  ).animate().fade(delay: 900.ms, duration: 400.ms),

                  _ContactItem(
                    icon: Icons.phone,
                    label: 'Telepon',
                    value: '+62 812 3456 7890',
                  ).animate().fade(delay: 1000.ms, duration: 400.ms),

                  _ContactItem(
                    icon: Icons.location_on,
                    label: 'Alamat',
                    value: 'Jl. Catering No. 123, Jakarta',
                  ).animate().fade(delay: 1100.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Sosial Media', style: AppTypography.heading3)
                      .animate().fade(delay: 1200.ms, duration: 400.ms),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SocialMediaButton(Icons.facebook, 'Facebook'),
                      _SocialMediaButton(Icons.share_outlined, 'Instagram'),
                      _SocialMediaButton(Icons.business, 'Twitter'),
                    ],
                  ).animate().fade(delay: 1300.ms, duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  Center(
                    child: Text(
                      'Versi 1.0.0\n© 2025 Catering System. All rights reserved.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionItem extends StatelessWidget {
  final String text;

  const _MissionItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(value, style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SocialMediaButton(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}
