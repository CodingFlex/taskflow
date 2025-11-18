import 'package:local_auth/local_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:taskflow/services/biometrics_service.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:stacked_services/stacked_services.dart';

class BiometricViewModel extends BaseViewModel {
  final _biometricsService = locator<BiometricsService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  bool _isBiometricsAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  bool _isAuthenticating = false;

  bool get isBiometricsAvailable => _isBiometricsAvailable;
  List<BiometricType> get availableBiometrics => _availableBiometrics;
  bool get isAuthenticating => _isAuthenticating;

  bool get hasFaceId => _availableBiometrics.contains(BiometricType.face);
  bool get hasFingerprint =>
      _availableBiometrics.contains(BiometricType.fingerprint);

  String get biometricTypeText {
    if (hasFaceId) return 'Face ID';
    if (hasFingerprint) return 'Fingerprint';
    return 'Biometric';
  }

  Future<void> initialize() async {
    setBusy(true);
    _isBiometricsAvailable = await _biometricsService.isBiometricsAvailable();

    if (_isBiometricsAvailable) {
      _availableBiometrics = await _biometricsService.getAvailableBiometrics();
    }
    setBusy(false);

    // Auto-trigger authentication if biometrics is available
    if (_isBiometricsAvailable) {
      await Future.delayed(const Duration(milliseconds: 500));
      await authenticate();
    }
  }

  Future<void> authenticate() async {
    if (!_isBiometricsAvailable) {
      _skipAuthentication();
      return;
    }

    _isAuthenticating = true;
    notifyListeners();

    final success = await _biometricsService.authenticateUser();

    _isAuthenticating = false;
    notifyListeners();

    if (success) {
      _navigationService.replaceWithHomeView();
    } else {
      _toastService.showError(
        message: 'Authentication failed. Please try again.',
      );
    }
  }

  void _skipAuthentication() {
    _navigationService.replaceWithHomeView();
  }

  void skipBiometrics() {
    _skipAuthentication();
  }
}
