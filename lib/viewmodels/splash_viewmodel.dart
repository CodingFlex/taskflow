import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:taskflow/services/biometrics_service.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _biometricsService = locator<BiometricsService>();

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 3));

    final isBiometricsAvailable = await _biometricsService
        .isBiometricsAvailable();

    if (isBiometricsAvailable) {
      _navigationService.replaceWithBiometricView();
    } else {
      _navigationService.replaceWithHomeView();
    }
  }
}
