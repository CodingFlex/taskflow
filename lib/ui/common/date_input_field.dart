import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final double? height;
  final double? width;
  final Function(DateTime)? onDateSelected;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final VoidCallback? onChanged;
  final double borderRadius;

  const DateInputField({
    super.key,
    required this.controller,
    this.placeholder = 'Select Due Date',
    this.height,
    this.width,
    this.onDateSelected,
    this.validator,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onChanged,
    this.borderRadius = 26,
  });

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? kcDarkGreyColor
                : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: kcMediumGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Date', style: AppTextStyles.heading3(context)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Done',
                        style: AppTextStyles.body(context).copyWith(
                          color: kcPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SfDateRangePicker(
                  initialSelectedDate: initialDate ?? DateTime.now(),
                  minDate:
                      minDate ??
                      DateTime.now().copyWith(
                        hour: 0,
                        minute: 0,
                        second: 0,
                        millisecond: 0,
                        microsecond: 0,
                      ),
                  maxDate: maxDate,
                  selectionMode: DateRangePickerSelectionMode.single,
                  showNavigationArrow: true,
                  todayHighlightColor: kcPrimaryColor,
                  selectionColor: kcPrimaryColor,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is DateTime) {
                          final selectedDate = args.value as DateTime;
                          final formattedDate = DateFormat(
                            'MM/dd/yyyy',
                          ).format(selectedDate);

                          controller.text = formattedDate;

                          if (onDateSelected != null) {
                            onDateSelected!(selectedDate);
                          }

                          Navigator.pop(context);
                        }
                      },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasDate = controller.text.isNotEmpty;

    return Theme(
      data: ThemeData(primaryColor: kcPrimaryColor),
      child: GestureDetector(
        onTap: () => _showDatePicker(context),
        child: Container(
          height: height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: const BoxConstraints(minWidth: 0),
          decoration: BoxDecoration(
            color: isDark ? kcDarkGreyColor2 : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.calendarDays,
                color: isDark ? Colors.white70 : kcPrimaryColor,
                size: 18,
              ),
              horizontalSpaceSmall,
              Flexible(
                child: Text(
                  hasDate ? controller.text : placeholder,
                  style: AppTextStyles.body(context).copyWith(
                    fontSize: 14.sp,
                    color: hasDate
                        ? (isDark ? Colors.white : Colors.black87)
                        : kcMediumGrey,
                    fontWeight: hasDate ? FontWeight.w500 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
