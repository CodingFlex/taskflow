// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: (fields[0] as num).toInt(),
      title: fields[1] as String,
      description: fields[2] == null ? '' : fields[2] as String,
      status: fields[3] == null ? TaskStatus.pending : fields[3] as TaskStatus,
      category: fields[4] == null
          ? TaskCategory.other
          : fields[4] as TaskCategory,
      dueDate: fields[5] as DateTime?,
      createdAt: fields[6] as DateTime,
      completedAt: fields[7] as DateTime?,
      userId: (fields[8] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.completedAt)
      ..writeByte(8)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.pending,
  category:
      $enumDecodeNullable(_$TaskCategoryEnumMap, json['category']) ??
      TaskCategory.other,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  userId: (json['userId'] as num?)?.toInt(),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'category': _$TaskCategoryEnumMap[instance.category]!,
  'dueDate': instance.dueDate?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'userId': instance.userId,
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.completed: 'completed',
};

const _$TaskCategoryEnumMap = {
  TaskCategory.work: 'work',
  TaskCategory.personal: 'personal',
  TaskCategory.shopping: 'shopping',
  TaskCategory.health: 'health',
  TaskCategory.other: 'other',
};
