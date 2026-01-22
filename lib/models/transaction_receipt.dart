class TransactionReceipt {
  final String transactionId;
  final String orderId;
  final double amount;
  final String paymentMethod;
  final DateTime transactionDate;
  final String status;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> breakdown;
  final String deliveryAddress;
  final String customerName;
  final String customerPhone;
  final DateTime deliveryDate;

  TransactionReceipt({
    required this.transactionId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    required this.status,
    required this.items,
    required this.breakdown,
    required this.deliveryAddress,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'orderId': orderId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'transactionDate': transactionDate.toIso8601String(),
      'status': status,
      'items': items,
      'breakdown': breakdown,
      'deliveryAddress': deliveryAddress,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryDate': deliveryDate.toIso8601String(),
    };
  }
}
