import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/ui/common/search_field.dart';
import 'package:taskflow/ui/screens/home/widgets/task_card.dart';
import 'package:taskflow/ui/screens/home/widgets/filter_chip_widget.dart';
import 'package:taskflow/viewmodels/home_viewmodel.dart'
    show HomeViewModel, TaskFilter;
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _HeaderSection(
              onThemeToggle: viewModel.toggleTheme,
              onStatisticsTap: viewModel.navigateToStatistics,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchField(
                      controller: viewModel.searchController,
                      hintText: 'Search tasks...',
                      onChanged: viewModel.onSearchChanged,
                    ),
                    verticalSpaceMedium,
                    _FilterSection(viewModel: viewModel),
                    verticalSpaceMedium,
                    _TasksSection(viewModel: viewModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.navigateToAddTask,
        backgroundColor: kcPrimaryColor,
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class _HeaderSection extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onStatisticsTap;

  const _HeaderSection({
    required this.onThemeToggle,
    required this.onStatisticsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: kcPrimaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: kcPrimaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TaskFlow',
            style: GoogleFonts.nunitoSans(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onStatisticsTap,
                  icon: const Icon(
                    FontAwesomeIcons.chartBar,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onThemeToggle,
                  icon: Icon(
                    isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final HomeViewModel viewModel;

  const _FilterSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTER BY',
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        verticalSpaceSmall,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChipWidget(
                label: 'All',
                isSelected: viewModel.selectedFilter == TaskFilter.all,
                onTap: () => viewModel.setFilter(TaskFilter.all),
              ),
              horizontalSpaceSmall,
              FilterChipWidget(
                label: 'Completed',
                isSelected: viewModel.selectedFilter == TaskFilter.completed,
                onTap: () => viewModel.setFilter(TaskFilter.completed),
              ),
              horizontalSpaceSmall,
              FilterChipWidget(
                label: 'Pending',
                isSelected: viewModel.selectedFilter == TaskFilter.pending,
                onTap: () => viewModel.setFilter(TaskFilter.pending),
              ),
              horizontalSpaceSmall,
              FilterChipWidget(
                label: 'More',
                isSelected: false,
                onTap: viewModel.showMoreFilters,
                icon: FontAwesomeIcons.filter,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TasksSection extends StatelessWidget {
  final HomeViewModel viewModel;

  const _TasksSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final filteredTasks = viewModel.filteredTasks;
    final overdueTasks = filteredTasks.where((t) => t.isOverdue).toList();
    final otherTasks = filteredTasks.where((t) => !t.isOverdue).toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 64,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white38
                  : Colors.black26,
            ),
            verticalSpaceMedium,
            Text(
              'No tasks found',
              style: AppTextStyles.body(context).copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (overdueTasks.isNotEmpty) ...[
          _SectionHeader(
            icon: FontAwesomeIcons.circleExclamation,
            title: 'OVERDUE (${overdueTasks.length})',
            color: Colors.red,
          ),
          verticalSpaceSmall,
          ...overdueTasks.map(
            (task) => TaskCard(
              task: task,
              onTap: () => viewModel.navigateToTaskDetails(task),
              onToggleComplete: () => viewModel.toggleTaskComplete(task),
            ),
          ),
          verticalSpaceMedium,
        ],
        if (otherTasks.isNotEmpty) ...[
          ...otherTasks.map(
            (task) => TaskCard(
              task: task,
              onTap: () => viewModel.navigateToTaskDetails(task),
              onToggleComplete: () => viewModel.toggleTaskComplete(task),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        horizontalSpaceSmall,
        Text(
          title,
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
