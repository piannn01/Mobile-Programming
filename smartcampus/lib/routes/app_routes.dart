import 'package:get/get.dart';
import 'package:smartcampus/views/add_room_view.dart';
import 'package:smartcampus/views/add_tool_view.dart';
import 'package:smartcampus/views/analytic_view.dart';
import 'package:smartcampus/views/facility_view.dart';
import 'package:smartcampus/views/register_view.dart';
import 'package:smartcampus/views/staff_report_view.dart';
import '../views/login_view.dart';
import '../views/profile_view.dart';
import '../views/academic_history_view.dart';
import '../views/edit_profile_view.dart';
import '../views/schedule_view.dart';
import '../views/notification_view.dart';
import '../views/home_view.dart';
import '../views/history_view.dart';
import '../views/academic_performance_page.dart';
import '../views/facility_usage_page.dart';
import '../views/financial_overview_page.dart';
import '../views/user_management.dart';
import '../views/system_configuration.dart';
import '../views/report_generator_page.dart';
import '../views/report_generator_page.dart';
import '../views/scheduledosen_view.dart';
import '../views/schedule_view.dart';
import '../views/krs_view.dart';
import '../views/khs_view.dart';
import '../views/krsdosen_view.dart';
import '../views/transkripnilai_view.dart';
import '../views/assignment_dosen_view.dart';
import '../views/assignment_view.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const ACADEMIC_HISTORY = '/academic-history';
  static const NOTIFICATIONS = '/notifications';
  static const HOME = '/home';
  static const SCHEDULE = '/schedule';
  static const FACILITY = '/facility';
  static const ADD_ROOM = '/add-room';
  static const ADD_TOOL = '/add-tool';
  static const HISTORY = '/history';
  static const REPORT = '/report';
  static const ACADEMIC_PERFORMANCE = '/academic-performance';
  static const FACILITY_USAGE = '/facility-usage';
  static const FINANCIAL_OVERVIEW = '/financial-overview';
  static const USER_MANAGEMENT = '/user-management';
  static const SYSTEM_CONFIGURATION = '/system-configuration';
  static const REPORT_GENERATOR = '/report-generator';
  static const ANALYTIC = '/analytic-view';
  static const SCHEDULEDOSEN = '/scheduledosen';
  static const KRS = '/krs';
  static const KRSDOSEN = '/krsdosen';
  static const KHS = '/khs';
  static const TRANSKRIPNILAI = '/transkrip';
  static const ASSIGNMENTDOSEN = '/assignmentdosen';
  static const ASSIGNMENT = '/assignment';
  static const REPORTS = '/reports';

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
      name: ACADEMIC_HISTORY,
      page: () => AcademicHistoryView(),
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
      name: FACILITY,
      page: () => FacilityView(),
    ),
    GetPage(
      name: ADD_ROOM,
      page: () => PlaceView(),
    ),
    GetPage(
      name: ADD_TOOL,
      page: () => ToolView(),
    ),
    GetPage(
      name: HISTORY,
      page: () => HistoryView(),
    ),
    GetPage(
      name: REPORT,
      page: () => StaffReportView(),
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
    GetPage(
      name: REPORT_GENERATOR,
      page: () => ReportGeneratorPage(),
    ),
    GetPage(
      name: ANALYTIC,
      page: () => AnalyticView(),
    ),
    GetPage(
      name: SCHEDULEDOSEN,
      page: () => AddSchedulePage(),
    ),
    GetPage(
      name: KRS,
      page: () => AmbilKrsMahasiswa(),
    ),
    GetPage(
      name: KRSDOSEN,
      page: () => TambahKrsDosen(),
    ),
    GetPage(
      name: KHS,
      page: () => KhsMahasiswa(),
    ),
    GetPage(
      name: ASSIGNMENTDOSEN,
      page: () => TugasDosenView(),
    ),
    GetPage(
      name: ASSIGNMENT,
      page: () => TugasMahasiswaView(),
    ),
    GetPage(
      name: TRANSKRIPNILAI,
      page: () => TambahTranskripDosen(),
    ),
  ];
}
