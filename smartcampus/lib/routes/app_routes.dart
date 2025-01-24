import 'package:get/get.dart';
import 'package:smartcampus/views/register_view.dart';
import '../views/login_view.dart';
import '../views/profile_view.dart';
import '../views/edit_profile_view.dart';
import '../views/schedule_view.dart';
import '../views/notification_view.dart';
import '../views/home_view.dart';
import '../views/academic_performance_page.dart';
import '../views/facility_usage_page.dart';
import '../views/report_generator_page.dart';
import '../views/financial_overview_page.dart';
import '../views/user_management.dart';
import '../views/system_configuration.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const NOTIFICATIONS = '/notifications';
  static const HOME = '/home';
  static const SCHEDULE = '/schedule';
  static const ACADEMIC_PERFORMANCE = '/academic-performance';
  static const FACILITY_USAGE = '/facility-usage';
  static const REPORT_GENERATOR = '/report-generator';
  static const FINANCIAL_OVERVIEW = '/financial-overview';
  static const USER_MANAGEMENT = '/user-management';
  static const SYSTEM_CONFIGURATION = '/system-configuration';


  static final pages = [
    GetPage(
      name: REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfileView(),
    ),
    GetPage(
      name: EDIT_PROFILE,
      page: () => EditProfileView(),
    ),
    GetPage(
      name: NOTIFICATIONS,
      page: () => NotificationView(),
    ),
    GetPage(
      name: HOME,
      page: () => HomeView(),
    ),
    GetPage(
      name: SCHEDULE,
      page: () => ScheduleView(),
    ),
    GetPage(
      name: ACADEMIC_PERFORMANCE,
      page: () => AcademicPerformancePage(),
    ),
    GetPage(
      name: FACILITY_USAGE,
      page: () => FacilityUsagePage(),
    ),
    GetPage(
      name: REPORT_GENERATOR,
      page: () => ReportGeneratorPage(),
    ),
    GetPage(
      name: FINANCIAL_OVERVIEW,
      page: () => FinancialOverviewPage(),
    ),
    GetPage(
      name: USER_MANAGEMENT,
      page: () => UserManagementPage(),
    ),
    GetPage(
      name: SYSTEM_CONFIGURATION,
      page: () => SystemConfigurationView(),
    ),
  ];
}