import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/providers/auth_provider.dart';
import 'package:catering_system/utils/app_constants.dart';
import 'package:catering_system/widgets/address_management_dialog.dart';
import 'package:catering_system/widgets/notification_settings_dialog.dart';
import 'package:catering_system/widgets/password_change_dialog.dart';
import 'package:catering_system/screens/payment_history_screen.dart';
import 'package:catering_system/screens/payment_methods_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profil Saya'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryGradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Jelajahi Aplikasi',
                          style: AppTypography.heading2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Login untuk akses fitur lengkap',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quick Action Menu
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu Cepat',
                          style: AppTypography.heading4,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Browse Menu
                        _QuickActionTile(
                          icon: Icons.restaurant_menu,
                          title: 'Jelajahi Menu',
                          subtitle: 'Lihat semua menu makanan kami',
                          onTap: () => context.go('/home'),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // About
                        _QuickActionTile(
                          icon: Icons.info_outline,
                          title: 'Tentang Aplikasi',
                          subtitle: 'Informasi dan kebijakan aplikasi',
                          onTap: () => context.push('/about'),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Help & Support
                        _QuickActionTile(
                          icon: Icons.help_outline,
                          title: 'Bantuan & Support',
                          subtitle: 'Hubungi tim support kami',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Hubungi support@catering.id'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Favorites
                        _QuickActionTile(
                          icon: Icons.favorite_outline,
                          title: 'Menu Favorit',
                          subtitle: 'Lihat menu pilihan Anda',
                          onTap: () => context.go('/favorites'),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text(
                              'Login / Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header dengan Dark Theme
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1F1F1F),
                        Color(0xFF2A2A2A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B35).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: user.profileImageUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  user.profileImageUrl,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white.withOpacity(0.8),
                              ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        user.fullName,
                        style: AppTypography.heading2.copyWith(
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        user.email,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 400.ms),

                // Stats Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      _StatCard(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Pesanan',
                        value: '12',
                      ).animate().fade(delay: 100.ms, duration: 400.ms),
                      const SizedBox(width: AppSpacing.md),
                      _StatCard(
                        icon: Icons.favorite_outline,
                        label: 'Favorit',
                        value: '8',
                      ).animate().fade(delay: 200.ms, duration: 400.ms),
                      const SizedBox(width: AppSpacing.md),
                      _StatCard(
                        icon: Icons.star_outline,
                        label: 'Rating',
                        value: '4.8',
                      ).animate().fade(delay: 300.ms, duration: 400.ms),
                    ],
                  ),
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Pribadi',
                        style: AppTypography.heading4,
                      ).animate().fade(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: AppSpacing.md),

                      _InfoCard(
                        icon: Icons.phone_outlined,
                        label: 'Nomor Telepon',
                        value: user.phoneNumber.isEmpty
                            ? 'Tidak diatur'
                            : user.phoneNumber,
                      ).animate().fade(delay: 300.ms, duration: 400.ms),

                      _InfoCard(
                        icon: Icons.location_on_outlined,
                        label: 'Alamat',
                        value: user.address.isEmpty
                            ? 'Tidak diatur'
                            : user.address,
                      ).animate().fade(delay: 400.ms, duration: 400.ms),

                      _InfoCard(
                        icon: Icons.domain_outlined,
                        label: 'Kota',
                        value: user.city.isEmpty ? 'Tidak diatur' : user.city,
                      ).animate().fade(delay: 500.ms, duration: 400.ms),

                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        'Penawaran Spesial',
                        style: AppTypography.heading4,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Voucher Section
                      _PromoCard(
                        icon: Icons.card_giftcard,
                        title: 'Voucher & Promo',
                        subtitle: 'Anda punya 3 voucher aktif',
                        backgroundColor: const Color(0xFFFF6B35),
                        onTap: () {},
                      ).animate().fade(delay: 550.ms, duration: 400.ms),

                      // Referral Section
                      _PromoCard(
                        icon: Icons.share,
                        title: 'Program Referral',
                        subtitle: 'Ajak teman, dapatkan bonus',
                        backgroundColor: const Color(0xFF004E89),
                        onTap: () {},
                      ).animate().fade(delay: 575.ms, duration: 400.ms),

                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        'Pengaturan',
                        style: AppTypography.heading4,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Preferensi Diet
                      _SettingsTile(
                        icon: Icons.favorite_outline,
                        title: 'Preferensi Diet',
                        subtitle: 'Atur alergi & preferensi makanan',
                        onTap: () {},
                      ).animate().fade(delay: 600.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profil',
                        subtitle: 'Ubah informasi pribadi Anda',
                        onTap: () => context.push('/edit-profile'),
                      ).animate().fade(delay: 625.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.location_on_outlined,
                        title: 'Alamat Pengiriman',
                        subtitle: 'Kelola alamat pengiriman',
                        onTap: () {
                          final user = context.read<AuthProvider>().currentUser;
                          showDialog(
                            context: context,
                            builder: (context) => AddressManagementDialog(
                              initialAddress: user?.address,
                              onSave: (newAddress) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Alamat berhasil diperbarui'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ).animate().fade(delay: 650.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.credit_card_outlined,
                        title: 'Metode Pembayaran',
                        subtitle: 'Kelola metode pembayaran',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentMethodsScreen(),
                            ),
                          );
                        },
                      ).animate().fade(delay: 675.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.receipt_long_outlined,
                        title: 'Riwayat Pembayaran',
                        subtitle: 'Lihat riwayat transaksi Anda',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentHistoryScreen(),
                            ),
                          );
                        },
                      ).animate().fade(delay: 687.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.security_outlined,
                        title: 'Keamanan Akun',
                        subtitle: 'Ubah password dan verifikasi',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => PasswordChangeDialog(
                              onSave: (oldPassword, newPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password berhasil diubah'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ).animate().fade(delay: 712.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Bantuan & Support',
                        subtitle: 'Hubungi tim support kami',
                        onTap: () {},
                      ).animate().fade(delay: 737.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifikasi',
                        subtitle: 'Atur preferensi notifikasi',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => NotificationSettingsDialog(
                              onSave: (settings) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pengaturan notifikasi berhasil disimpan'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ).animate().fade(delay: 762.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privasi & Kebijakan',
                        subtitle: 'Baca syarat dan kebijakan',
                        onTap: () {},
                      ).animate().fade(delay: 787.ms, duration: 400.ms),

                      _SettingsTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Keluar dari akun Anda',
                        isLogout: true,
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Apakah Anda yakin ingin logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await authProvider.signOut();
                                    if (mounted) {
                                      Navigator.pop(context);
                                      context.go('/login');
                                    }
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(color: Color(0xFFE74C3C)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).animate().fade(delay: 812.ms, duration: 400.ms),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF6B35),
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F1F1F),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLogout;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (hover) => setState(() => _isHovered = hover),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFFFF6B35).withOpacity(0.2)
                    : const Color(0xFFEEEEEE),
                width: 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: widget.isLogout
                        ? const Color(0xFFE74C3C).withOpacity(0.1)
                        : const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isLogout
                        ? const Color(0xFFE74C3C)
                        : const Color(0xFFFF6B35),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.isLogout
                              ? const Color(0xFFE74C3C)
                              : const Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFFCCCCCC),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClipCircle extends StatelessWidget {
  final Widget child;

  const ClipCircle({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipOval(child: child);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: const Color(0xFFEEEEEE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF6B35),
                size: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.heading4.copyWith(
                color: const Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PromoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<_PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<_PromoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (hover) => setState(() => _isHovered = hover),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.backgroundColor,
                  widget.backgroundColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.backgroundColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: widget.backgroundColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


