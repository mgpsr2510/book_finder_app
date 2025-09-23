import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../bloc/book_details/book_details_bloc.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/responsive_wrapper.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/di/injection_container.dart' as di;
import 'book_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<SearchBloc>().add(const LoadMoreBooksEvent(limit: 10));
    }
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchBloc>().add(SearchBooksEvent(query: query.trim()));
    }
  }

  Future<void> _onRefresh() async {
    if (_searchController.text.trim().isNotEmpty) {
      context.read<SearchBloc>().add(
        SearchBooksEvent(
          query: _searchController.text.trim(),
          isRefresh: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobile(context) 
          ? AppBar(
              title: const Text('Book Finder'),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: Column(
        children: [
          // Search Bar - Full width blue container
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: ResponsiveHelper.isMobile(context)
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  : BorderRadius.circular(12),
            ),
            child: Padding(
              padding: ResponsiveHelper.getPadding(context),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for books...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchBloc>().add(const ClearSearchEvent());
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onSubmitted: _onSearch,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          // Search Results - Inside ResponsiveContainer
          Expanded(
            child: ResponsiveContainer(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildInitialState();
                  } else if (state is SearchLoading) {
                    return state.isRefresh
                        ? _buildShimmerLoading()
                        : RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: _buildShimmerLoading(),
                          );
                  } else if (state is SearchLoaded) {
                    if (state.allBooks.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildSearchResults(state);
                  } else if (state is SearchError) {
                    return _buildErrorState(state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Search for books to get started',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ResponsiveHelper.isMobile(context)
        ? const BookListShimmer()
        : _buildWrapShimmer();
  }

  Widget _buildWrapShimmer() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPadding(context),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: List.generate(6, (index) => const BookCardShimmer()),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No books found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchLoaded state) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ResponsiveHelper.isMobile(context)
          ? _buildListView(state)
          : _buildWrapView(state),
    );
  }

  Widget _buildListView(SearchLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.allBooks.length + 
          (state.searchResult.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.allBooks.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final book = state.allBooks[index];
        return BookCard(
          book: book,
          onTap: () => _navigateToBookDetails(book.id),
        );
      },
    );
  }

  Widget _buildWrapView(SearchLoaded state) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: ResponsiveHelper.getPadding(context),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ...state.allBooks.map((book) => BookCard(
            book: book,
            onTap: () => _navigateToBookDetails(book.id),
          )),
          if (state.searchResult.hasNextPage)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(SearchError state) {
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
            onPressed: _onRefresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _navigateToBookDetails(String bookId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => di.sl<BookDetailsBloc>(),
          child: BookDetailsPage(bookId: bookId),
        ),
      ),
    );
  }
}

