import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/utils/responsive_helper.dart';

class BookCardShimmer extends StatelessWidget {
  const BookCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isWeb = ResponsiveHelper.isWeb(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 8,
        vertical: 4, // Reduced vertical margin to match book card
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Container(
        // Natural height for all screen sizes
        padding: EdgeInsets.all(8), // Reduced padding to match book card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: _buildShimmer(context),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    // Use same horizontal layout for all screen sizes (mobile UI)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book Cover Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 80,
            height: 100, // Increased height to match book card
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Book Details Shimmer
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left align
            children: [
              // Book Name Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Book Author Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 13,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Published Date Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}

class BookListShimmer extends StatelessWidget {
  final int itemCount;

  const BookListShimmer({Key? key, this.itemCount = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const BookCardShimmer(),
    );
  }
}

