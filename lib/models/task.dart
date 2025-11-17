import 'package:flutter/material.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskCategory category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    this.dueDate,
    required this.createdAt,
    this.completedAt,
  });

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate!).inDays;
  }

  int get daysUntilDue {
    if (dueDate == null || isOverdue) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'category': category.name,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      category: TaskCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TaskCategory.other,
      ),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  factory Task.fromJsonPlaceholder(Map<String, dynamic> json) {
    final completed = json['completed'] as bool? ?? false;
    final id = json['id'] as int;
    final title = json['title'] as String;
    
    return Task(
      id: id,
      title: title,
      description: json['description'] as String? ?? '',
      status: completed ? TaskStatus.completed : TaskStatus.pending,
      category: json['category'] != null
          ? TaskCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => TaskCategory.other,
            )
          : TaskCategory.other,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      completedAt: completed && json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : (completed ? DateTime.now() : null),
    );
  }

  Map<String, dynamic> toJsonPlaceholder() {
    return {
      'id': id,
      'title': title,
      'completed': status == TaskStatus.completed,
      if (description.isNotEmpty) 'description': description,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    };
  }
}

enum TaskStatus {
  pending,
  completed,
}

enum TaskCategory {
  work,
  personal,
  shopping,
  health,
  other;

  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.other:
        return 'Other';
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.work:
        return const Color(0xFF3B82F6);
      case TaskCategory.personal:
        return const Color(0xFF10B981);
      case TaskCategory.shopping:
        return const Color(0xFFF59E0B);
      case TaskCategory.health:
        return const Color(0xFFEF4444);
      case TaskCategory.other:
        return const Color(0xFF8B5CF6);
    }
  }
}

enum SortOption {
  dateCreated,
  title,
  dueDate,
}
