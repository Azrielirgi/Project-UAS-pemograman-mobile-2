import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:catering_system/models/cart_item.dart';
import 'package:catering_system/models/menu_item.dart';
import 'package:catering_system/models/promo_code.dart';
import 'package:catering_system/services/mock_api_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  PromoCode? _appliedPromoCode;
  double _deliveryFee = 10000;
  final MockApiService _apiService = MockApiService();

  // Getters
  List<CartItem> get items => _items;
  PromoCode? get appliedPromoCode => _appliedPromoCode;
  double get deliveryFee => _deliveryFee;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  double get discount {
    if (_appliedPromoCode == null) return 0;
    if (_appliedPromoCode!.isPercentage) {
      return subtotal * (_appliedPromoCode!.discountValue / 100);
    }
    return _appliedPromoCode!.discountValue;
  }

  double get total => subtotal - discount + _deliveryFee;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Add item to cart
  void addToCart(MenuItem menuItem, {int quantity = 1, String notes = ''}) {
    try {
      final existingIndex = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

      if (existingIndex >= 0) {
        _items[existingIndex].quantity += quantity;
      } else {
        _items.add(
          CartItem(
            id: const Uuid().v4(),
            menuItem: menuItem,
            quantity: quantity,
            addedAt: DateTime.now(),
            notes: notes,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Remove item from cart
  void removeFromCart(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  // Alias for removeFromCart
  void removeItem(String cartItemId) {
    removeFromCart(cartItemId);
  }

  // Update quantity
  void updateQuantity(String cartItemId, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0 && newQuantity > 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  // Update notes
  void updateNotes(String cartItemId, String notes) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _items[index].notes = notes;
      notifyListeners();
    }
  }

  // Apply promo code
  Future<bool> applyPromoCode(String code) async {
    try {
      final promoCode = await _apiService.validatePromoCode(code);
      if (promoCode != null) {
        _appliedPromoCode = promoCode;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Remove promo code
  void removePromoCode() {
    _appliedPromoCode = null;
    notifyListeners();
  }

  // Set delivery fee
  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    notifyListeners();
  }

  // Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  // Get cart summary
  Map<String, dynamic> getCartSummary() {
    return {
      'itemCount': itemCount,
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'promoCode': _appliedPromoCode?.code,
    };
  }
}
