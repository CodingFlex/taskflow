// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/more_filters/more_filters_sheet.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';

enum BottomSheetType { notice, moreFilters }

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        NoticeSheet(request: request, completer: completer),
    BottomSheetType.moreFilters: (context, request, completer) =>
        MoreFiltersSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
