import 'package:billionlabs_assignment/screens/book_list_screen.dart';
import 'package:flutter/material.dart';
import 'themes/app_theme.dart';

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
      theme: AppTheme.darkTheme,
      home: const BookListScreen(),
    );
  }
}
