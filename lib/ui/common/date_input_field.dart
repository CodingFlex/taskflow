import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final double? height;
  final double? width;
  final Widget? leading;
  final Function(DateTime)? onDateSelected;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final VoidCallback? onChanged;

  static final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  const DateInputField({
    super.key,
    required this.controller,
    this.placeholder = 'Select Due Date',
    this.height,
    this.width,
    this.leading,
    this.onDateSelected,
    this.validator,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onChanged,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: AppTextStyles.heading3(context),
                    ),
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
                  minDate: minDate,
                  maxDate: maxDate,
                  selectionMode: DateRangePickerSelectionMode.single,
                  showNavigationArrow: true,
                  todayHighlightColor: kcPrimaryColor,
                  selectionColor: kcPrimaryColor,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    if (args.value is DateTime) {
                      final selectedDate = args.value as DateTime;
                      final formattedDate =
                          DateFormat('MM/dd/yyyy').format(selectedDate);

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
    return Theme(
      data: ThemeData(primaryColor: kcPrimaryColor),
      child: GestureDetector(
        onTap: () => _showDatePicker(context),
        child: SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            controller: controller,
            style: AppTextStyles.body(context).copyWith(
              overflow: TextOverflow.ellipsis,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            enabled: false,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTextStyles.body(context).copyWith(
                color: kcMediumGrey,
                fontSize: 16.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: height != null ? height! / 4 : 15,
              ),
              filled: true,
              fillColor: isDark ? kcDarkGreyColor2 : Colors.white,
              prefixIcon: leading ??
                  Icon(
                    FontAwesomeIcons.calendarDays,
                    color: isDark ? Colors.white70 : kcPrimaryColor,
                    size: 20,
                  ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        FontAwesomeIcons.xmark,
                        size: 16,
                        color: isDark ? Colors.white70 : kcMediumGrey,
                      ),
                      onPressed: () {
                        controller.clear();
                        if (onChanged != null) {
                          onChanged!();
                        }
                      },
                    )
                  : null,
              border: circularBorder.copyWith(
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.transparent
                      : kcMediumGrey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              errorBorder: circularBorder.copyWith(
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedBorder: circularBorder.copyWith(
                borderSide: const BorderSide(color: kcPrimaryColor, width: 2),
              ),
              enabledBorder: circularBorder.copyWith(
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.transparent
                      : kcMediumGrey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              errorText: validator != null ? validator!(controller.text) : null,
            ),
          ),
        ),
      ),
    );
  }
}
