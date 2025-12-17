class AppConstants{
  static const String apiKey = "apiKey";
  static const String baseUrl = "https://www.googleapis.com/books/v1";

  //api endpoints
  static String searchBooks(String query) => "$baseUrl/volumes?q=$query&key=$apiKey";

  static String getBooksBySubject(String subject, {int maxResults = 10}) => "$baseUrl/volumes?q=subject:$subject&maxResults=$maxResults&key=$apiKey";

  static String getTechBooks() => '$baseUrl/volumes?q=subject:Technology&maxResults=3&key=$apiKey';

  //categories
  static const List<String> categories = [
    'Technology',
    'Fiction',
    'Science',
    'History',
    'Biography',
    'Business',
    'Fantasy'
  ];

  //database
  static const String databaseName = "books.db";
  static const int databaseVersion = 1;
  static const String favouritesTable = "favourites";
}