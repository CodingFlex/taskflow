import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

/// Handles biometric authentication (Face ID/Fingerprint) for the app
class BiometricsService {
  final LocalAuthentication _auth = LocalAuthentication();
  final Logger _logger = Logger();

  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      final availableBiometrics = await _auth.getAvailableBiometrics();

      _logger.i(
        'Biometrics check: canCheck=$canCheckBiometrics, '
        'deviceSupported=$isDeviceSupported, '
        'available=$availableBiometrics',
      );

      return canCheckBiometrics && availableBiometrics.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking biometrics availability', error: e);
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      _logger.e('Error getting available biometrics', error: e);
      return [];
    }
  }

  Future<bool> authenticateUser() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access TaskFlow',
      );
    } catch (e) {
      _logger.e('Error during authentication', error: e);
      return false;
    }
  }
}
