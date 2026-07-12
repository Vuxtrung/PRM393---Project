import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';

// TODO: Import file FinzyTheme của bạn vào đây
// Ví dụ: import 'package:finzy/theme/finzy_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Mock data: Thông tin tĩnh bằng tiếng Việt cho các trang Onboarding
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding_1.png",
      "title": "Quản lý tài chính thông minh",
      "subtitle": "Theo dõi dòng tiền, kiểm soát chi tiêu dễ dàng và hiệu quả mỗi ngày cùng Finzy.",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Tiết kiệm cho tương lai",
      "subtitle": "Lập kế hoạch ngân sách thông minh và nhanh chóng đạt được các mục tiêu tài chính của bạn.",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Bảo mật an toàn tuyệt đối",
      "subtitle": "Dữ liệu cá nhân của bạn được mã hóa và bảo vệ hoàn toàn bằng công nghệ hiện đại nhất.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentIndex == _onboardingData.length - 1) {
      AppRoutes.replaceWith(context, AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkipPressed() {
    AppRoutes.replaceWith(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: FinzyTheme.backgroundColor, // Áp dụng màu nền từ Theme
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildPageContent(
                    image: _onboardingData[index]["image"]!,
                    title: _onboardingData[index]["title"]!,
                    subtitle: _onboardingData[index]["subtitle"]!,
                  );
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextButton(
          onPressed: _onSkipPressed,
          child: Text(
            "Bỏ qua",
            // style: FinzyTheme.bodyText.copyWith(color: FinzyTheme.textSecondary),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent({
    required String image,
    required String title,
    required String subtitle,
  }) {
    // Bọc trong SingleChildScrollView để chống overflow theo yêu cầu
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          // Placeholder cho ảnh minh họa / SVG
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50, // Màu tạm để dễ nhìn khối ảnh
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.image_outlined,
              size: 120,
              color: Colors.blue.shade200,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            // style: FinzyTheme.heading1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            // style: FinzyTheme.bodyText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dot indicators
          Row(
            children: List.generate(
              _onboardingData.length,
              (index) => _buildDotIndicator(index: index),
            ),
          ),
          // Nút Next / Get Started
          ElevatedButton(
            onPressed: _onNextPressed,
            style: ElevatedButton.styleFrom(
              // backgroundColor: FinzyTheme.primaryColor,
              backgroundColor: Colors.blueAccent, // Placeholder
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _currentIndex == _onboardingData.length - 1
                  ? "Bắt đầu"
                  : "Tiếp tục",
              // style: FinzyTheme.buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator({required int index}) {
    bool isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        // color: isActive ? FinzyTheme.primaryColor : FinzyTheme.indicatorInactive,
        color: isActive ? Colors.blueAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
