import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/viewmodels/statistics_viewmodel.dart';
import 'package:stacked/stacked.dart';

class StatisticsView extends StackedView<StatisticsViewModel> {
  final String? heroTag;
  final List<Task>? tasks;

  const StatisticsView({super.key, this.heroTag, this.tasks});

  @override
  Widget builder(
    BuildContext context,
    StatisticsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: kcPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: viewModel.navigateBack,
        ),
        title: const Text(
          ksStatistics,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Hero(
        tag: heroTag ?? 'statistics_button',
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Skeletonizer(
              enabled: viewModel.isBusy,
              effect: const ShimmerEffect(
                baseColor: Color(0xFFE5E7EB),
                highlightColor: Color(0xFFF6F7FB),
                duration: Duration(milliseconds: 1200),
              ),
              enableSwitchAnimation: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatsOverview(viewModel: viewModel),
                    verticalSpaceMedium,
                    _CategoryStats(viewModel: viewModel),
                    verticalSpaceMedium,
                    _CompletionChart(viewModel: viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  StatisticsViewModel viewModelBuilder(BuildContext context) =>
      StatisticsViewModel(tasks: tasks);

  @override
  void onViewModelReady(StatisticsViewModel viewModel) {
    viewModel.initialize();
    super.onViewModelReady(viewModel);
  }
}

class _StatsOverview extends StatelessWidget {
  final StatisticsViewModel viewModel;

  const _StatsOverview({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: ksTotalTasks,
            value: viewModel.totalTasks.toString(),
            icon: FontAwesomeIcons.listCheck,
            color: kcPrimaryColor,
          ),
        ),
        horizontalSpaceSmall,
        Expanded(
          child: _StatCard(
            title: ksCompletedTasks,
            value: viewModel.completedTasks.toString(),
            icon: FontAwesomeIcons.circleCheck,
            color: Colors.green,
          ),
        ),
        horizontalSpaceSmall,
        Expanded(
          child: _StatCard(
            title: ksPendingTasks,
            value: viewModel.pendingTasks.toString(),
            icon: FontAwesomeIcons.clock,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kcDarkGreyColor2 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          verticalSpaceSmall,
          Text(
            value,
            style: AppTextStyles.heading2(
              context,
            ).copyWith(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          verticalSpaceTiny,
          Text(
            title,
            style: AppTextStyles.caption(context).copyWith(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStats extends StatelessWidget {
  final StatisticsViewModel viewModel;

  const _CategoryStats({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ksTasksByCategory, style: AppTextStyles.heading3(context)),
        verticalSpaceMedium,
        ...TaskCategory.values.map((category) {
          final count = viewModel.getCategoryCount(category);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CategoryStatItem(
              category: category,
              count: count,
              total: viewModel.totalTasks,
            ),
          );
        }),
      ],
    );
  }
}

class _CategoryStatItem extends StatelessWidget {
  final TaskCategory category;
  final int count;
  final int total;

  const _CategoryStatItem({
    required this.category,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? kcDarkGreyColor2 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 3,
                child: Text(
                  category.displayName,
                  style: AppTextStyles.body(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                flex: 1,
                child: Text(
                  '$count',
                  style: AppTextStyles.heading3(context),
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: isDark ? kcDarkGreyColor : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(category.color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionChart extends StatelessWidget {
  final StatisticsViewModel viewModel;

  const _CompletionChart({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completedPercentage = viewModel.totalTasks > 0
        ? (viewModel.completedTasks / viewModel.totalTasks) * 100
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kcDarkGreyColor2 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ksCompletionRate, style: AppTextStyles.heading3(context)),
          verticalSpaceMedium,
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: completedPercentage / 100,
                    strokeWidth: 12,
                    backgroundColor: isDark
                        ? kcDarkGreyColor
                        : Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
                Text(
                  '${completedPercentage.toStringAsFixed(0)}%',
                  style: AppTextStyles.heading2(
                    context,
                  ).copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
