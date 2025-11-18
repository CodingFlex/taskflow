/// Command Pattern interface for undoable operations
/// Encapsulates actions as objects that can be executed and reversed
abstract class Command {
  Future<void> execute();
  Future<void> undo();
  String get description;
}
