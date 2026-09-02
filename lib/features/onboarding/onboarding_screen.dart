import 'package:flutter/material.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    _animationControllers[0].forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      title: 'Welcome to\nSmart Nagrik',
      description:
          'Together, we can make our city cleaner, safer and better for everyone.',
      imagePath: AssetConstants.onboardingWelcome,
      badgeColor: AppColors.primary,
      category: 'Civic Engagement',
    ),
    OnboardingItem(
      title: 'Report Problems',
      description:
          'Report potholes, garbage, streetlights and other civic issues instantly.',
      imagePath: AssetConstants.onboardingReport,
      badgeColor: AppColors.secondary,
      category: 'Instant Reporting',
    ),
    OnboardingItem(
      title: 'Track & Locate',
      description:
          'Track your reports and view civic issues around you on the live map.',
      imagePath: AssetConstants.onboardingTrack,
      badgeColor: Color(0xFF10B981),
      category: 'Live GIS Tracking',
    ),
    OnboardingItem(
      title: 'Emergency SOS',
      description:
          'Create emergency alerts and notify nearby Smart Nagrik users for help.',
      imagePath: AssetConstants.onboardingEmergency,
      badgeColor: AppColors.emergency,
      category: 'Community Safety',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, RouteConstants.roleSelection);
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _animationControllers[index].forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? GestureDetector(
                          onTap: _onBack,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.arrow_back_rounded,
                                    size: 16, color: AppColors.textSecondary),
                                SizedBox(width: 4),
                                Text('Back',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(width: 50),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, RouteConstants.roleSelection),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Skip',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),

            // Carousel Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final maxImgHeight = (constraints.maxHeight * 0.45).clamp(160.0, 260.0);
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Illustration Image Container with elegant shadow & border
                                Container(
                                  width: double.infinity,
                                  height: maxImgHeight,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: item.badgeColor.withValues(alpha: 0.12),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: item.badgeColor.withValues(alpha: 0.15),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      item.imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        color: item.badgeColor.withValues(alpha: 0.08),
                                        child: Center(
                                          child: Icon(Icons.image_outlined,
                                              size: 60, color: item.badgeColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Category Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.badgeColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: item.badgeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Title
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.displayMedium.copyWith(
                                    height: 1.2,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Description
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Section with Indicators and Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // Animated Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 28 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  AppButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final Color badgeColor;
  final String category;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.badgeColor,
    required this.category,
  });
}
