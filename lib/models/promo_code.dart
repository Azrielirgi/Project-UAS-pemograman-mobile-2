class PromoCode {
  final String id;
  final String code;
  final String description;
  final double discountValue;
  final bool isPercentage;
  final int usageLimit;
  final int usageCount;
  final DateTime expiryDate;
  final DateTime createdAt;

  PromoCode({
    required this.id,
    required this.code,
    required this.description,
    required this.discountValue,
    required this.isPercentage,
    required this.usageLimit,
    required this.usageCount,
    required this.expiryDate,
    required this.createdAt,
  });

  bool get isValid => DateTime.now().isBefore(expiryDate) && usageCount < usageLimit;

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      isPercentage: json['isPercentage'] ?? false,
      usageLimit: json['usageLimit'] ?? 0,
      usageCount: json['usageCount'] ?? 0,
      expiryDate: DateTime.parse(json['expiryDate'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountValue': discountValue,
      'isPercentage': isPercentage,
      'usageLimit': usageLimit,
      'usageCount': usageCount,
      'expiryDate': expiryDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
