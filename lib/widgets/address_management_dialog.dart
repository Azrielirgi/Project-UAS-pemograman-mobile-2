import 'package:flutter/material.dart';
import 'package:catering_system/utils/app_constants.dart';

class AddressManagementDialog extends StatefulWidget {
  final String? initialAddress;
  final Function(String) onSave;

  const AddressManagementDialog({
    Key? key,
    this.initialAddress,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddressManagementDialog> createState() => _AddressManagementDialogState();
}

class _AddressManagementDialogState extends State<AddressManagementDialog> {
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _zipCodeController;
  String _addressType = 'Home'; // Home, Work, Other

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress ?? '');
    _cityController = TextEditingController();
    _zipCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _zipCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua field'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final fullAddress = '''${_addressController.text}
$_cityController - ${_zipCodeController.text}''';

    widget.onSave(fullAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Ubah Alamat', style: AppTypography.heading3),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Type
            Text('Tipe Alamat', style: AppTypography.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(label: Text('Rumah'), value: 'Home'),
                ButtonSegment<String>(label: Text('Kantor'), value: 'Work'),
                ButtonSegment<String>(label: Text('Lainnya'), value: 'Other'),
              ],
              selected: <String>{_addressType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _addressType = newSelection.first);
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Address
            Text('Alamat Lengkap', style: AppTypography.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Jalan, nomor rumah, dsb',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.md),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),

            // City
            Text('Kota/Kabupaten', style: AppTypography.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Contoh: Jakarta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.md),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Zip Code
            Text('Kode Pos', style: AppTypography.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _zipCodeController,
              decoration: InputDecoration(
                hintText: 'Contoh: 12345',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.md),
              ),
              keyboardType: TextInputType.number,
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
          onPressed: _saveAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Simpan', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
