import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/providers/cart_provider.dart';
import 'package:catering_system/utils/helpers.dart';
import 'package:catering_system/utils/app_constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? promoCodeInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Keranjang Belanja'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(AppRadius.circle),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Keranjang Anda kosong', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Mulai pesan menu favorit Anda',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Mulai Belanja'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Cart Items
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Image thumbnail
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEEEEE),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.lg),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          cartItem.menuItem.imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {},
                                      ),
                                    ),
                                    child: cartItem.menuItem.imageUrl.isEmpty
                                        ? const Icon(Icons.restaurant_menu,
                                            color: Color(0xFF999999))
                                        : null,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.menuItem.name,
                                          style: AppTypography.bodyLarge
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1F1F1F),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          CurrencyHelper.formatCurrency(
                                            cartItem.menuItem.price,
                                          ),
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFFF6B35),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Subtotal: ${CurrencyHelper.formatCurrency(cartItem.subtotal)}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                            color: const Color(0xFF999999),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              // Quantity Controls & Delete
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.md,
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFEEEEEE),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Color(0xFFFF6B35),
                                            size: 18,
                                          ),
                                          onPressed: cartItem.quantity > 1
                                              ? () =>
                                                  cartProvider
                                                      .updateQuantity(
                                                    cartItem.id,
                                                    cartItem.quantity - 1,
                                                  )
                                              : null,
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: Center(
                                            child: Text(
                                              cartItem.quantity.toString(),
                                              style:
                                                  AppTypography.bodyMedium
                                                      .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Color(0xFFFF6B35),
                                            size: 18,
                                          ),
                                          onPressed: () =>
                                              cartProvider.updateQuantity(
                                                cartItem.id,
                                                cartItem.quantity + 1,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () =>
                                          cartProvider.removeFromCart(cartItem.id),
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                          AppSpacing.sm,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE74C3C)
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.md,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Color(0xFFE74C3C),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(
                        delay: Duration(milliseconds: 100 + index * 50),
                        duration: 400.ms,
                      );
                    },
                  ),
                ),

                // Promo Code Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kode Promo',
                            style: AppTypography.heading4,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (cartProvider.appliedPromoCode == null)
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    style: AppTypography.bodyMedium,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan kode promo',
                                      hintStyle: AppTypography.bodyMedium
                                          .copyWith(
                                        color: const Color(0xFF999999),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.md),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFEEEEEE),
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.sm,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5F5),
                                    ),
                                    onChanged: (value) =>
                                        promoCodeInput = value,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                ElevatedButton(
                                  onPressed: () {
                                    if (promoCodeInput != null &&
                                        promoCodeInput!.isNotEmpty) {
                                      cartProvider.applyPromoCode(
                                        promoCodeInput!,
                                      );
                                    }
                                  },
                                  child: const Text('Gunakan'),
                                ),
                              ],
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50)
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color:
                                      const Color(0xFF4CAF50).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kode: ${cartProvider.appliedPromoCode!.code}',
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        cartProvider.appliedPromoCode!
                                            .description,
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        cartProvider.removePromoCode(),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Summary
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          _SummaryRow(
                            'Subtotal',
                            CurrencyHelper.formatCurrency(
                              cartProvider.subtotal,
                            ),
                          ),
                          if (cartProvider.discount > 0)
                            _SummaryRow(
                              'Diskon',
                              '-${CurrencyHelper.formatCurrency(cartProvider.discount)}',
                              color: const Color(0xFF4CAF50),
                            ),
                          _SummaryRow(
                            'Ongkir',
                            CurrencyHelper.formatCurrency(
                              cartProvider.deliveryFee,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Divider(
                              height: 1,
                              color: const Color(0xFFEEEEEE),
                            ),
                          ),
                          _SummaryRow(
                            'Total',
                            CurrencyHelper.formatCurrency(cartProvider.total),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Checkout Button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => context.push('/checkout'),
                      child: const Text(
                        'Lanjut ke Pembayaran',
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isTotal;

  const _SummaryRow(
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
                ? AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F1F1F),
                  )
                : AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF999999),
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFF6B35),
                  )
                : AppTypography.bodyMedium.copyWith(
                    color: color ?? const Color(0xFF1F1F1F),
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      ),
    );
  }
}
