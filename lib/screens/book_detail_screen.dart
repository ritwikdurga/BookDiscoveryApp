import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // change the size of the back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          onPressed: () => Navigator.pop(context),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            book['title'] ?? 'Book Details',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'book-image-${book['id']}',
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
              style: GoogleFonts.firaCode(
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
                .map(
                  (entry) => ListTile(
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
              ),
            )
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
