import 'package:get/get.dart';
import '../views/screens/splash_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/add_edit_note_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String addNote = '/add-note';
  static const String editNote = '/edit-note';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: addNote,
      page: () => const AddEditNoteScreen(),
    ),
    GetPage(
      name: editNote,
      page: () => const AddEditNoteScreen(),
    ),
  ];
}