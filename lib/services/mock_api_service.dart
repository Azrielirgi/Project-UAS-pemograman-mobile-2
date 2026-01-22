import 'package:catering_system/models/menu_item.dart';
import 'package:catering_system/models/promo_code.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();

  factory MockApiService() {
    return _instance;
  }

  MockApiService._internal();

  // Mock Menu Data
  final List<MenuItem> _mockMenuItems = [
    MenuItem(
      id: '1',
      name: 'Paket Nasi Kuning',
      description: 'Nasi kuning dengan lauk pauk lengkap dan sambal',
      price: 45000,
      category: 'Paket Nasi',
      imageUrl: 'https://via.placeholder.com/300?text=Nasi+Kuning',
      servings: 20,
      ingredients: ['Beras', 'Santan', 'Kunyit', 'Telur', 'Sayuran'],
      rating: 4.5,
      reviews: 125,
    ),
    MenuItem(
      id: '2',
      name: 'Paket Ayam Bakar',
      description: 'Ayam bakar marinasi bumbu khas dengan nasi putih',
      price: 55000,
      category: 'Paket Ayam',
      imageUrl: 'https://via.placeholder.com/300?text=Ayam+Bakar',
      servings: 20,
      ingredients: ['Ayam', 'Bumbu Bakar', 'Nasi', 'Sambal', 'Lalapan'],
      rating: 4.8,
      reviews: 256,
    ),
    MenuItem(
      id: '3',
      name: 'Paket Soto Ayam',
      description: 'Soto ayam kuning dengan kuah gurih dan pelengkap lengkap',
      price: 40000,
      category: 'Paket Soto',
      imageUrl: 'https://via.placeholder.com/300?text=Soto+Ayam',
      servings: 20,
      ingredients: ['Ayam', 'Kunyit', 'Bawang', 'Santan', 'Telur'],
      rating: 4.3,
      reviews: 89,
    ),
    MenuItem(
      id: '4',
      name: 'Paket Gado-gado',
      description: 'Gado-gado segar dengan bumbu kacang yang lezat',
      price: 35000,
      category: 'Paket Vegetarian',
      imageUrl: 'https://via.placeholder.com/300?text=Gado-Gado',
      servings: 25,
      ingredients: ['Tahu', 'Tempe', 'Sayuran', 'Bumbu Kacang', 'Telur'],
      rating: 4.4,
      reviews: 142,
    ),
    MenuItem(
      id: '5',
      name: 'Paket Rendang Daging',
      description: 'Daging sapi rendang dengan santan kental dan pedas',
      price: 65000,
      category: 'Paket Premium',
      imageUrl: 'https://via.placeholder.com/300?text=Rendang',
      servings: 15,
      ingredients: ['Daging Sapi', 'Santan', 'Cabai', 'Bawang', 'Lengkuas'],
      rating: 4.9,
      reviews: 187,
    ),
    MenuItem(
      id: '6',
      name: 'Paket Ikan Bakar',
      description: 'Ikan bakar segar dengan bumbu rempah tradisional',
      price: 50000,
      category: 'Paket Seafood',
      imageUrl: 'https://via.placeholder.com/300?text=Ikan+Bakar',
      servings: 20,
      ingredients: ['Ikan', 'Bumbu Bakar', 'Jeruk Nipis', 'Garam', 'Cabe'],
      rating: 4.6,
      reviews: 134,
    ),
    MenuItem(
      id: '7',
      name: 'Paket Lumpia',
      description: 'Lumpia emas gurih dengan isian daging dan sayuran',
      price: 25000,
      category: 'Appetizer',
      imageUrl: 'https://via.placeholder.com/300?text=Lumpia',
      servings: 30,
      ingredients: ['Kulit Lumpia', 'Daging', 'Sayuran', 'Bumbu', 'Minyak'],
      rating: 4.2,
      reviews: 95,
    ),
    MenuItem(
      id: '8',
      name: 'Paket Martabak Manis',
      description: 'Martabak manis dengan berbagai pilihan isi',
      price: 20000,
      category: 'Dessert',
      imageUrl: 'https://via.placeholder.com/300?text=Martabak',
      servings: 40,
      ingredients: ['Tepung', 'Telur', 'Gula', 'Coklat', 'Keju'],
      rating: 4.7,
      reviews: 203,
    ),
  ];

  final List<PromoCode> _mockPromoCodes = [
    PromoCode(
      id: 'promo1',
      code: 'WELCOME20',
      description: 'Diskon 20% untuk pemesanan pertama',
      discountValue: 20,
      isPercentage: true,
      usageLimit: 100,
      usageCount: 35,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    PromoCode(
      id: 'promo2',
      code: 'HEMAT50',
      description: 'Diskon Rp. 50.000 untuk pembelian minimal Rp. 200.000',
      discountValue: 50000,
      isPercentage: false,
      usageLimit: 50,
      usageCount: 12,
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Get all menu items
  Future<List<MenuItem>> getAllMenuItems() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockMenuItems;
  }

  // Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockMenuItems.where((item) => item.category == category).toList();
  }

  // Get single menu item
  Future<MenuItem?> getMenuItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _mockMenuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all promo codes
  Future<List<PromoCode>> getAllPromoCodes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPromoCodes.where((promo) => promo.isValid).toList();
  }

  // Validate promo code
  Future<PromoCode?> validatePromoCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _mockPromoCodes.firstWhere(
        (promo) => promo.code.toUpperCase() == code.toUpperCase() && promo.isValid,
      );
    } catch (e) {
      return null;
    }
  }

  // Get categories
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final categories = _mockMenuItems.map((item) => item.category).toSet().toList();
    return categories;
  }

  // Search menu items
  Future<List<MenuItem>> searchMenuItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final lowerQuery = query.toLowerCase();
    return _mockMenuItems
        .where((item) =>
            item.name.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
