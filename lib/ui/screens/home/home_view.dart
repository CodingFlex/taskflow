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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: kcPrimaryColor,
        elevation: 0,
        title: Text(
          'TaskFlow',
          style: GoogleFonts.nunitoSans(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chartBar,
                color: Colors.white,
                size: 18,
              ),
              onPressed: viewModel.navigateToStatistics,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
                color: Colors.white,
                size: 18,
              ),
              onPressed: viewModel.toggleTheme,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: viewModel.refreshTasks,
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
              ? _ErrorView(
                  message: viewModel.errorMessage!,
                  onRetry: viewModel.loadTasks,
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'statistics_view',
                        child: Material(
                          color: Colors.transparent,
                          child: SearchField(
                            controller: viewModel.searchController,
                            hintText: 'Search tasks...',
                            onChanged: viewModel.onSearchChanged,
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      _FilterSection(viewModel: viewModel),
                      verticalSpaceMedium,
                      _TasksSection(viewModel: viewModel),
                      const Hero(
                        tag: 'add_task_fab',
                        child: Material(
                          color: Colors.transparent,
                          child: SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
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

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.initialize();
    super.onViewModelReady(viewModel);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.triangleExclamation,
              size: 64,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white38
                  : Colors.black26,
            ),
            verticalSpaceMedium,
            Text(
              message,
              style: AppTextStyles.body(context).copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpaceMedium,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kcPrimaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
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
          style: AppTextStyles.caption(
            context,
          ).copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
