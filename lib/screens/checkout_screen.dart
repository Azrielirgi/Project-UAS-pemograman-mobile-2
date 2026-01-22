import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/models/order.dart';
import 'package:catering_system/models/transaction_receipt.dart';
import 'package:catering_system/providers/cart_provider.dart';
import 'package:catering_system/providers/order_provider.dart';
import 'package:catering_system/providers/auth_provider.dart';
import 'package:catering_system/utils/helpers.dart';
import 'package:catering_system/utils/app_constants.dart';
import 'package:catering_system/screens/transaction_receipt_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _deliveryAddress;
  late String _phoneNumber;
  late DateTime _deliveryDate;
  String _deliveryNotes = '';
  double _tip = 0;
  int _selectedPayment = 0;
  
  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Transfer Bank', 'icon': Icons.account_balance, 'code': 'bank'},
    {'name': 'E-Wallet', 'icon': Icons.wallet_membership, 'code': 'ewallet'},
    {'name': 'Kartu Kredit', 'icon': Icons.credit_card, 'code': 'card'},
    {'name': 'Bayar di Tempat', 'icon': Icons.payments, 'code': 'cash'},
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _deliveryAddress = authProvider.currentUser?.address ?? '';
    _phoneNumber = authProvider.currentUser?.phoneNumber ?? '';
    _deliveryDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Konfirmasi Pesanan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Consumer2<CartProvider, AuthProvider>(
          builder: (context, cartProvider, authProvider, child) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Informasi Pengiriman', style: AppTypography.heading3)
                            .animate().fade(duration: 400.ms),
                        const SizedBox(height: AppSpacing.md),

                        TextFormField(
                          initialValue: _deliveryAddress,
                          decoration: InputDecoration(
                            labelText: 'Alamat Pengiriman',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Alamat tidak boleh kosong' : null,
                          onChanged: (value) => _deliveryAddress = value,
                        ).animate().fade(delay: 100.ms, duration: 400.ms),

                        const SizedBox(height: AppSpacing.md),

                        TextFormField(
                          initialValue: _phoneNumber,
                          decoration: InputDecoration(
                            labelText: 'Nomor Telepon',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Nomor telepon tidak boleh kosong' : null,
                          onChanged: (value) => _phoneNumber = value,
                        ).animate().fade(delay: 200.ms, duration: 400.ms),

                        const SizedBox(height: AppSpacing.md),

                        GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _deliveryDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (date != null) {
                              setState(() => _deliveryDate = date);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.greyLight),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: AppColors.primary),
                                const SizedBox(width: AppSpacing.md),
                                Text(
                                  DateTimeHelper.formatDate(_deliveryDate),
                                  style: AppTypography.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ).animate().fade(delay: 300.ms, duration: 400.ms),

                        const SizedBox(height: AppSpacing.lg),

                        // Delivery Notes
                        Text('Catatan Pengiriman', style: AppTypography.heading3),
                        const SizedBox(height: AppSpacing.md),

                        TextField(
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Catatan untuk kurir (opsional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                          ),
                          onChanged: (value) => _deliveryNotes = value,
                        ).animate().fade(delay: 400.ms, duration: 400.ms),

                        const SizedBox(height: AppSpacing.lg),

                        // Payment Method
                        Text('Metode Pembayaran', style: AppTypography.heading3),
                        const SizedBox(height: AppSpacing.md),

                        _PaymentMethodTile(
                          title: 'Transfer Bank',
                          subtitle: 'BCA, BRI, Mandiri',
                          icon: Icons.account_balance,
                          selected: _selectedPayment == 0,
                          onTap: () => setState(() => _selectedPayment = 0),
                        ).animate().fade(delay: 500.ms, duration: 400.ms),

                        const SizedBox(height: AppSpacing.lg),

                        // Tip
                        Text('Tambahan Tip untuk Kurir', style: AppTypography.heading3),
                        const SizedBox(height: AppSpacing.md),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [0, 10000, 25000, 50000].map((amount) {
                            return GestureDetector(
                              onTap: () => setState(() => _tip = amount.toDouble()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: _tip == amount
                                      ? AppColors.primary
                                      : AppColors.white,
                                  border: Border.all(
                                    color: _tip == amount
                                        ? AppColors.primary
                                        : AppColors.greyLight,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: Text(
                                  CurrencyHelper.formatCurrency(amount.toDouble()),
                                  style: TextStyle(
                                    color: _tip == amount
                                        ? AppColors.white
                                        : AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),

                  // Summary Card
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ringkasan Pesanan', style: AppTypography.heading3),
                        const SizedBox(height: AppSpacing.md),
                        _SummaryItem(
                          'Subtotal',
                          CurrencyHelper.formatCurrency(cartProvider.subtotal),
                        ),
                        if (cartProvider.discount > 0)
                          _SummaryItem(
                            'Diskon',
                            '-${CurrencyHelper.formatCurrency(cartProvider.discount)}',
                            color: AppColors.success,
                          ),
                        _SummaryItem(
                          'Ongkir',
                          CurrencyHelper.formatCurrency(cartProvider.deliveryFee),
                        ),
                        _SummaryItem(
                          'Tip',
                          CurrencyHelper.formatCurrency(_tip),
                        ),
                        const Divider(height: AppSpacing.lg),
                        _SummaryItem(
                          'Total',
                          CurrencyHelper.formatCurrency(
                            cartProvider.total + _tip,
                          ),
                          isTotal: true,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Order Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // Show payment processing dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.lg),
                                        Text(
                                          'Memproses Pembayaran...',
                                          style: AppTypography.bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                // Simulate payment processing
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );

                                if (!mounted) return;

                                final order = Order(
                                  id: '',
                                  userId: authProvider.currentUser?.id ?? '',
                                  items: cartProvider.items,
                                  totalAmount: cartProvider.total + _tip,
                                  status: OrderStatus.pending,
                                  orderDate: DateTime.now(),
                                  deliveryDate: _deliveryDate,
                                  deliveryAddress: _deliveryAddress,
                                  phoneNumber: _phoneNumber,
                                  notes: _deliveryNotes,
                                  tip: _tip > 0 ? _tip : null,
                                );

                                final orderId = await context
                                    .read<OrderProvider>()
                                    .createOrder(order);

                                if (orderId != null && mounted) {
                                  // Generate transaction receipt
                                  final receipt = TransactionReceipt(
                                    transactionId:
                                        'TRX-${DateTime.now().millisecondsSinceEpoch}',
                                    orderId: orderId,
                                    amount: cartProvider.total + _tip,
                                    paymentMethod: paymentMethods[_selectedPayment]
                                        ['name'],
                                    transactionDate: DateTime.now(),
                                    status: 'Berhasil',
                                    items: cartProvider.items
                                        .map((item) => {
                                              'name': item.menuItem.name,
                                              'quantity': item.quantity,
                                              'price': item.menuItem.price * item.quantity,
                                            })
                                        .toList(),
                                    breakdown: {
                                      'subtotal': cartProvider.subtotal,
                                      'tax': cartProvider.subtotal * 0.1,
                                      'deliveryFee': cartProvider.deliveryFee,
                                      'discount': cartProvider.discount,
                                      'tip': _tip,
                                    },
                                    deliveryAddress: _deliveryAddress,
                                    customerName:
                                        authProvider.currentUser?.fullName ?? '',
                                    customerPhone: _phoneNumber,
                                    deliveryDate: _deliveryDate,
                                  );

                                  cartProvider.clearCart();

                                  Navigator.pop(context); // Close loading dialog

                                  // Navigate to receipt
                                  if (mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionReceiptScreen(
                                              receipt: receipt,
                                            ),
                                      ),
                                    ).then((_) {
                                      if (mounted) {
                                        context.go('/orders');
                                      }
                                    });
                                  }
                                } else {
                                  Navigator.pop(context); // Close loading dialog
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal membuat pesanan'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              'Proses Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
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
          },
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: selected ? AppColors.primary : AppColors.grey),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodyLarge),
                      Text(subtitle, style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isTotal;

  const _SummaryItem(
    this.label,
    this.value, {
    this.color,
    this.isTotal = false,
  });

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
                : AppTypography.bodyMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
