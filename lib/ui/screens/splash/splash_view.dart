import 'package:flutter/material.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/viewmodels/splash_viewmodel.dart';

/// Initial splash screen with animated TaskFlow branding
class SplashView extends StackedView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedTaskflowText(),
            verticalSpaceMedium,
            const CircularProgressIndicator(
              color: kcPrimaryColor,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) {
    final viewModel = SplashViewModel();
    viewModel.initialize();
    return viewModel;
  }
}

class _AnimatedTaskflowText extends StatefulWidget {
  @override
  State<_AnimatedTaskflowText> createState() => _AnimatedTaskflowTextState();
}

class _AnimatedTaskflowTextState extends State<_AnimatedTaskflowText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Text(
              'Taskflow',
              style: GoogleFonts.nunitoSans(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
