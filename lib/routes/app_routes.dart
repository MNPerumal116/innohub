import 'package:flutter/material.dart';

import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../layout/responsive_layout.dart';
import '../screens/attendance_history_screen.dart';
import '../screens/leave_screen.dart';
import '../screens/apply_leave_screen.dart';
import '../screens/select_date_screen.dart';
import '../screens/wfh_request_screen.dart';
import '../screens/payroll_screen.dart';
import '../screens/payslips_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login  = '/login';

  // Main shell (bottom nav tabs: Home, Attendance, Team, Profile)
  static const String homeShell = '/home';

  // Attendance
  static const String attendanceHistory = '/attendance/history';

  // Leave flow
  static const String leave = '/leave';
  static const String applyLeave = '/leave/apply';
  static const String selectDate = '/leave/select-date';

  // WFH flow
  static const String wfhRequest = '/wfh/request';

  // Payroll
  static const String payroll = '/payroll';
  static const String payslips = '/payslips';

  // Settings
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login:  (context) => const LoginScreen(),

      homeShell: (context) => const ResponsiveLayout(),

      attendanceHistory: (context) => const AttendanceHistoryScreen(),

      leave: (context) => const LeaveScreen(),
      applyLeave: (context) => const ApplyLeaveScreen(),
      wfhRequest: (context) => const WfhRequestScreen(),

      payroll: (context) => const PayrollScreen(),
      payslips: (context) => const PayslipsScreen(),

      settings: (context) => const SettingsScreen(),
    };
  }

  /// Routes that carry arguments or return a typed result.
  /// [selectDate] takes an optional [DateTimeRange] and pops a [DateTimeRange].
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    if (routeSettings.name == selectDate) {
      final range = routeSettings.arguments as DateTimeRange?;
      return MaterialPageRoute<DateTimeRange>(
        settings: routeSettings,
        builder: (_) => SelectDateScreen(
          initialStart: range?.start,
          initialEnd: range?.end,
        ),
      );
    }
    return null;
  }
}
