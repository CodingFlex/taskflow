// dart format width=80
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
    _i1.RouteDef(Routes.homeView, page: _i2.HomeView),
    _i1.RouteDef(Routes.splashView, page: _i3.SplashView),
    _i1.RouteDef(Routes.taskDetailsView, page: _i4.TaskDetailsView),
    _i1.RouteDef(Routes.statisticsView, page: _i5.StatisticsView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key),
        settings: data,
      );
    },
    _i3.SplashView: (data) {
      final args = data.getArgs<SplashViewArguments>(
        orElse: () => const SplashViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.SplashView(key: args.key),
        settings: data,
      );
    },
    _i4.TaskDetailsView: (data) {
      final args = data.getArgs<TaskDetailsViewArguments>(
        orElse: () => const TaskDetailsViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.TaskDetailsView(
          key: args.key,
          taskId: args.taskId,
          heroTag: args.heroTag,
        ),
        settings: data,
      );
    },
    _i5.StatisticsView: (data) {
      final args = data.getArgs<StatisticsViewArguments>(
        orElse: () => const StatisticsViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i5.StatisticsView(key: args.key, heroTag: args.heroTag),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class SplashViewArguments {
  const SplashViewArguments({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SplashViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class TaskDetailsViewArguments {
  const TaskDetailsViewArguments({this.key, this.taskId, this.heroTag});

  final _i6.Key? key;

  final int? taskId;

  final String? heroTag;

  @override
  String toString() {
    return '{"key": "$key", "taskId": "$taskId", "heroTag": "$heroTag"}';
  }

  @override
  bool operator ==(covariant TaskDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.taskId == taskId &&
        other.heroTag == heroTag;
  }

  @override
  int get hashCode {
    return key.hashCode ^ taskId.hashCode ^ heroTag.hashCode;
  }
}

class StatisticsViewArguments {
  const StatisticsViewArguments({this.key, this.heroTag});

  final _i6.Key? key;

  final String? heroTag;

  @override
  String toString() {
    return '{"key": "$key", "heroTag": "$heroTag"}';
  }

  @override
  bool operator ==(covariant StatisticsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.heroTag == heroTag;
  }

  @override
  int get hashCode {
    return key.hashCode ^ heroTag.hashCode;
  }
}

extension NavigatorStateExtension on _i7.NavigationService {
  Future<dynamic> navigateToHomeView({
    _i6.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.homeView,
      arguments: HomeViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSplashView({
    _i6.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.splashView,
      arguments: SplashViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToTaskDetailsView({
    _i6.Key? key,
    int? taskId,
    String? heroTag,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.taskDetailsView,
      arguments: TaskDetailsViewArguments(
        key: key,
        taskId: taskId,
        heroTag: heroTag,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStatisticsView({
    _i6.Key? key,
    String? heroTag,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.statisticsView,
      arguments: StatisticsViewArguments(key: key, heroTag: heroTag),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomeView({
    _i6.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.homeView,
      arguments: HomeViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSplashView({
    _i6.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.splashView,
      arguments: SplashViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithTaskDetailsView({
    _i6.Key? key,
    int? taskId,
    String? heroTag,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.taskDetailsView,
      arguments: TaskDetailsViewArguments(
        key: key,
        taskId: taskId,
        heroTag: heroTag,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStatisticsView({
    _i6.Key? key,
    String? heroTag,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.statisticsView,
      arguments: StatisticsViewArguments(key: key, heroTag: heroTag),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
