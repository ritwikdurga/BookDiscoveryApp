import 'package:flutter/material.dart';
import '../screens/book_detail_screen.dart';

class BookTile extends StatelessWidget {
  final dynamic book;

  const BookTile({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        book['formats']['image/jpeg'] ?? '',
        height: 50,
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
      ),
      title: Text(book['title'] ?? 'No Title'),
      subtitle: Text(
        (book['authors']?.isNotEmpty ?? false)
            ? book['authors'][0]['name']
            : 'Unknown Author',
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
        );
      },
    );
  }
}
