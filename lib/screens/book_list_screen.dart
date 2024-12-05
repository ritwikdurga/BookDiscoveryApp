import 'package:flutter/material.dart';
import '../widgets/book_tile.dart';
import '../services/book_service.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _books = [];
  int _page = 1;
  bool _isLoading = false;
  String _searchQuery = '';
  bool _hasError = false;
  bool _isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchBooks();
      }
    });
  }

  Future<void> _fetchBooks() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await BookService.fetchBooks(_page, _searchQuery);
      setState(() {
        _books.addAll(results);
        _page++;
      });
    } catch (error) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearch() {
    final newQuery = _searchController.text.trim();
    if (_searchQuery == newQuery) return;
    setState(() {
      _books.clear();
      _page = 1;
      _searchQuery = newQuery;
    });
    _fetchBooks();
  }

  void _toggleSearchBar() {
    setState(() {
      if (!_isSearchBarVisible) {
        _isSearchBarVisible = true;
      }
    });
  }

  void _hideSearchBar() {
    setState(() {
      _isSearchBarVisible = false;
      _searchController.clear();
      _onSearch();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Discovery App'),
        actions: [
          // Toggle between search and clear button based on _isSearchBarVisible
          IconButton(
            icon: Icon(_isSearchBarVisible ? Icons.clear : Icons.search),
            onPressed: _isSearchBarVisible ? _hideSearchBar : _toggleSearchBar,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_isSearchBarVisible ? 56.0 : 0.0),  // Dynamically change height
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isSearchBarVisible ? 56.0 : 0.0,  // Height change animation
            curve: Curves.easeInOut,
            child: _isSearchBarVisible
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by title or author',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,  // Only clear the search field
                  ),
                ),
                onSubmitted: (_) => _onSearch(),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : (_books.isEmpty || _hasError)
          ? const Center(
        child: Text(
          'No books found',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        controller: _scrollController,
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];

          // Extract author name (default to "Unknown Author" if not available)
          final authorName = book['authors'] != null && book['authors'].isNotEmpty
              ? book['authors'][0]['name'] ?? 'Unknown Author'
              : 'Unknown Author';

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailScreen(book: book),
              ),
            ),
            child: ListTile(
              leading: Hero(
                tag: 'book-image-${book['id']}',
                child: Image.network(
                  book['formats']['image/jpeg'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
              ),
              title: Text(
                book['title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text("By $authorName"),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
