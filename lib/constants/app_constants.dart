import 'package:flutter/material.dart';

class AppConstants {
  // App Name
  static const String appName = 'نظام إدارة بحوث التخرج';
  static const String departmentHeadModule = 'نظام رئيس القسم';

  // Colors
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color accentColor = Color(0xFFFF6F00);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFF44336);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: secondaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: secondaryColor,
  );

  // Padding & Margin
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;

  // Messages
  static const String welcomeMessage = 'أهلاً وسهلاً برئيس القسم';
  static const String loadingMessage = 'جاري التحميل...';
  static const String errorMessage = 'حدث خطأ ما';
  static const String successMessage = 'تمت العملية بنجاح';
  static const String noDataMessage = 'لا توجد بيانات';

  // Status Messages
  static const String statusPending = 'قيد الانتظار';
  static const String statusApproved = 'موافق عليه';
  static const String statusRejected = 'مرفوض';
  static const String statusInProgress = 'قيد التنفيذ';
  static const String statusCompleted = 'مكتمل';
}
