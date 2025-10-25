import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  final String? id; // Changed from int? to String?
  final String title;
  final String content;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  NoteModel copyWith({
    String? id, // Changed from int? to String?
    String? title,
    String? content,
    String? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
