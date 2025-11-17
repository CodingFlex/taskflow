import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'task_enums.dart';

export 'task_enums.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
@HiveType(typeId: 0)
abstract class Task with _$Task {
  const Task._();

  const factory Task({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) @Default('') String description,
    @HiveField(3) @Default(TaskStatus.pending) TaskStatus status,
    @HiveField(4) @Default(TaskCategory.other) TaskCategory category,
    @HiveField(5) DateTime? dueDate,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) DateTime? completedAt,
    @HiveField(8) int? userId,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  factory Task.fromJsonPlaceholder(Map<String, dynamic> json) {
    final completed = json['completed'] as bool? ?? false;

    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      status: completed ? TaskStatus.completed : TaskStatus.pending,
      category: TaskCategory.other,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: completed ? DateTime.now() : null,
      userId: json['userId'] as int?,
    );
  }

  Map<String, dynamic> toJsonPlaceholder() => {
    'id': id,
    'title': title,
    'completed': completed,
    if (description.isNotEmpty) 'description': description,
    if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
  };

  bool get completed => status == TaskStatus.completed;

  bool get isOverdue {
    if (dueDate == null || completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  int get daysOverdue =>
      isOverdue ? DateTime.now().difference(dueDate!).inDays : 0;

  int get daysUntilDue {
    if (dueDate == null || isOverdue) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  int get ageInDays => DateTime.now().difference(createdAt).inDays;

  String get formattedDate {
    final diff = DateTime.now().difference(createdAt);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
