import 'package:flutter/material.dart';
import 'package:catering_system/models/order.dart';
import 'package:catering_system/services/firebase_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create order
  Future<String?> createOrder(Order order) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final orderId = await _firebaseService.createOrder(order);
      _currentOrder = order;
      _orders.insert(0, order);

      _isLoading = false;
      notifyListeners();
      return orderId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Get user orders
  Future<void> getUserOrders(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _firebaseService.getUserOrders(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get order by ID
  Future<void> getOrderById(String orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentOrder = await _firebaseService.getOrderById(orderId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firebaseService.updateOrderStatus(orderId, status);
      
      // Update local state
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index >= 0) {
        // Create new order with updated status
        final updatedOrder = Order(
          id: _orders[index].id,
          userId: _orders[index].userId,
          items: _orders[index].items,
          totalAmount: _orders[index].totalAmount,
          status: status,
          orderDate: _orders[index].orderDate,
          deliveryDate: _orders[index].deliveryDate,
          deliveryAddress: _orders[index].deliveryAddress,
          phoneNumber: _orders[index].phoneNumber,
          notes: _orders[index].notes,
          tip: _orders[index].tip,
        );
        _orders[index] = updatedOrder;
        
        if (_currentOrder?.id == orderId) {
          _currentOrder = updatedOrder;
        }
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      await updateOrderStatus(orderId, OrderStatus.cancelled);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
