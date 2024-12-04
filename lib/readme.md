# Book Discovery App

A Flutter-based mobile application that allows users to explore books from the Gutendex API. The app includes features like search functionality, pagination for book listings, detailed book information, and download options for various formats. It is designed with a dark theme and uses popular Flutter libraries such as Dio for network requests and Google Fonts for typography.

## Features

- **Book Search**: Users can search for books by title or author.
- **Infinite Scrolling**: The app supports pagination, fetching books as the user scrolls.
- **Detailed Book Information**: Users can view detailed information about books, including authors, genres, themes, and download options.
- **Download Formats**: Books are available in multiple formats for download.

## Code Structure

The code is organized into the following main sections:

1. **`main.dart`**: The entry point of the app. It initializes the app and sets the app's theme, home screen, and navigation.

2. **`BookApp`**: A `StatelessWidget` that sets up the app's overall design, including the app's theme and `BookListScreen` as the home screen.

3. **`BookListScreen`**: A `StatefulWidget` that displays a list of books fetched from the Gutendex API. It includes:
    - A `TextField` for searching books by title or author.
    - Pagination logic to load more books as the user scrolls.
    - A `ListView.builder` to display the list of books with pagination.

4. **`BookDetailScreen`**: A `StatelessWidget` that shows detailed information about a selected book. This includes:
    - Hero animations for smooth image transitions.
    - Information like the title, author, genres, themes, and available download options.

5. **`Dio` for Networking**: Used for making network requests to the Gutendex API and fetching book data. The app supports handling 404 errors gracefully when no more books are available.

6. **`Google Fonts`**: Used to enhance typography throughout the app for a more aesthetically pleasing design.

## Design Choices

- **Theme**: The app uses a dark theme to provide a modern and visually comfortable experience for users, especially during low-light conditions.

- **Infinite Scrolling**: Infinite scrolling is implemented to improve performance and user experience. As the user scrolls to the bottom, more books are automatically fetched, preventing long waiting times for the user.

- **Hero Animation**: A smooth image transition between the book list and the detail screen is achieved using the `Hero` widget, which enhances the user experience when navigating between screens.

- **Search Functionality**: The search bar allows users to filter books by title or author. The results are updated dynamically when a search term is entered or cleared.

## Dependencies

- `flutter`: The Flutter framework used to build the app.
- `dio`: A powerful HTTP client for Dart that is used to make network requests to the Gutendex API.
- `google_fonts`: A package to use custom fonts in the app, improving the overall typography and visual appeal.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/book-discovery-app.git
cd book-discovery-app
```

### 2. Install dependencies
Make sure you have Flutter installed. If not, follow the installation guide on the official Flutter website.
```bash
flutter pub get
```

### 3. Run the app
After installing dependencies, you can run the app on your emulator or physical device:
```bash
flutter run
```

## API Documentation

This app fetches book data from the Gutendex API. The API provides metadata on a wide range of books in the public domain, including details like title, authors, genres, themes, and formats for download. The app queries the following endpoints:

### Search Books
- **Endpoint**: `https://gutendex.com/books/`
- **Parameters**: `search`, `page`, `page_size`
- **Example Request**: `https://gutendex.com/books/?search=flutter&page=1&page_size=10`

### Book Detail
- **Endpoint**: `https://gutendex.com/books/{book_id}/`
- **Example Request**: `https://gutendex.com/books/12345/`

## Contributing

Contributions are welcome! If you find any bugs or want to suggest improvements, please feel free to create an issue or a pull request. You can follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add your feature'`).
5. Push to the branch (`git push origin feature/your-feature`).
6. Create a new pull request.