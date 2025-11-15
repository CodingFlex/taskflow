// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i6;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i7;
import 'package:taskflow/ui/screens/home/home_view.dart' as _i2;
import 'package:taskflow/ui/screens/splash/splash_view.dart' as _i3;
import 'package:taskflow/ui/screens/statistics/statistics_view.dart' as _i5;
import 'package:taskflow/ui/screens/task_details/task_details_view.dart' as _i4;

class Routes {
  static const homeView = '/home-view';

  static const splashView = '/';

  static const taskDetailsView = '/task-details-view';

  static const statisticsView = '/statistics-view';

  static const all = <String>{
    homeView,
    splashView,
    taskDetailsView,
    statisticsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.splashView,
      page: _i3.SplashView,
    ),
    _i1.RouteDef(
      Routes.taskDetailsView,
      page: _i4.TaskDetailsView,
    ),
    _i1.RouteDef(
      Routes.statisticsView,
      page: _i5.StatisticsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.SplashView: (data) {
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.SplashView(),
        settings: data,
      );
    },
    _i4.TaskDetailsView: (data) {
      final args = data.getArgs<TaskDetailsViewArguments>(
        orElse: () => const TaskDetailsViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i4.TaskDetailsView(key: args.key, taskId: args.taskId),
        settings: data,
      );
    },
    _i5.StatisticsView: (data) {
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.StatisticsView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class TaskDetailsViewArguments {
  const TaskDetailsViewArguments({
    this.key,
    this.taskId,
  });

  final _i6.Key? key;

  final int? taskId;

  @override
  String toString() {
    return '{"key": "$key", "taskId": "$taskId"}';
  }

  @override
  bool operator ==(covariant TaskDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.taskId == taskId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ taskId.hashCode;
  }
}

extension NavigatorStateExtension on _i7.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTaskDetailsView({
    _i6.Key? key,
    int? taskId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.taskDetailsView,
        arguments: TaskDetailsViewArguments(key: key, taskId: taskId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStatisticsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.statisticsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTaskDetailsView({
    _i6.Key? key,
    int? taskId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.taskDetailsView,
        arguments: TaskDetailsViewArguments(key: key, taskId: taskId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStatisticsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.statisticsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
