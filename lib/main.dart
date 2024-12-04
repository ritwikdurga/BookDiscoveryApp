import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Discovery App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const BookListScreen(),
    );
  }
}

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
  final Dio _dio = Dio();

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
    });
    try {
      final response = await _dio.get(
        'https://gutendex.com/books/',
        queryParameters: {
          'page': _page,
          if (_searchQuery.isNotEmpty) 'search': _searchQuery,
        },
        options: Options(
          validateStatus: (status) {
            return status! < 500;  // This will prevent Dio from throwing on 404
          },
        ),
      );

      // Handle 404 explicitly and stop fetching
      if (response.statusCode == 404) {
        print('No more books available or invalid query.');
        return; // Stop fetching if no more books
      }

      setState(() {
        _books.addAll(response.data['results']);
        _page++;
      });

    } catch (e) {
      print('Error fetching books: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    setState(() {
      _books.clear();
      _page = 1;
      _searchQuery = _searchController.text;
    });
    _fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Discovery App'),
        // STYLE TITLE
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch();
                  },
                ),
              ),
              onSubmitted: (value) => _onSearch(),
            ),
          ),
        ),
        actions: [
          // use iconsax icon here

          IconButton(
            // use iconsax icon here
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _books.clear();
                _page = 1;
                _searchQuery = '';
                _searchController.clear();
              });
              _fetchBooks();
            },
            tooltip: 'Reload Books',
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _books.length + 1,
        itemBuilder: (context, index) {
          if (index == _books.length) {
            return _isLoading
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Loading Books...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                : const SizedBox.shrink();
          }
          final book = _books[index];
          return ListTile(
            leading: Hero(
              tag: book['id'],
              child: Image.network(
                book['formats']['image/jpeg'] ?? '',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
            ),
            title: Text(
              book['title'] ?? 'No Title',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              (book['authors']?.isNotEmpty ?? false)
                  ? book['authors'][0]['name']
                  : 'Unknown Author',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
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

class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: book['id'],
                child: Image.network(
                  book['formats']['image/jpeg'] ?? '',
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 200),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book['title'] ?? 'No Title',
              style: GoogleFonts.lora(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${_getAuthors(book)}',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Genres: ${_getGenres(book)}',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Themes: ${_getThemes(book)}',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Download Options:',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ...book['formats'].entries
                .map((entry) => ListTile(
              title: Text(
                entry.key,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                entry.value ?? 'Unavailable',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ))
                .toList(),
          ],
        ),
      ),
    );
  }

  String _getAuthors(dynamic book) {
    if (book['authors']?.isNotEmpty ?? false) {
      return book['authors'][0]['name'];
    } else {
      return 'Unknown';
    }
  }

  String _getGenres(dynamic book) {
    return book['genres']?.join(', ') ?? 'Unknown';
  }

  String _getThemes(dynamic book) {
    return book['subjects']?.join(', ') ?? 'Unknown';
  }
}