import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/ui/screens/home/widgets/task_card.dart';
import 'package:taskflow/viewmodels/home_viewmodel.dart';

/// Paginated task list widget that loads tasks page by page with a "Load More" button.
class PaginatedTaskList extends StatefulWidget {
  final HomeViewModel viewModel;
  static const int pageSize = 10; // Small page size to see pagination easily

  const PaginatedTaskList({super.key, required this.viewModel});

  @override
  State<PaginatedTaskList> createState() => _PaginatedTaskListState();
}

class _PaginatedTaskListState extends State<PaginatedTaskList> {
  final List<Task> _loadedTasks = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await widget.viewModel.getTasksPaginated(
        page: 0,
        pageSize: PaginatedTaskList.pageSize,
      );

      setState(() {
        _loadedTasks.clear();
        _loadedTasks.addAll(result.tasks);
        _currentPage = 0;
        _hasMore = result.hasMore;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final result = await widget.viewModel.getTasksPaginated(
        page: _currentPage + 1,
        pageSize: PaginatedTaskList.pageSize,
      );

      setState(() {
        _loadedTasks.addAll(result.tasks);
        _currentPage++;
        _hasMore = result.hasMore;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedTasks.isEmpty && _isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loadedTasks.isEmpty && _error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              size: 48,
              color: Colors.red,
            ),
            verticalSpaceMedium,
            Text(_error!, textAlign: TextAlign.center),
            verticalSpaceMedium,
            ElevatedButton.icon(
              onPressed: _loadFirstPage,
              icon: const Icon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_loadedTasks.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
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
                ksNoTasksFound,
                style: AppTextStyles.body(context).copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Task count indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: kcPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                FontAwesomeIcons.listCheck,
                size: 14,
                color: kcPrimaryColor,
              ),
              horizontalSpaceSmall,
              Text(
                'Loaded ${_loadedTasks.length} tasks',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: kcPrimaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        verticalSpaceMedium,

        // Task list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _loadedTasks.length,
          separatorBuilder: (context, index) => verticalSpaceSmall,
          itemBuilder: (context, index) {
            final task = _loadedTasks[index];
            return TaskCard(
              task: task,
              onTap: () => widget.viewModel.navigateToTaskDetails(task),
              onToggleComplete: () => widget.viewModel.toggleTaskComplete(task),
            );
          },
        ),

        // Load more button or loading indicator
        if (_hasMore || _isLoading) ...[
          verticalSpaceMedium,
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading more tasks...'),
                ],
              ),
            )
          else
            Center(
              child: OutlinedButton.icon(
                onPressed: _loadNextPage,
                icon: const Icon(FontAwesomeIcons.arrowDown, size: 14),
                label: const Text('Load More'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kcPrimaryColor,
                  side: const BorderSide(color: kcPrimaryColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
        ],

        if (!_hasMore && _loadedTasks.isNotEmpty) ...[
          verticalSpaceMedium,
          Center(
            child: Text(
              'All tasks loaded',
              style: AppTextStyles.caption(context).copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
