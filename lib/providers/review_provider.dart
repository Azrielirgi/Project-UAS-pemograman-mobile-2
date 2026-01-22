import 'package:flutter/material.dart';
import 'package:catering_system/models/review.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get reviews for specific order
  List<Review> getReviewsForOrder(String orderId) {
    return _reviews.where((review) => review.orderId == orderId).toList();
  }

  // Add review
  Future<void> addReview(Review review) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _reviews.add(review);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update review
  Future<void> updateReview(Review review) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      final index = _reviews.indexWhere((r) => r.id == review.id);
      if (index != -1) {
        _reviews[index] = review;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _reviews.removeWhere((review) => review.id == reviewId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get average rating for reviews
  double getAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }
}
