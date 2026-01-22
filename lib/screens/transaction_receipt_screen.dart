import 'package:flutter/material.dart';
import 'package:catering_system/models/transaction_receipt.dart';
import 'package:catering_system/utils/app_constants.dart';
import 'package:catering_system/utils/helpers.dart';
import 'package:intl/intl.dart';

class TransactionReceiptScreen extends StatelessWidget {
  final TransactionReceipt receipt;

  const TransactionReceiptScreen({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Bukti Transaksi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Receipt Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        'Pembayaran Berhasil',
                        style: AppTypography.heading2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Amount
                      Text(
                        CurrencyHelper.formatCurrency(receipt.amount),
                        style: AppTypography.heading1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      Divider(
                        color: AppColors.greyLight,
                        thickness: 1,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Transaction Details
                      _buildDetailRow(
                        'ID Transaksi',
                        receipt.transactionId,
                        isBold: true,
                      ),
                      _buildDetailRow(
                        'ID Pesanan',
                        receipt.orderId,
                      ),
                      _buildDetailRow(
                        'Tanggal',
                        _formatDate(receipt.transactionDate),
                      ),
                      _buildDetailRow(
                        'Metode Pembayaran',
                        receipt.paymentMethod,
                      ),
                      _buildDetailRow(
                        'Status',
                        receipt.status,
                        statusColor: Colors.green,
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      Divider(
                        color: AppColors.greyLight,
                        thickness: 1,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Items List
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail Pesanan',
                          style: AppTypography.heading4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      ...receipt.items.map(
                        (item) => _buildItemRow(
                          item['name'],
                          item['quantity'],
                          item['price'],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      Divider(
                        color: AppColors.greyLight,
                        thickness: 1,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Breakdown
                      _buildBreakdownRow(
                        'Subtotal',
                        CurrencyHelper.formatCurrency(
                          receipt.breakdown['subtotal'].toDouble(),
                        ),
                      ),
                      if (receipt.breakdown['tax'] > 0)
                        _buildBreakdownRow(
                          'Pajak (10%)',
                          CurrencyHelper.formatCurrency(
                            receipt.breakdown['tax'].toDouble(),
                          ),
                        ),
                      if (receipt.breakdown['deliveryFee'] > 0)
                        _buildBreakdownRow(
                          'Biaya Pengiriman',
                          CurrencyHelper.formatCurrency(
                            receipt.breakdown['deliveryFee'].toDouble(),
                          ),
                        ),
                      if (receipt.breakdown['discount'] > 0)
                        _buildBreakdownRow(
                          'Diskon',
                          '-' +
                              CurrencyHelper.formatCurrency(
                                receipt.breakdown['discount'].toDouble(),
                              ),
                          isDiscount: true,
                        ),
                      if (receipt.breakdown['tip'] > 0)
                        _buildBreakdownRow(
                          'Tip',
                          CurrencyHelper.formatCurrency(
                            receipt.breakdown['tip'].toDouble(),
                          ),
                        ),

                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              CurrencyHelper.formatCurrency(receipt.amount),
                              style: AppTypography.heading4.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      Divider(
                        color: AppColors.greyLight,
                        thickness: 1,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Delivery Info
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Informasi Pengiriman',
                          style: AppTypography.heading4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildDetailRow(
                        'Nama',
                        receipt.customerName,
                      ),
                      _buildDetailRow(
                        'Telepon',
                        receipt.customerPhone,
                      ),
                      _buildDetailRow(
                        'Alamat',
                        receipt.deliveryAddress,
                      ),
                      _buildDetailRow(
                        'Tanggal Pengiriman',
                        _formatDate(receipt.deliveryDate),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Action Buttons
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              OutlinedButton(
                onPressed: () {
                  // TODO: Implement share receipt
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur share akan segera tersedia'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Bagikan Bukti',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'x$quantity',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyHelper.formatCurrency(price),
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isDiscount ? Colors.green : AppColors.grey,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: isDiscount ? Colors.green : AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy HH:mm', 'id_ID').format(date);
  }
}
