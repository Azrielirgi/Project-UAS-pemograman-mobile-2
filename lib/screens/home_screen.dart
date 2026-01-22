import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:catering_system/providers/menu_provider.dart';
import 'package:catering_system/widgets/menu_card.dart';
import 'package:catering_system/widgets/promo_banner.dart';
import 'package:catering_system/utils/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _priceFilterMin = 0;
  double _priceFilterMax = 100000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().initializeMenuItems();
    });
  }

  void _showFilterBottomSheet(BuildContext context, MenuProvider menuProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Menu',
                      style: AppTypography.heading3,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Sort Section
                Text(
                  'Urutkan Berdasarkan',
                  style: AppTypography.heading4,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    ('default', 'Rekomendasi'),
                    ('price_low', 'Harga Terendah'),
                    ('price_high', 'Harga Tertinggi'),
                    ('rating', 'Rating Tertinggi'),
                    ('name', 'Nama A-Z'),
                  ].map((item) {
                    final isSelected = menuProvider.sortBy == item.$1;
                    return FilterChip(
                      label: Text(item.$2),
                      selected: isSelected,
                      onSelected: (selected) {
                        menuProvider.setSortBy(item.$1);
                        Navigator.pop(context);
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.black,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Price Filter Section
                Text(
                  'Rentang Harga',
                  style: AppTypography.heading4,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Rp ${_priceFilterMin.toStringAsFixed(0)} - Rp ${_priceFilterMax.toStringAsFixed(0)}',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                RangeSlider(
                  values: RangeValues(_priceFilterMin, _priceFilterMax),
                  onChanged: (values) {
                    setState(() {
                      _priceFilterMin = values.start;
                      _priceFilterMax = values.end;
                    });
                  },
                  min: 0,
                  max: 100000,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.greyLight,
                  labels: RangeLabels(
                    'Rp ${_priceFilterMin.toStringAsFixed(0)}',
                    'Rp ${_priceFilterMax.toStringAsFixed(0)}',
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Apply Filter Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      menuProvider.filterByPrice(_priceFilterMin, _priceFilterMax);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      'Terapkan Filter',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<MenuProvider>(
          builder: (context, menuProvider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern Header with Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryGradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.xl),
                        bottomRight: Radius.circular(AppRadius.xl),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: AppTypography.heading2.copyWith(
                            color: AppColors.white,
                            letterSpacing: -0.5,
                          ),
                        ).animate().fade(delay: 200.ms, duration: 600.ms),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Pesan catering favorit Anda hari ini',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ).animate().fade(delay: 400.ms, duration: 600.ms),
                      ],
                    ),
                  ),
                  
                  // Search Bar with shadow
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari menu...',
                                hintStyle: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.grey,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.xl),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                  horizontal: AppSpacing.md,
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                              onChanged: (value) {
                                menuProvider.searchMenuItems(value);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showFilterBottomSheet(context, menuProvider),
                                borderRadius: BorderRadius.circular(AppRadius.xl),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Icon(
                                    Icons.tune,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(delay: 400.ms, duration: 600.ms),

                  // Promo Banner
                  PromoBanner(
                    offers: [
                      SpecialOffer(
                        id: '1',
                        title: 'Diskon Spesial Hari Ini!',
                        description: 'Hemat hingga 30% untuk semua menu pilihan',
                        discount: '30',
                        backgroundColor: const Color(0xFFFF6B35),
                        imageUrl: '',
                        expiryDate: DateTime.now().add(const Duration(days: 1)),
                      ),
                      SpecialOffer(
                        id: '2',
                        title: 'Gratis Ongkir',
                        description: 'Untuk pembelian minimal Rp 100.000',
                        discount: 'Gratis',
                        backgroundColor: const Color(0xFF00BCD4),
                        imageUrl: '',
                        expiryDate: DateTime.now().add(const Duration(days: 3)),
                      ),
                      SpecialOffer(
                        id: '3',
                        title: 'Paket Keluarga Hemat',
                        description: 'Beli 3 gratis 1 untuk menu pilihan',
                        discount: '25',
                        backgroundColor: const Color(0xFF4CAF50),
                        imageUrl: '',
                        expiryDate: DateTime.now().add(const Duration(days: 5)),
                      ),
                    ],
                  ).animate().fade(delay: 450.ms, duration: 600.ms),

                  // Categories with better styling
                  if (!menuProvider.isLoading && menuProvider.categories.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.sm,
                          ),
                          child: Text(
                            'Kategori',
                            style: AppTypography.heading4,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            itemCount: menuProvider.categories.length,
                            itemBuilder: (context, index) {
                              final category = menuProvider.categories[index];
                              final isSelected =
                                  category == menuProvider.selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.sm,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primaryGradientEnd,
                                            ],
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : AppColors.white,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.xl),
                                    border: !isSelected
                                        ? Border.all(
                                            color: AppColors.greyLight,
                                            width: 1,
                                          )
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        menuProvider
                                            .filterByCategory(category);
                                      },
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.xl,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md,
                                          vertical: AppSpacing.xs,
                                        ),
                                        child: Center(
                                          child: Text(
                                            category,
                                            style: AppTypography.bodyMedium
                                                .copyWith(
                                              color: isSelected
                                                  ? AppColors.white
                                                  : AppColors.black,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ).animate().fade(
                                delay: Duration(
                                  milliseconds: 200 + index * 100,
                                ),
                                duration: 600.ms,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: AppSpacing.lg),

                  // Menu Items with better grid
                  if (menuProvider.isLoading)
                    Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                    )
                  else if (menuProvider.filteredMenuItems.isEmpty)
                    Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(
                                AppRadius.circle,
                              ),
                            ),
                            child: const Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Menu tidak ditemukan',
                            style: AppTypography.heading4,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Coba cari dengan kategori lain',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.6,
                        ),
                        itemCount:
                            menuProvider.filteredMenuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem =
                              menuProvider.filteredMenuItems[index];
                          return MenuCard(
                            menuItem: menuItem,
                          ).animate().fade(
                            delay: Duration(
                              milliseconds: 200 + index * 100,
                            ),
                            duration: 600.ms,
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
