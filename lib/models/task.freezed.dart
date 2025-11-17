// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

@HiveField(0) int get id;@HiveField(1) String get title;@HiveField(2) String get description;@HiveField(3) TaskStatus get status;@HiveField(4) TaskCategory get category;@HiveField(5) DateTime? get dueDate;@HiveField(6) DateTime get createdAt;@HiveField(7) DateTime? get completedAt;@HiveField(8) int? get userId;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,category,dueDate,createdAt,completedAt,userId);

@override
String toString() {
  return 'Task(id: $id, title: $title, description: $description, status: $status, category: $category, dueDate: $dueDate, createdAt: $createdAt, completedAt: $completedAt, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2) String description,@HiveField(3) TaskStatus status,@HiveField(4) TaskCategory category,@HiveField(5) DateTime? dueDate,@HiveField(6) DateTime createdAt,@HiveField(7) DateTime? completedAt,@HiveField(8) int? userId
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? status = null,Object? category = null,Object? dueDate = freezed,Object? createdAt = null,Object? completedAt = freezed,Object? userId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskCategory,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)  String description, @HiveField(3)  TaskStatus status, @HiveField(4)  TaskCategory category, @HiveField(5)  DateTime? dueDate, @HiveField(6)  DateTime createdAt, @HiveField(7)  DateTime? completedAt, @HiveField(8)  int? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.category,_that.dueDate,_that.createdAt,_that.completedAt,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)  String description, @HiveField(3)  TaskStatus status, @HiveField(4)  TaskCategory category, @HiveField(5)  DateTime? dueDate, @HiveField(6)  DateTime createdAt, @HiveField(7)  DateTime? completedAt, @HiveField(8)  int? userId)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.description,_that.status,_that.category,_that.dueDate,_that.createdAt,_that.completedAt,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)  String description, @HiveField(3)  TaskStatus status, @HiveField(4)  TaskCategory category, @HiveField(5)  DateTime? dueDate, @HiveField(6)  DateTime createdAt, @HiveField(7)  DateTime? completedAt, @HiveField(8)  int? userId)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.category,_that.dueDate,_that.createdAt,_that.completedAt,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task extends Task {
  const _Task({@HiveField(0) required this.id, @HiveField(1) required this.title, @HiveField(2) this.description = '', @HiveField(3) this.status = TaskStatus.pending, @HiveField(4) this.category = TaskCategory.other, @HiveField(5) this.dueDate, @HiveField(6) required this.createdAt, @HiveField(7) this.completedAt, @HiveField(8) this.userId}): super._();
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String title;
@override@JsonKey()@HiveField(2) final  String description;
@override@JsonKey()@HiveField(3) final  TaskStatus status;
@override@JsonKey()@HiveField(4) final  TaskCategory category;
@override@HiveField(5) final  DateTime? dueDate;
@override@HiveField(6) final  DateTime createdAt;
@override@HiveField(7) final  DateTime? completedAt;
@override@HiveField(8) final  int? userId;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,category,dueDate,createdAt,completedAt,userId);

@override
String toString() {
  return 'Task(id: $id, title: $title, description: $description, status: $status, category: $category, dueDate: $dueDate, createdAt: $createdAt, completedAt: $completedAt, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2) String description,@HiveField(3) TaskStatus status,@HiveField(4) TaskCategory category,@HiveField(5) DateTime? dueDate,@HiveField(6) DateTime createdAt,@HiveField(7) DateTime? completedAt,@HiveField(8) int? userId
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? status = null,Object? category = null,Object? dueDate = freezed,Object? createdAt = null,Object? completedAt = freezed,Object? userId = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskCategory,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
