import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/book_details/book_details_bloc.dart';
import '../bloc/book_details/book_details_event.dart';
import '../bloc/book_details/book_details_state.dart';
import '../widgets/responsive_wrapper.dart';
import '../../core/utils/responsive_helper.dart';

class BookDetailsPage extends StatefulWidget {
  final String bookId;

  const BookDetailsPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8), // Slower rotation
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // Full rotation (360 degrees)
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _fadeController.forward();
    _rotationController.repeat(reverse: true);

    context.read<BookDetailsBloc>().add(
      LoadBookDetailsEvent(bookId: widget.bookId),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading book details...'),
                ],
              ),
            );
          } else if (state is BookDetailsLoaded) {
            return _buildBookDetails(state);
          } else if (state is BookDetailsError) {
            return _buildError(state);
          }

          return const Center(
            child: Text('Unknown state'),
          );
        },
      ),
    );
  }

  Widget _buildBookDetails(BookDetailsLoaded state) {
    return ResponsiveHelper.isMobile(context)
        ? _buildMobileLayout(state)
        : _buildDesktopLayout(state);
  }

  Widget _buildMobileLayout(BookDetailsLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildAnimatedCover(state, 200, 280),
          ),
          actions: [
            IconButton(
              icon: Icon(
                state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () => _toggleBookmark(state),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildBookContent(state),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BookDetailsLoaded state) {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Book cover
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    _buildAnimatedCover(state, 300, 420),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _toggleBookmark(state),
                          icon: Icon(
                            state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          ),
                          label: Text(
                            state.isSaved ? 'Saved' : 'Save Book',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right side - Book details
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _buildBookContent(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCover(BookDetailsLoaded state, double width, double height) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[400]!,
                  Colors.purple[400]!,
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: state.book.coverImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: state.book.coverImageUrl!,
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.book,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.book,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.book,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookContent(BookDetailsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book Title
        Text(
          state.book.title,
          style: TextStyle(
            fontSize: ResponsiveHelper.isMobile(context) ? 24 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Authors
        if (state.book.authors.isNotEmpty) ...[
          Text(
            'By ${state.book.authors.join(', ')}',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 16 : 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
        ],
        
        // Book Details
        _buildDetailRow('Published', state.book.publishDate),
        _buildDetailRow('Pages', state.book.pageCount?.toString()),
        _buildDetailRow('ISBN', state.book.isbn),
        _buildDetailRow('Language', state.book.language),
        _buildDetailRow('Publisher', state.book.publisher),
        
        // Subjects
        if (state.book.subjects != null && state.book.subjects!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Subjects',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.book.subjects!
                .take(ResponsiveHelper.isMobile(context) ? 10 : 15)
                .map((subject) => Chip(
                      label: Text(subject),
                      backgroundColor: Colors.blue[100],
                    ))
                .toList(),
          ),
        ],
        
        // Description
        if (state.book.description != null) ...[
          const SizedBox(height: 32),
          Text(
            'Description',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.book.description!,
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 16 : 18,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  void _toggleBookmark(BookDetailsLoaded state) {
    if (state.isSaved) {
      context.read<BookDetailsBloc>().add(const RemoveBookEvent());
      _showMessage('Book removed from saved collection', Colors.orange[600]!);
    } else {
      context.read<BookDetailsBloc>().add(const SaveBookEvent());
      _showMessage('Book saved successfully!', Colors.green[600]!);
    }
  }

  void _showMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BookDetailsError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: ${state.message}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<BookDetailsBloc>().add(
                LoadBookDetailsEvent(bookId: widget.bookId),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

}

