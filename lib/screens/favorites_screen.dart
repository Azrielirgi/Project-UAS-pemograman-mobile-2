import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/utils/app_constants.dart';
import 'package:catering_system/providers/cart_provider.dart';
import 'package:catering_system/providers/menu_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<int> favorites = [];

  @override
  void initState() {
    super.initState();
    // Load favorites from local storage or provider
    _loadFavorites();
  }

  void _loadFavorites() {
    // Mock favorites - bisa diganti dengan SharedPreferences
    favorites = [0, 2, 4]; // Index menu favorit
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          favorites.contains(index) 
            ? 'Ditambahkan ke favorit' 
            : 'Dihapus dari favorit',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: favorites.contains(index) 
          ? AppColors.success 
          : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Menu Favorit'),
        centerTitle: true,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_outline, size: 80, color: AppColors.grey),
                  const SizedBox(height: AppSpacing.md),
                  Text('Belum ada menu favorit', 
                    style: AppTypography.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Tambahkan menu favorit untuk akses cepat',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: const Text('Jelajahi Menu'),
                  ),
                ],
              ),
            )
          : Consumer2<MenuProvider, CartProvider>(
              builder: (context, menuProvider, cartProvider, child) {
                final favoriteItems = menuProvider.allMenuItems
                    .asMap()
                    .entries
                    .where((entry) => favorites.contains(entry.key))
                    .map((entry) => entry.value)
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              // Image
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppColors.greyLight,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  image: item.imageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(item.imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: item.imageUrl.isEmpty
                                    ? const Icon(Icons.restaurant, color: AppColors.grey)
                                    : null,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              // Item info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Rp ${item.price.toString()}',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, 
                                          color: AppColors.rating, 
                                          size: 16,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(
                                          item.rating.toString(),
                                          style: AppTypography.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Actions
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite, 
                                      color: AppColors.error,
                                      size: 24,
                                    ),
                                    onPressed: () => _toggleFavorite(
                                      menuProvider.allMenuItems.indexOf(item)
                                    ),
                                    iconSize: 24,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(AppRadius.sm),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          cartProvider.addToCart(item);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Ditambahkan ke keranjang'),
                                              duration: const Duration(seconds: 1),
                                              backgroundColor: AppColors.success,
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSpacing.md,
                                            vertical: AppSpacing.xs,
                                          ),
                                          child: Icon(Icons.shopping_cart, 
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 + index * 50),
                      duration: 400.ms,
                    );
                  },
                );
              },
            ),
    );
  }
}
