import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import '../providers/api_provider.dart';
import '../../core/constants/app_constants.dart';

class NoteRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<NoteModel>> getNotes() async {
    try {
      final notes = await _apiProvider.getNotes();
      await _cacheNotes(notes);
      return notes;
    } catch (e) {
      return await _getCachedNotes();
    }
  }

  Future<NoteModel> createNote(NoteModel note) async {
    return await _apiProvider.createNote(note);
  }

  Future<NoteModel> updateNote(NoteModel note) async {
    return await _apiProvider.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _apiProvider.deleteNote(id);
  }

  Future<void> _cacheNotes(List<NoteModel> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = notes.map((note) => note.toJson()).toList();
      await prefs.setString(
        AppConstants.cachedNotesKey,
        json.encode(notesJson),
      );
    } catch (e) {
      print('Error caching notes: $e');
    }
  }

  Future<List<NoteModel>> _getCachedNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(AppConstants.cachedNotesKey);

      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList.map((json) => NoteModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading cached notes: $e');
    }
    return [];
  }
}