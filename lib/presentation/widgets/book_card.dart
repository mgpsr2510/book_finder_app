import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/book.dart';
import '../../core/utils/responsive_helper.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    Key? key,
    required this.book,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isWeb = ResponsiveHelper.isWeb(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 8,
        vertical: 4, // Reduced vertical margin
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
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
          child: Container(
            // Natural height for all screen sizes
            padding: EdgeInsets.all(8), // Reduced padding for all screen sizes
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: _buildLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    // Use same horizontal layout for all screen sizes (mobile UI)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBookCover(80, 100), // Book image - increased height
        const SizedBox(width: 12), // Spacing between image and column
        Expanded(
          child: _buildBookDetails(context), // Column with book details
        ),
      ],
    );
  }


  Widget _buildBookCover(double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: book.coverImageUrl != null
            ? CachedNetworkImage(
                imageUrl: book.coverImageUrl!,
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(width, height),
                errorWidget: (context, url, error) => _buildPlaceholder(width, height),
              )
            : _buildPlaceholder(width, height),
      ),
    );
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[200]!,
            Colors.grey[300]!,
          ],
        ),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: Colors.grey[500],
        size: width * 0.4,
      ),
    );
  }

  Widget _buildBookDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left align all data
      mainAxisSize: MainAxisSize.min,
      children: [
        // Book Name
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: Color(0xFF1A1A1A),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start, // Left align
        ),
        const SizedBox(height: 4),
        
        // Book Author
        if (book.authors.isNotEmpty) ...[
          Text(
            book.authors.join(', '),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2, // Changed to max 2 lines
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start, // Left align
          ),
          const SizedBox(height: 2),
        ],
        
        // Published Date
        if (book.publishDate != null) ...[
          Text(
            book.publishDate!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start, // Left align
          ),
        ],
      ],
    );
  }
}

