import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:stacked_services/stacked_services.dart';

class MoreFiltersSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  SortOption _sortOption = SortOption.dueDate;
  TaskCategory? _selectedCategory;

  SortOption get sortOption => _sortOption;
  TaskCategory? get selectedCategory => _selectedCategory;

  void setSortOption(SortOption option) {
    _sortOption = option;
    rebuildUi();
  }

  void setCategory(TaskCategory? category) {
    _selectedCategory = category;
    rebuildUi();
  }

  void close() {
    _bottomSheetService.completeSheet(SheetResponse());
  }
}
