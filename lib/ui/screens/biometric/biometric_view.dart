import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/viewmodels/biometric_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricView extends StackedView<BiometricViewModel> {
  const BiometricView({super.key});

  @override
  Widget builder(
    BuildContext context,
    BiometricViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'TaskFlow',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: kcPrimaryColor,
                    ),
                  ),
                  verticalSpaceLarge,
                  if (viewModel.isBusy)
                    const CircularProgressIndicator(color: kcPrimaryColor)
                  else if (viewModel.isBiometricsAvailable) ...[
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kcPrimaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        viewModel.hasFaceId
                            ? FontAwesomeIcons.faceSmile
                            : FontAwesomeIcons.fingerprint,
                        size: 60,
                        color: kcPrimaryColor,
                      ),
                    ),
                    verticalSpaceLarge,
                    Text(
                      'Welcome Back!',
                      style: AppTextStyles.heading2(context),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceSmall,
                    Text(
                      'Authenticate with ${viewModel.biometricTypeText} to continue',
                      style: AppTextStyles.body(context).copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceLarge,
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: viewModel.authenticate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kcPrimaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          viewModel.hasFaceId
                              ? FontAwesomeIcons.faceSmile
                              : FontAwesomeIcons.fingerprint,
                          size: 20,
                        ),
                        label: const Text(
                          'Authenticate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Icon(
                      FontAwesomeIcons.circleExclamation,
                      size: 80,
                      color: isDark ? Colors.white38 : Colors.black26,
                    ),
                    verticalSpaceLarge,
                    Text(
                      'Biometrics Not Available',
                      style: AppTextStyles.heading2(context),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceSmall,
                    Text(
                      'Your device does not support biometric authentication',
                      style: AppTextStyles.body(context).copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const Spacer(),
                  TextButton(
                    onPressed: viewModel.skipBiometrics,
                    child: Text(
                      'Skip for now',
                      style: AppTextStyles.body(context).copyWith(
                        color: kcPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (viewModel.isAuthenticating)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingFour(color: kcPrimaryColor, size: 50.0),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  BiometricViewModel viewModelBuilder(BuildContext context) =>
      BiometricViewModel();

  @override
  void onViewModelReady(BiometricViewModel viewModel) {
    viewModel.initialize();
    super.onViewModelReady(viewModel);
  }
}
