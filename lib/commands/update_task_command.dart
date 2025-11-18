import 'package:taskflow/commands/command.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';

/// Updates a task
class UpdateTaskCommand implements Command {
  final Task oldTask;
  final Task newTask;
  final TaskRepository _repository;

  UpdateTaskCommand({
    required this.oldTask,
    required this.newTask,
    required TaskRepository repository,
  }) : _repository = repository;

  @override
  Future<void> execute() async {
    await _repository.updateTask(newTask);
  }

  @override
  Future<void> undo() async {
    await _repository.updateTask(oldTask);
  }

  @override
  String get description => 'Update "${oldTask.title}"';
}
