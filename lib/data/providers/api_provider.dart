import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/note_model.dart';

class ApiProvider {
  Future<List<NoteModel>> getNotes() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstants.notesUrl))
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'];
        return data.map((json) => NoteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notes: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final response = await http
          .post(
        Uri.parse(ApiConstants.notesUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(note.toJson()),
      )
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return NoteModel.fromJson(decoded['data']);
      } else {
        throw Exception('Failed to create note: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final response = await http
          .put(
        Uri.parse(ApiConstants.noteUrl(note.id!)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(note.toJson()),
      )
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return NoteModel.fromJson(decoded['data']);  // Added ['data'] here
      } else {
        throw Exception('Failed to update note: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final response = await http
          .delete(Uri.parse(ApiConstants.noteUrl(id)))
          .timeout(ApiConstants.timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete note: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}