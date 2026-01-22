import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catering_system/models/review.dart';
import 'package:catering_system/models/order.dart';
import 'package:catering_system/providers/review_provider.dart';
import 'package:catering_system/providers/auth_provider.dart';
import 'package:catering_system/utils/app_constants.dart';

class ReviewDialog extends StatefulWidget {
  final Order order;

  const ReviewDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 5;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_titleController.text.isEmpty || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua field'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final reviewProvider = context.read<ReviewProvider>();

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: widget.order.id,
      userId: authProvider.currentUser?.id ?? '',
      userName: authProvider.currentUser?.fullName ?? 'Anonymous',
      rating: _rating,
      title: _titleController.text,
      comment: _commentController.text,
      createdAt: DateTime.now(),
    );

    await reviewProvider.addReview(review);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil ditambahkan'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Beri Ulasan',
                    style: AppTypography.heading3,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Rating selector
              Text(
                'Rating',
                style: AppTypography.heading4,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: index < _rating ? AppColors.rating : AppColors.greyLight,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'Judul Review',
                style: AppTypography.heading4,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Enak dan tiba tepat waktu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Comment
              Text(
                'Komentar',
                style: AppTypography.heading4,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Tuliskan pengalaman Anda dengan pesanan ini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Kirim Review',
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
    );
  }
}
