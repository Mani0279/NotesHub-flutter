import 'package:get/get.dart';
import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';
import '../core/constants/app_constants.dart';

class NoteController extends GetxController {
  final NoteRepository _repository = NoteRepository();

  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  // This computed property for filtering is perfect, no changes needed.
  List<NoteModel> get filteredNotes {
    if (searchQuery.value.isEmpty) {
      return notes;
    }
    return notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          note.content.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Future<void> fetchNotes() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedNotes = await _repository.getNotes();
      notes.value = fetchedNotes;
    } catch (e) {
      error.value = e.toString();
      // Clear the list on error to avoid showing stale data.
      notes.value = [];
      Get.snackbar(
        'Error',
        AppConstants.networkErrorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNote(String title, String content) async {
    try {
      isLoading.value = true;
      error.value = '';

      final newNote = NoteModel(title: title, content: content);
      await _repository.createNote(newNote);

      Get.back(); // Navigate back first

      // Then fetch the updated list from the server.
      await fetchNotes();

      Get.snackbar(
        'Success',
        AppConstants.saveSuccessMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        AppConstants.errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repository.updateNote(note);

      Get.back(); // Navigate back first

      // Then fetch the updated list from the server.
      await fetchNotes();

      Get.snackbar(
        'Success',
        AppConstants.saveSuccessMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        AppConstants.errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      isLoading.value = true; // Show loading indicator during delete
      error.value = '';

      await _repository.deleteNote(id);

      // After successful deletion, just fetch the new list.
      // The `notes.removeWhere` is no longer needed.
      await fetchNotes();

      Get.snackbar(
        'Success',
        AppConstants.deleteSuccessMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        AppConstants.errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
