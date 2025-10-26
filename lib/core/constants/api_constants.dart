class ApiConstants {
  static const String baseUrl = 'http://ec2-18-61-62-208.ap-south-2.compute.amazonaws.com:3000';
  static const String notes = '/notes';

  static String get notesUrl => '$baseUrl$notes';
  static String noteUrl(String id) => '$baseUrl$notes/$id'; // Changed to String

  static const Duration timeout = Duration(seconds: 30);
}
