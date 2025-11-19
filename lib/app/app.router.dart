// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i9;
import 'package:taskflow/models/task.dart' as _i8;
import 'package:taskflow/ui/screens/biometric/biometric_view.dart' as _i4;
import 'package:taskflow/ui/screens/home/home_view.dart' as _i2;
import 'package:taskflow/ui/screens/splash/splash_view.dart' as _i3;
import 'package:taskflow/ui/screens/statistics/statistics_view.dart' as _i6;
import 'package:taskflow/ui/screens/task_details/task_details_view.dart' as _i5;

class Routes {
  static const homeView = '/home-view';

  static const splashView = '/';

  static const biometricView = '/biometric-view';

  static const taskDetailsView = '/task-details-view';

  static const statisticsView = '/statistics-view';

  static const all = <String>{
    homeView,
    splashView,
    biometricView,
    taskDetailsView,
    statisticsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.homeView, page: _i2.HomeView),
    _i1.RouteDef(Routes.splashView, page: _i3.SplashView),
    _i1.RouteDef(Routes.biometricView, page: _i4.BiometricView),
    _i1.RouteDef(Routes.taskDetailsView, page: _i5.TaskDetailsView),
    _i1.RouteDef(Routes.statisticsView, page: _i6.StatisticsView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key),
        settings: data,
      );
    },
    _i3.SplashView: (data) {
      final args = data.getArgs<SplashViewArguments>(
        orElse: () => const SplashViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.SplashView(key: args.key),
        settings: data,
      );
    },
    _i4.BiometricView: (data) {
      final args = data.getArgs<BiometricViewArguments>(
        orElse: () => const BiometricViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.BiometricView(key: args.key),
        settings: data,
      );
    },
    _i5.TaskDetailsView: (data) {
      final args = data.getArgs<TaskDetailsViewArguments>(
        orElse: () => const TaskDetailsViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.TaskDetailsView(
          key: args.key,
          taskId: args.taskId,
          heroTag: args.heroTag,
          task: args.task,
          onTaskChanged: args.onTaskChanged,
        ),
        settings: data,
      );
    },
    _i6.StatisticsView: (data) {
      final args = data.getArgs<StatisticsViewArguments>(
        orElse: () => const StatisticsViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.StatisticsView(
          key: args.key,
          heroTag: args.heroTag,
          tasks: args.tasks,
        ),
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

  final _i7.Key? key;

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

  final _i7.Key? key;

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

class BiometricViewArguments {
  const BiometricViewArguments({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant BiometricViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class TaskDetailsViewArguments {
  const TaskDetailsViewArguments({
    this.key,
    this.taskId,
    this.heroTag,
    this.task,
    this.onTaskChanged,
  });

  final _i7.Key? key;

  final int? taskId;

  final String? heroTag;

  final _i8.Task? task;

  final void Function()? onTaskChanged;

  @override
  String toString() {
    return '{"key": "$key", "taskId": "$taskId", "heroTag": "$heroTag", "task": "$task", "onTaskChanged": "$onTaskChanged"}';
  }

  @override
  bool operator ==(covariant TaskDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.taskId == taskId &&
        other.heroTag == heroTag &&
        other.task == task &&
        other.onTaskChanged == onTaskChanged;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        taskId.hashCode ^
        heroTag.hashCode ^
        task.hashCode ^
        onTaskChanged.hashCode;
  }
}

class StatisticsViewArguments {
  const StatisticsViewArguments({this.key, this.heroTag, this.tasks});

  final _i7.Key? key;

  final String? heroTag;

  final List<_i8.Task>? tasks;

  @override
  String toString() {
    return '{"key": "$key", "heroTag": "$heroTag", "tasks": "$tasks"}';
  }

  @override
  bool operator ==(covariant StatisticsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.heroTag == heroTag && other.tasks == tasks;
  }

  @override
  int get hashCode {
    return key.hashCode ^ heroTag.hashCode ^ tasks.hashCode;
  }
}

extension NavigatorStateExtension on _i9.NavigationService {
  Future<dynamic> navigateToHomeView({
    _i7.Key? key,
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
    _i7.Key? key,
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

  Future<dynamic> navigateToBiometricView({
    _i7.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.biometricView,
      arguments: BiometricViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToTaskDetailsView({
    _i7.Key? key,
    int? taskId,
    String? heroTag,
    _i8.Task? task,
    void Function()? onTaskChanged,
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
        task: task,
        onTaskChanged: onTaskChanged,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStatisticsView({
    _i7.Key? key,
    String? heroTag,
    List<_i8.Task>? tasks,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.statisticsView,
      arguments: StatisticsViewArguments(
        key: key,
        heroTag: heroTag,
        tasks: tasks,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomeView({
    _i7.Key? key,
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
    _i7.Key? key,
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

  Future<dynamic> replaceWithBiometricView({
    _i7.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.biometricView,
      arguments: BiometricViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithTaskDetailsView({
    _i7.Key? key,
    int? taskId,
    String? heroTag,
    _i8.Task? task,
    void Function()? onTaskChanged,
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
        task: task,
        onTaskChanged: onTaskChanged,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStatisticsView({
    _i7.Key? key,
    String? heroTag,
    List<_i8.Task>? tasks,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.statisticsView,
      arguments: StatisticsViewArguments(
        key: key,
        heroTag: heroTag,
        tasks: tasks,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
