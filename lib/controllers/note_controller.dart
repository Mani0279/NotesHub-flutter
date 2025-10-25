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
      notes.value = [];
      Get.snackbar(
        'Error',
        _getErrorMessage(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Updated to accept NoteModel instead of individual parameters
  Future<void> addNote(NoteModel note) async {
    if (note.title.trim().isEmpty || note.content.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Title and content cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final createdNote = await _repository.createNote(note);

      // Verify the created note has an ID
      if (createdNote.id != null) {
        Get.back(); // Navigate back after successful creation
        await fetchNotes(); // Refresh the list

        Get.snackbar(
          'Success',
          AppConstants.saveSuccessMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception('Created note has no ID');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        _getErrorMessage(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNote(NoteModel note) async {
    // Validate that the note has an ID
    if (note.id == null || note.id!.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot update note without ID',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate content
    if (note.title.trim().isEmpty || note.content.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Title and content cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      await _repository.updateNote(note);

      Get.back(); // Navigate back after successful update
      await fetchNotes(); // Refresh the list

      Get.snackbar(
        'Success',
        'Note updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        _getErrorMessage(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNote(String id) async {
    if (id.isEmpty) {
      Get.snackbar(
        'Error',
        'Invalid note ID',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      await _repository.deleteNote(id);
      await fetchNotes(); // Refresh the list after deletion

      Get.snackbar(
        'Success',
        AppConstants.deleteSuccessMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        _getErrorMessage(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Helper method to provide user-friendly error messages
  String _getErrorMessage(String error) {
    if (error.contains('No internet connection')) {
      return 'No internet connection. Please check your network.';
    } else if (error.contains('Network error')) {
      return 'Network error. Please try again.';
    } else if (error.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else if (error.contains('Failed to load notes')) {
      return 'Failed to load notes. Please try again.';
    } else if (error.contains('Failed to create note')) {
      return 'Failed to create note. Please try again.';
    } else if (error.contains('Failed to update note')) {
      return 'Failed to update note. Please try again.';
    } else if (error.contains('Failed to delete note')) {
      return 'Failed to delete note. Please try again.';
    }
    return AppConstants.errorMessage;
  }

  // Optional: Add a method to clear error state
  void clearError() {
    error.value = '';
  }

  // Optional: Add a method to refresh without loading indicator
  Future<void> silentRefresh() async {
    try {
      error.value = '';
      final fetchedNotes = await _repository.getNotes();
      notes.value = fetchedNotes;
    } catch (e) {
      error.value = e.toString();
    }
  }
}