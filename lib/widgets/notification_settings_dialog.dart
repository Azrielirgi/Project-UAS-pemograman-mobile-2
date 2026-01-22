import 'package:flutter/material.dart';
import 'package:catering_system/utils/app_constants.dart';

class NotificationSettingsDialog extends StatefulWidget {
  final Function(Map<String, bool>) onSave;

  const NotificationSettingsDialog({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState extends State<NotificationSettingsDialog> {
  bool _orderUpdates = true;
  bool _promoNotifications = true;
  bool _newMenu = true;
  bool _reviews = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  void _saveSettings() {
    widget.onSave({
      'orderUpdates': _orderUpdates,
      'promoNotifications': _promoNotifications,
      'newMenu': _newMenu,
      'reviews': _reviews,
      'pushNotifications': _pushNotifications,
      'emailNotifications': _emailNotifications,
      'smsNotifications': _smsNotifications,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Pengaturan Notifikasi', style: AppTypography.heading3),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifikasi Pesanan',
              style: AppTypography.heading4,
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'Update Pesanan',
              subtitle: 'Notifikasi tentang status pesanan Anda',
              value: _orderUpdates,
              onChanged: (value) => setState(() => _orderUpdates = value),
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'Review & Rating',
              subtitle: 'Minta untuk memberikan ulasan pesanan',
              value: _reviews,
              onChanged: (value) => setState(() => _reviews = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Promosi & Penawaran',
              style: AppTypography.heading4,
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'Promo & Diskon',
              subtitle: 'Dapatkan notifikasi tentang penawaran spesial',
              value: _promoNotifications,
              onChanged: (value) => setState(() => _promoNotifications = value),
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'Menu Baru',
              subtitle: 'Notifikasi ketika ada menu baru',
              value: _newMenu,
              onChanged: (value) => setState(() => _newMenu = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Saluran Notifikasi',
              style: AppTypography.heading4,
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'Push Notification',
              subtitle: 'Notifikasi langsung di aplikasi',
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'Email',
              subtitle: 'Notifikasi melalui email',
              value: _emailNotifications,
              onChanged: (value) => setState(() => _emailNotifications = value),
            ),
            const SizedBox(height: AppSpacing.md),
            _NotificationToggle(
              title: 'SMS',
              subtitle: 'Notifikasi melalui pesan SMS',
              value: _smsNotifications,
              onChanged: (value) => setState(() => _smsNotifications = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Simpan', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyLarge),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey,
                  )),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
