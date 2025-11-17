// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final typeId = 1;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.pending;
      case 1:
        return TaskStatus.completed;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.pending:
        writer.writeByte(0);
      case TaskStatus.completed:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskCategoryAdapter extends TypeAdapter<TaskCategory> {
  @override
  final typeId = 2;

  @override
  TaskCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskCategory.work;
      case 1:
        return TaskCategory.personal;
      case 2:
        return TaskCategory.shopping;
      case 3:
        return TaskCategory.health;
      case 4:
        return TaskCategory.other;
      default:
        return TaskCategory.work;
    }
  }

  @override
  void write(BinaryWriter writer, TaskCategory obj) {
    switch (obj) {
      case TaskCategory.work:
        writer.writeByte(0);
      case TaskCategory.personal:
        writer.writeByte(1);
      case TaskCategory.shopping:
        writer.writeByte(2);
      case TaskCategory.health:
        writer.writeByte(3);
      case TaskCategory.other:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortOptionAdapter extends TypeAdapter<SortOption> {
  @override
  final typeId = 3;

  @override
  SortOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortOption.dateCreated;
      case 1:
        return SortOption.dueDate;
      case 2:
        return SortOption.title;
      default:
        return SortOption.dateCreated;
    }
  }

  @override
  void write(BinaryWriter writer, SortOption obj) {
    switch (obj) {
      case SortOption.dateCreated:
        writer.writeByte(0);
      case SortOption.dueDate:
        writer.writeByte(1);
      case SortOption.title:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
