import 'package:flutter/material.dart';
import 'package:catering_system/utils/app_constants.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedMethodId = 1;

  // Mock payment methods data
  List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 1,
      'name': 'BCA Transfer',
      'accountNumber': '1234 5678 9101',
      'accountName': 'Ahmad Reza',
      'icon': Icons.account_balance,
      'isDefault': true,
    },
    {
      'id': 2,
      'name': 'GCash',
      'accountNumber': '+62 812 3456 7890',
      'accountName': 'Ahmad Reza',
      'icon': Icons.wallet_membership,
      'isDefault': false,
    },
    {
      'id': 3,
      'name': 'Visa Card',
      'accountNumber': '**** **** **** 4242',
      'accountName': 'Ahmad Reza',
      'icon': Icons.credit_card,
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Metode Pembayaran'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Info box
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Pilih metode pembayaran default untuk transaksi lebih cepat',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Payment methods list
          Expanded(
            child: _paymentMethods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment_outlined,
                          size: 48,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Belum ada metode pembayaran',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: _paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = _paymentMethods[index];
                      return _buildMethodCard(method);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _showAddMethodDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Metode'),
      ),
    );
  }

  Widget _buildMethodCard(Map<String, dynamic> method) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: _selectedMethodId == method['id']
              ? AppColors.primary
              : AppColors.greyLight,
          width: _selectedMethodId == method['id'] ? 2 : 1,
        ),
        boxShadow: [
          if (_selectedMethodId == method['id'])
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          else
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            setState(() => _selectedMethodId = method['id']);
            _setDefaultMethod(method['id']);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(
                            method['icon'],
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'],
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method['accountNumber'],
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Radio<int>(
                      value: method['id'],
                      groupValue: _selectedMethodId,
                      onChanged: (value) {
                        setState(() => _selectedMethodId = value!);
                        _setDefaultMethod(value!);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                if (method['isDefault'])
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        '⭐ Default',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setDefaultMethod(int methodId) {
    setState(() {
      for (var method in _paymentMethods) {
        method['isDefault'] = method['id'] == methodId;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Metode pembayaran diatur sebagai default'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Tambah Metode Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMethodOption(
                'Transfer Bank',
                Icons.account_balance,
                () {
                  Navigator.pop(context);
                  _showAddBankDialog();
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildMethodOption(
                'E-Wallet',
                Icons.wallet_membership,
                () {
                  Navigator.pop(context);
                  _showAddEWalletDialog();
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildMethodOption(
                'Kartu Kredit',
                Icons.credit_card,
                () {
                  Navigator.pop(context);
                  _showAddCardDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBankDialog() {
    final nameController = TextEditingController();
    final accountController = TextEditingController();
    final accountNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Tambah Rekening Bank'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nama Bank (BCA, Mandiri, dll)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: accountController,
                decoration: InputDecoration(
                  hintText: 'Nomor Rekening',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: accountNameController,
                decoration: InputDecoration(
                  hintText: 'Atas Nama Rekening',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
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
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  accountController.text.isNotEmpty &&
                  accountNameController.text.isNotEmpty) {
                setState(() {
                  _paymentMethods.add({
                    'id': _paymentMethods.length + 1,
                    'name': nameController.text,
                    'accountNumber': accountController.text,
                    'accountName': accountNameController.text,
                    'icon': Icons.account_balance,
                    'isDefault': false,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Metode pembayaran berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAddEWalletDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Tambah E-Wallet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nama E-Wallet (GCash, Dana, dll)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Nomor HP / ID E-Wallet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
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
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                setState(() {
                  _paymentMethods.add({
                    'id': _paymentMethods.length + 1,
                    'name': nameController.text,
                    'accountNumber': phoneController.text,
                    'accountName': 'E-Wallet Account',
                    'icon': Icons.wallet_membership,
                    'isDefault': false,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Metode pembayaran berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final cardNumberController = TextEditingController();
    final cardNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Tambah Kartu Kredit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(
                  hintText: 'Nomor Kartu (4 digit terakhir)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: cardNameController,
                decoration: InputDecoration(
                  hintText: 'Nama di Kartu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
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
            onPressed: () {
              if (cardNumberController.text.isNotEmpty &&
                  cardNameController.text.isNotEmpty) {
                setState(() {
                  _paymentMethods.add({
                    'id': _paymentMethods.length + 1,
                    'name': 'Kartu Kredit',
                    'accountNumber': '**** **** **** ${cardNumberController.text}',
                    'accountName': cardNameController.text,
                    'icon': Icons.credit_card,
                    'isDefault': false,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Metode pembayaran berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
