import 'package:logger/logger.dart';
import 'package:taskflow/commands/command.dart';
import 'package:taskflow/helpers/logger_helper.dart';

/// Manages command history and provides undo functionality
/// Keeps last 5 operations in memory (not persistent across restarts)
class CommandManager {
  final Logger _logger = createLogger();
  final List<Command> _history = [];
  static const int _maxHistorySize = 5;

  Future<void> executeCommand(Command command) async {
    _logger.i('Executing command: ${command.description}');
    await command.execute();
    _history.add(command);
    _logger.i('Command added to history. History size: ${_history.length}');

    while (_history.length > _maxHistorySize) {
      final removed = _history.removeAt(0);
      _logger.d('Removed oldest command from history: ${removed.description}');
    }
  }

  Future<bool> undo() async {
    if (_history.isEmpty) {
      _logger.w('Undo called but history is empty');
      return false;
    }

    final command = _history.removeLast();
    _logger.i('Undoing command: ${command.description}');

    try {
      await command.undo();
      _logger.i('Undo successful. History size: ${_history.length}');
      return true;
    } catch (e, stackTrace) {
      _logger.e(
        'Undo failed for: ${command.description}',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  bool get canUndo => _history.isNotEmpty;
  String? get nextUndoDescription =>
      _history.isEmpty ? null : _history.last.description;

  void clearHistory() {
    _logger.i('Clearing command history (${_history.length} commands)');
    _history.clear();
  }

  int get historySize => _history.length;
}
