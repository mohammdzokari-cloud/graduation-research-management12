import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ============================================================
// [تعليق مؤقت] استيراد Supabase — يمكن تفعيله لاحقاً عند توفر
// بيانات الاتصال الفعلية (URL + Anon Key) من لوحة تحكم Supabase
// import 'package:supabase_flutter/supabase_flutter.dart';
// ============================================================
import 'constants/app_constants.dart';
import 'controller/department_head/department_head_controller.dart';
import 'services/data_service.dart';
import 'view/department_head/dashboard_screen.dart';
import 'view/department_head/researches_list_screen.dart';
import 'view/department_head/research_details_screen.dart';
import 'view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // [تعليق مؤقت] تهيئة Supabase — يحتاج URL ومفتاح حقيقيَّين
  // قم بإلغاء التعليق وأضف بياناتك من: https://supabase.com/dashboard
  //
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL',       // رابط مشروعك على Supabase
  //   anonKey: 'YOUR_SUPABASE_ANON_KEY', // المفتاح العام (anon/public key)
  // );
  // ============================================================

  // ─── تسجيل الـ Controller مسبقاً قبل تشغيل الواجهة ─────────
  // هذا يحل مشكلة "GetX not found" عندما تُشغَّل DashboardScreen
  // مباشرةً عبر home بدون المرور بمسار (route) يحمل binding
  final dataService = DataService(); // بيانات وهمية مؤقتة
  Get.put<DepartmentHeadController>(DepartmentHeadController(dataService));
  // ─────────────────────────────────────────────────────────────

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white, // لون الأيقونات والنص في AppBar
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
        ),
      ),
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),
      getPages: [
        // ── مسار تسجيل الدخول ────────────────────────────────────
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),

        // ── مسارات رئيس القسم ────────────────────────────────────
        GetPage(
          name: '/department_head/dashboard',
          page: () => const DashboardScreen(),
          // ─── Binding للمسار ─────────────────────────────────────────
          // [تعليق مؤقت] عند تفعيل Supabase، استبدل DataService()
          // بـ: DataService(Supabase.instance.client)
          // ─────────────────────────────────────────────────────────────
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<DepartmentHeadController>()) {
              Get.put<DepartmentHeadController>(
                DepartmentHeadController(DataService()),
              );
            }
          }),
        ),
        GetPage(
          name: '/department_head/researches',
          page: () => const ResearchesListScreen(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<DepartmentHeadController>()) {
              Get.put<DepartmentHeadController>(
                DepartmentHeadController(DataService()),
              );
            }
          }),
        ),
        GetPage(
          name: '/department_head/research_details',
          page: () => const ResearchDetailsScreen(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<DepartmentHeadController>()) {
              Get.put<DepartmentHeadController>(
                DepartmentHeadController(DataService()),
              );
            }
          }),
        ),
        GetPage(
          name: '/department_head/pending_researches',
          page: () => const ResearchesListScreen(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<DepartmentHeadController>()) {
              Get.put<DepartmentHeadController>(
                DepartmentHeadController(DataService()),
              );
            } else {
              Get.find<DepartmentHeadController>().filterByStatus('pending');
            }
          }),
        ),
        GetPage(
          name: '/department_head/late_researches',
          page: () => const ResearchesListScreen(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<DepartmentHeadController>()) {
              Get.put<DepartmentHeadController>(
                DepartmentHeadController(DataService()),
              );
            } else {
              Get.find<DepartmentHeadController>().filterByStatus('late');
            }
          }),
        ),
      ],
      // تبدأ الشاشة بواجهة تسجيل الدخول
      home: const LoginScreen(),
    );
  }
}
