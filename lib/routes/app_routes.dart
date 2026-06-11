import 'package:flutter/material.dart';
import 'package:finzy/screens/forgot_password_screen.dart';
import 'package:finzy/screens/login_screen.dart';
import 'package:finzy/screens/register_screen.dart';
import 'package:finzy/screens/splash_screen.dart';
import 'package:finzy/screens/onboarding_screen.dart';
import 'package:finzy/screens/main_shell.dart';
// Sub-screens navigated via push (not named routes)
import 'package:finzy/screens/add_transaction_screen.dart';
import 'package:finzy/screens/transaction_detail_screen.dart';
import 'package:finzy/screens/category_breakdown_screen.dart';
import 'package:finzy/screens/savings_goals_screen.dart';
import 'package:finzy/screens/goal_detail_screen.dart';
import 'package:finzy/screens/add_money_to_goal_screen.dart';
import 'package:finzy/screens/create_new_goal_screen.dart';
import 'package:finzy/screens/goal_complete_screen.dart';
import 'package:finzy/screens/profile_screen.dart';
import 'package:finzy/screens/manage_categories_screen.dart';
import 'package:finzy/screens/notification_settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  // ── Named routes ──────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  /// Root shell with BottomNavigationBar (tabs: Home, Giao dịch, Thống kê, Heo, Tôi)
  static const String shell = '/shell';

  // Sub-screen named routes (push style)
  static const String addTransaction = '/add-transaction';
  static const String transactionDetail = '/transaction-detail';
  static const String categoryBreakdown = '/category-breakdown';
  static const String savingsGoals = '/savings-goals';
  // static const String goalDetail = '/goal-detail'; // Sử dụng MaterialPageRoute
  static const String addMoneyToGoal = '/add-money-to-goal';
  static const String createGoal = '/create-goal';
  static const String goalComplete = '/goal-complete';
  static const String profile = '/profile';
  static const String manageCategories = '/manage-categories';
  static const String notificationSettings = '/notification-settings';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        forgotPassword: (_) => const ForgotPasswordScreen(),
        shell: (_) => const MainShell(),
        addTransaction: (_) => const AddTransactionScreen(),
        transactionDetail: (_) => const TransactionDetailScreen(),
        categoryBreakdown: (_) => const CategoryBreakdownScreen(),
        savingsGoals: (_) => const SavingsGoalsScreen(),
        // goalDetail: (_) => GoalDetailScreen(...), // Truyền dữ liệu trực tiếp qua constructor
        addMoneyToGoal: (_) => const AddMoneyToGoalScreen(),
        createGoal: (_) => const CreateNewGoalScreen(),
        goalComplete: (_) => const GoalCompleteScreen(),
        profile: (_) => const ProfileScreen(),
        manageCategories: (_) => const ManageCategoriesScreen(),
        notificationSettings: (_) => const NotificationSettingsScreen(),
      };

  // ── Navigation helpers ────────────────────────────────────────────────────

  /// Chuyển màn và không cho quay lại.
  static Future<void> replaceWith(BuildContext context, String route) {
    return Navigator.of(context).pushReplacementNamed(route);
  }

  /// Xóa toàn bộ stack và chuyển đến route mới.
  static Future<void> replaceAll(BuildContext context, String route) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (r) => false);
  }

  /// Mở màn mới, vẫn có thể quay lại.
  static Future<void> push(BuildContext context, String route) {
    return Navigator.of(context).pushNamed(route);
  }

  /// Quay lại màn trước.
  static void pop(BuildContext context) => Navigator.of(context).pop();
}
