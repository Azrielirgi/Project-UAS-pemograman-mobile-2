import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/models/order.dart';
import 'package:catering_system/providers/order_provider.dart';
import 'package:catering_system/utils/helpers.dart';
import 'package:catering_system/utils/app_constants.dart';
import 'package:catering_system/widgets/review_dialog.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getOrderById(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Detail Pesanan'),
        centerTitle: true,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final order = orderProvider.currentOrder;

          if (orderProvider.isLoading || order == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Pesanan',
                        style: AppTypography.heading2.copyWith(color: AppColors.white),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _OrderStatusTimeline(status: order.status),
                    ],
                  ),
                ).animate().fade(duration: 400.ms),

                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Informasi Pesanan', style: AppTypography.heading3),
                              const SizedBox(height: AppSpacing.md),
                              _InfoRow('ID Pesanan', order.id.substring(0, 12)),
                              _InfoRow('Tanggal', DateTimeHelper.formatDate(order.orderDate)),
                              _InfoRow('Pengiriman', DateTimeHelper.formatDate(order.deliveryDate)),
                              _InfoRow('Alamat', order.deliveryAddress),
                              _InfoRow('Telepon', order.phoneNumber),
                            ],
                          ),
                        ),
                      ).animate().fade(delay: 200.ms, duration: 400.ms),

                      const SizedBox(height: AppSpacing.md),

                      // Items
                      Text('Items Pesanan', style: AppTypography.heading3),
                      const SizedBox(height: AppSpacing.md),
                      ...order.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cartItem = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.menuItem.name,
                                            style: AppTypography.bodyLarge.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(
                                            'Qty: ${cartItem.quantity}x',
                                            style: AppTypography.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      CurrencyHelper.formatCurrency(cartItem.subtotal),
                                      style: AppTypography.bodyLarge.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (cartItem.notes.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: AppSpacing.md),
                                    child: Container(
                                      padding: const EdgeInsets.all(AppSpacing.sm),
                                      decoration: BoxDecoration(
                                        color: AppColors.greyLight,
                                        borderRadius: BorderRadius.circular(AppRadius.md),
                                      ),
                                      child: Text(
                                        'Catatan: ${cartItem.notes}',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ).animate().fade(
                          delay: Duration(milliseconds: 300 + index * 50),
                          duration: 400.ms,
                        );
                      }).toList(),

                      const SizedBox(height: AppSpacing.md),

                      // Summary
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            children: [
                              _SummaryRow('Subtotal', CurrencyHelper.formatCurrency(
                                order.items.fold(0.0, (sum, item) => sum + (item.menuItem.price * item.quantity)),
                              )),
                              _SummaryRow('Ongkir', CurrencyHelper.formatCurrency(10000)),
                              if (order.tip != null && order.tip! > 0)
                                _SummaryRow('Tip', CurrencyHelper.formatCurrency(order.tip!)),
                              const Divider(height: AppSpacing.lg),
                              _SummaryRow(
                                'Total',
                                CurrencyHelper.formatCurrency(order.totalAmount),
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(delay: 200.ms, duration: 400.ms),

                      const SizedBox(height: AppSpacing.lg),

                      // Action Buttons
                      if (order.status != OrderStatus.delivered &&
                          order.status != OrderStatus.cancelled)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await orderProvider.cancelOrder(order.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Pesanan dibatalkan')),
                                );
                                context.pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text(
                              'Batalkan Pesanan',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ),

                      if (order.status == OrderStatus.delivered)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => ReviewDialog(order: order),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              'Berikan Ulasan',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ),
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

class _OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.delivered,
    ];

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final s = entry.value;
        final isCompleted = statuses.indexOf(status) >= index;
        final isCurrent = status == s;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.white : AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(s),
                    color: isCompleted ? AppColors.primary : AppColors.white,
                  ),
                ),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    color: isCompleted ? AppColors.white : AppColors.primaryDark,
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusLabel(s),
                    style: AppTypography.bodyLarge.copyWith(
                      color: isCompleted ? AppColors.white : AppColors.primaryDark,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isCurrent)
                    const Text(
                      'Pesanan Anda sedang dalam tahap ini',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.preparing:
        return Icons.local_dining;
      case OrderStatus.ready:
        return Icons.done_all;
      case OrderStatus.delivered:
        return Icons.home;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Konfirmasi';
      case OrderStatus.confirmed:
        return 'Pesanan Dikonfirmasi';
      case OrderStatus.preparing:
        return 'Sedang Disiapkan';
      case OrderStatus.ready:
        return 'Siap Dikirim';
      case OrderStatus.delivered:
        return 'Pesanan Terkirim';
      case OrderStatus.cancelled:
        return 'Pesanan Dibatalkan';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )
                : AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
