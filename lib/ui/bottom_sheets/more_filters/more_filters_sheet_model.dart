import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:stacked_services/stacked_services.dart';

class MoreFiltersSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  SortOption _sortOption;
  TaskCategory? _selectedCategory;

  MoreFiltersSheetModel({
    SortOption? initialSortOption,
    TaskCategory? initialCategory,
  }) : _sortOption = initialSortOption ?? SortOption.dueDate,
       _selectedCategory = initialCategory;

  SortOption get sortOption => _sortOption;
  TaskCategory? get selectedCategory => _selectedCategory;

  void setSortOption(SortOption option) {
    _sortOption = option;
    rebuildUi();
    _applyAndClose();
  }

  void setCategory(TaskCategory? category) {
    _selectedCategory = category;
    rebuildUi();
    _applyAndClose();
  }

  void _applyAndClose() {
    _bottomSheetService.completeSheet(
      SheetResponse(
        confirmed: true,
        data: {'sortOption': _sortOption, 'category': _selectedCategory},
      ),
    );
  }
}
