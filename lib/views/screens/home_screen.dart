import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/note_controller.dart';
import '../../config/routes.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/note_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchNotes(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notes.isEmpty) {
          return const LoadingWidget();
        }

        if (controller.error.value.isNotEmpty && controller.notes.isEmpty) {
          return custom.ErrorWidget(
            message: controller.error.value,
            onRetry: () => controller.fetchNotes(),
          );
        }

        if (controller.filteredNotes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  AppConstants.noNotesMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotes,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredNotes.length,
            itemBuilder: (context, index) {
              final note = controller.filteredNotes[index];
              return NoteCard(
                note: note,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.editNote,
                    arguments: note,
                  );
                },
                onDelete: () => _showDeleteDialog(context, controller, note.id!),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addNote),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, NoteController controller, String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Note'),
        content: const Text(AppConstants.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteNote(id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}