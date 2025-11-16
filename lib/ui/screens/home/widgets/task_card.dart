import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = task.status == TaskStatus.completed;

    return Hero(
      tag: 'task_${task.id}',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? kcDarkGreyColor2 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: task.category.color,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onToggleComplete,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? Colors.green
                            : (isDark ? Colors.white38 : Colors.black26),
                        width: 2,
                      ),
                      color: isCompleted ? Colors.green : Colors.transparent,
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                horizontalSpaceSmall,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTextStyles.heading3(context).copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isCompleted
                              ? (isDark ? Colors.white54 : Colors.black54)
                              : null,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        verticalSpaceTiny,
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body(context).copyWith(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                      verticalSpaceSmall,
                      Row(
                        children: [
                          _CategoryTag(category: task.category),
                          horizontalSpaceSmall,
                          if (isCompleted && task.completedAt != null)
                            _CompletedTag(completedAt: task.completedAt!)
                          else if (!isCompleted && task.dueDate != null)
                            _DueDateTag(
                              task: task,
                              isOverdue: task.isOverdue,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (task.isOverdue)
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    color: Colors.red,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final TaskCategory category;

  const _CategoryTag({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.tag,
            size: 10,
            color: category.color,
          ),
          const SizedBox(width: 4),
          Text(
            category.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DueDateTag extends StatelessWidget {
  final Task task;
  final bool isOverdue;

  const _DueDateTag({
    required this.task,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (isOverdue) {
      text = '${task.daysOverdue}d overdue';
      color = Colors.red;
    } else if (task.daysUntilDue == 0) {
      text = 'Due today';
      color = Colors.orange;
    } else if (task.daysUntilDue == 1) {
      text = 'Due tomorrow';
      color = Colors.orange;
    } else {
      text = '${task.daysUntilDue}d left';
      color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.calendar,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedTag extends StatelessWidget {
  final DateTime completedAt;

  const _CompletedTag({required this.completedAt});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(completedAt);
    String text;

    if (difference.inDays == 0) {
      text = 'Completed today';
    } else if (difference.inDays == 1) {
      text = 'Completed yesterday';
    } else if (difference.inDays < 7) {
      text = 'Completed ${difference.inDays}d ago';
    } else {
      final months = (difference.inDays / 30).floor();
      if (months == 0) {
        final weeks = (difference.inDays / 7).floor();
        text = 'Completed ${weeks}w ago';
      } else if (months == 1) {
        text = 'Completed 1mo ago';
      } else {
        text = 'Completed ${months}mo ago';
      }
    }

    const color = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            FontAwesomeIcons.check,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
