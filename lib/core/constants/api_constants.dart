class ApiConstants {
  static const String baseUrl = 'https://my-express-notes-app.onrender.com';
  static const String notes = '/notes';

  static String get notesUrl => '$baseUrl$notes';
  static String noteUrl(String id) => '$baseUrl$notes/$id'; // Changed to String

  static const Duration timeout = Duration(seconds: 30);
}
