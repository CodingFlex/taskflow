import 'package:flutter/material.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/ui/screens/home/widgets/category_filter_chip.dart';
import 'package:taskflow/ui/screens/home/widgets/filter_chip_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taskflow/ui/bottom_sheets/more_filters/more_filters_sheet_model.dart';

class MoreFiltersSheet extends StackedView<MoreFiltersSheetModel> {
  final SheetRequest request;
  final Function(SheetResponse)? completer;

  const MoreFiltersSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    MoreFiltersSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          verticalSpaceLarge,
          Text(
            'More Filters',
            style: AppTextStyles.heading2(context),
          ),
          verticalSpaceLarge,
          Text(
            'SORT BY',
            style: AppTextStyles.caption(context).copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          verticalSpaceSmall,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChipWidget(
                label: 'Date Created',
                isSelected: viewModel.sortOption == SortOption.dateCreated,
                onTap: () => viewModel.setSortOption(SortOption.dateCreated),
              ),
              FilterChipWidget(
                label: 'Title (A-Z)',
                isSelected: viewModel.sortOption == SortOption.title,
                onTap: () => viewModel.setSortOption(SortOption.title),
              ),
              FilterChipWidget(
                label: 'Due Date',
                isSelected: viewModel.sortOption == SortOption.dueDate,
                onTap: () => viewModel.setSortOption(SortOption.dueDate),
              ),
            ],
          ),
          verticalSpaceLarge,
          Text(
            'CATEGORY',
            style: AppTextStyles.caption(context).copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          verticalSpaceSmall,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              CategoryFilterChip(
                category: null,
                isSelected: viewModel.selectedCategory == null,
                onTap: () => viewModel.setCategory(null),
              ),
              ...TaskCategory.values.map(
                (category) => CategoryFilterChip(
                  category: category,
                  isSelected: viewModel.selectedCategory == category,
                  onTap: () => viewModel.setCategory(category),
                ),
              ),
            ],
          ),
          verticalSpaceLarge,
        ],
      ),
    );
  }

  @override
  MoreFiltersSheetModel viewModelBuilder(BuildContext context) =>
      MoreFiltersSheetModel();
}
