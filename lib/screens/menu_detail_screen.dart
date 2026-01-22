import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/models/menu_item.dart';
import 'package:catering_system/providers/cart_provider.dart';
import 'package:catering_system/providers/menu_provider.dart';
import 'package:catering_system/utils/helpers.dart';
import 'package:catering_system/utils/app_constants.dart';

class MenuDetailScreen extends StatefulWidget {
  final String menuId;

  const MenuDetailScreen({Key? key, required this.menuId}) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late MenuItem _menuItem;
  int _quantity = 1;
  String _notes = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenuDetail();
  }

  Future<void> _loadMenuDetail() async {
    final menuItem = await context.read<MenuProvider>().getMenuItemById(widget.menuId);
    if (mounted) {
      setState(() {
        _menuItem = menuItem!;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Stack(
              children: [
                Container(
                  height: 300,
                  color: AppColors.greyLight,
                  child: Image.network(
                    _menuItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.greyLight,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ).animate().fadeIn(),
                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.black),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
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
                            Text(_menuItem.name, style: AppTypography.heading2)
                                .animate().fade(duration: 400.ms),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _menuItem.category,
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          CurrencyHelper.formatCurrency(_menuItem.price),
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.rating, size: 20),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${_menuItem.rating} (${_menuItem.reviews} ulasan)',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  Text('Deskripsi', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _menuItem.description,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Servings
                  Text('Jumlah Porsi', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          'Untuk ${_menuItem.servings} orang',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Ingredients
                  Text('Bahan-bahan', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _menuItem.ingredients
                        .map((ingredient) => Chip(
                          label: Text(ingredient),
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                        ))
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Notes
                  Text('Catatan Khusus (Opsional)', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Masukkan catatan khusus untuk pesanan ini',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                    onChanged: (value) => _notes = value,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Quantity
                  Text('Jumlah Pesanan', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyLight),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Text(
                          _quantity.toString(),
                          style: AppTypography.heading3,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Related Items Section
                  Text(
                    'Menu Rekomendasi',
                    style: AppTypography.heading4,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 180,
                    child: Consumer<MenuProvider>(
                      builder: (context, menuProvider, child) {
                        final relatedItems = menuProvider.allMenuItems
                            .where((item) =>
                                item.category == _menuItem.category &&
                                item.id != _menuItem.id)
                            .take(4)
                            .toList();

                        if (relatedItems.isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Tidak ada menu sejenis lainnya',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: relatedItems.length,
                          itemBuilder: (context, index) {
                            final item = relatedItems[index];
                            return GestureDetector(
                              onTap: () => context.push('/menu/${item.id}'),
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.only(right: AppSpacing.md),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(AppRadius.md),
                                          topRight: Radius.circular(AppRadius.md),
                                        ),
                                        color: AppColors.greyLight,
                                        image: item.imageUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(item.imageUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(AppSpacing.sm),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: AppTypography.bodySmall.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            CurrencyHelper.formatCurrency(item.price),
                                            style: AppTypography.bodySmall.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartProvider>().addToCart(
                          _menuItem,
                          quantity: _quantity,
                          notes: _notes,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_menuItem.name} ditambahkan ke keranjang'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                      ),
                    ),
                  ).animate().fade(duration: 400.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
