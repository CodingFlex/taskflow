import 'package:taskflow/commands/command.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';

/// Command for deleting a task with undo capability.
class DeleteTaskCommand implements Command {
  final Task deletedTask;
  final TaskRepository _repository;

  DeleteTaskCommand({
    required this.deletedTask,
    required TaskRepository repository,
  }) : _repository = repository;

  @override
  Future<void> execute() async {
    await _repository.deleteTask(deletedTask.id);
  }

  @override
  Future<void> undo() async {
    await _repository.createTask(deletedTask);
  }

  @override
  String get description => 'Delete "${deletedTask.title}"';
}
