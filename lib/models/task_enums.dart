import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'task_enums.g.dart';

// TASK STATUS

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  completed,
}

// TASK CATEGORY

@HiveType(typeId: 2)
enum TaskCategory {
  @HiveField(0)
  work,

  @HiveField(1)
  personal,

  @HiveField(2)
  shopping,

  @HiveField(3)
  health,

  @HiveField(4)
  other,
}

extension TaskCategoryX on TaskCategory {
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

// SORT OPTION

@HiveType(typeId: 3)
enum SortOption {
  @HiveField(0)
  dateCreated,

  @HiveField(1)
  dueDate,

  @HiveField(2)
  title,
}

extension SortOptionX on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.dateCreated:
        return 'Date Created';
      case SortOption.dueDate:
        return 'Due Date';
      case SortOption.title:
        return 'Title';
    }
  }
}
