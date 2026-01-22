import 'package:flutter/material.dart';
import 'package:catering_system/utils/app_constants.dart';
import 'package:catering_system/utils/helpers.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _selectedFilter = 'semua';

  // Mock payment history data
  final List<Map<String, dynamic>> _paymentHistory = [
    {
      'id': 'PAY-001',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'amount': 250000,
      'method': 'Transfer Bank',
      'methodIcon': Icons.account_balance,
      'status': 'Berhasil',
      'statusColor': Colors.green,
      'orderId': 'ORD-001',
    },
    {
      'id': 'PAY-002',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'amount': 175000,
      'method': 'E-Wallet',
      'methodIcon': Icons.wallet_membership,
      'status': 'Berhasil',
      'statusColor': Colors.green,
      'orderId': 'ORD-002',
    },
    {
      'id': 'PAY-003',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'amount': 450000,
      'method': 'Kartu Kredit',
      'methodIcon': Icons.credit_card,
      'status': 'Berhasil',
      'statusColor': Colors.green,
      'orderId': 'ORD-003',
    },
    {
      'id': 'PAY-004',
      'date': DateTime.now().subtract(const Duration(days: 12)),
      'amount': 325000,
      'method': 'Bayar di Tempat',
      'methodIcon': Icons.payments,
      'status': 'Pending',
      'statusColor': Colors.orange,
      'orderId': 'ORD-004',
    },
    {
      'id': 'PAY-005',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'amount': 200000,
      'method': 'Transfer Bank',
      'methodIcon': Icons.account_balance,
      'status': 'Berhasil',
      'statusColor': Colors.green,
      'orderId': 'ORD-005',
    },
  ];

  List<Map<String, dynamic>> get _filteredPayments {
    if (_selectedFilter == 'semua') return _paymentHistory;
    if (_selectedFilter == 'berhasil') {
      return _paymentHistory.where((p) => p['status'] == 'Berhasil').toList();
    }
    if (_selectedFilter == 'pending') {
      return _paymentHistory.where((p) => p['status'] == 'Pending').toList();
    }
    return _paymentHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Riwayat Pembayaran'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', 'semua'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('Berhasil', 'berhasil'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('Pending', 'pending'),
                ],
              ),
            ),
          ),
          // Payment list
          Expanded(
            child: _filteredPayments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Belum ada riwayat pembayaran',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _filteredPayments.length,
                    itemBuilder: (context, index) {
                      final payment = _filteredPayments[index];
                      return _buildPaymentCard(payment);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      backgroundColor: AppColors.white,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: isSelected ? AppColors.primary : AppColors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.greyLight,
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _showPaymentDetail(payment),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment['id'],
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyHelper.formatCurrency(payment['amount'].toDouble()),
                            style: AppTypography.heading4.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: payment['statusColor'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        payment['status'],
                        style: AppTypography.bodySmall.copyWith(
                          color: payment['statusColor'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Details
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        payment['methodIcon'],
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment['method'],
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(payment['date']),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showPaymentDetail(Map<String, dynamic> payment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Detail Pembayaran',
              style: AppTypography.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDetailRow('ID Pembayaran', payment['id']),
            _buildDetailRow('ID Pesanan', payment['orderId']),
            _buildDetailRow('Metode', payment['method']),
            _buildDetailRow('Tanggal', _formatDate(payment['date'])),
            _buildDetailRow(
              'Jumlah',
              CurrencyHelper.formatCurrency(payment['amount'].toDouble()),
              isBold: true,
            ),
            _buildDetailRow(
              'Status',
              payment['status'],
              statusColor: payment['statusColor'],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: statusColor ?? (isBold ? AppColors.primary : AppColors.black),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
