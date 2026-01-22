import 'package:flutter/material.dart';
import 'package:catering_system/models/menu_item.dart';
import 'package:catering_system/services/mock_api_service.dart';

class MenuProvider extends ChangeNotifier {
  final MockApiService _apiService = MockApiService();

  List<MenuItem> _allMenuItems = [];
  List<MenuItem> _filteredMenuItems = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 100000;
  String _sortBy = 'default'; // default, price_low, price_high, rating, name

  // Getters
  List<MenuItem> get allMenuItems => _allMenuItems;
  List<MenuItem> get filteredMenuItems => _filteredMenuItems;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get sortBy => _sortBy;

  // Initialize menu items
  Future<void> initializeMenuItems() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _allMenuItems = await _apiService.getAllMenuItems();
      _filteredMenuItems = _allMenuItems;

      // Get categories
      final allCategories = await _apiService.getCategories();
      _categories = ['All', ...allCategories];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by category
  Future<void> filterByCategory(String category) async {
    try {
      _selectedCategory = category;
      _isLoading = true;
      notifyListeners();

      if (category == 'All') {
        _filteredMenuItems = _allMenuItems;
      } else {
        _filteredMenuItems = await _apiService.getMenuItemsByCategory(category);
      }

      _applyAllFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search menu items
  Future<void> searchMenuItems(String query) async {
    try {
      if (query.isEmpty) {
        _filteredMenuItems = _allMenuItems;
      } else {
        _filteredMenuItems = await _apiService.searchMenuItems(query);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get single menu item
  Future<MenuItem?> getMenuItemById(String id) async {
    try {
      return await _apiService.getMenuItemById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Filter by price range
  void filterByPrice(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyAllFilters();
  }

  // Set sort option
  void setSortBy(String sortOption) {
    _sortBy = sortOption;
    _applyAllFilters();
  }

  // Apply all filters and sorting
  void _applyAllFilters() {
    var result = _allMenuItems.where((item) {
      // Price filter
      if (item.price < _minPrice || item.price > _maxPrice) {
        return false;
      }
      // Category filter
      if (_selectedCategory != 'All' && item.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        // Keep original order
        break;
    }

    _filteredMenuItems = result;
    notifyListeners();
  }
}
