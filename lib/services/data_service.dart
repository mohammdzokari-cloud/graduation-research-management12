// ============================================================
// [تعليق مؤقت] استيراد Supabase — فعّله لاحقاً مع البيانات الحقيقية
// import 'package:supabase_flutter/supabase_flutter.dart';
// ============================================================
import '../model/research_model.dart';
import '../model/department_head/statistics_model.dart';

// ============================================================
// DataService — طبقة الخدمات للوصول إلى قاعدة البيانات
//
// [الوضع الحالي] كل الدوال ترجع بيانات وهمية (Mock Data) مؤقتة
// [عند التفعيل]  أزل التعليق عن استدعاءات Supabase وأعد تمرير
//                SupabaseClient عبر constructor
// ============================================================
class DataService {
  // ──────────────────────────────────────────────────────────
  // [تعليق مؤقت] حقل الـ SupabaseClient — فعّله لاحقاً
  // final SupabaseClient supabase;
  // DataService(this.supabase);
  // ──────────────────────────────────────────────────────────

  // Constructor بدون معاملات (يستخدم البيانات الوهمية حالياً)
  DataService();

  // ─── بيانات وهمية مشتركة (Mock Data) ─────────────────────
  // هذه القائمة تمثل بحوث افتراضية للاختبار
  // تتبع: DataService (مشتركة بين كل دوال هذا الملف)
  static final List<Research> _mockResearches = [
    Research(
      id: 'r001',
      title: 'تأثير الذكاء الاصطناعي على جودة التعليم العالي',
      studentName: 'أحمد محمد العمري',
      studentId: 'S2021001',
      supervisorName: 'د. خالد إبراهيم',
      supervisorId: 'sup001',
      programId: 'CS',
      departmentId: 'dept001',
      status: 'pending',
      description: 'دراسة حول تأثير تقنيات الذكاء الاصطناعي على أساليب التدريس والتعلم في الجامعات.',
      submissionDate: DateTime(2025, 9, 15),
      approvalDate: null,
      departmentHeadNotes: null,
      stages: ['مراجعة الأدبيات', 'جمع البيانات', 'التحليل', 'كتابة التقرير'],
      completionPercentage: 35.0,
      fileUrl: null,
    ),
    Research(
      id: 'r002',
      title: 'تطوير نظام إدارة المستشفيات باستخدام Flutter',
      studentName: 'سارة عبدالله القحطاني',
      studentId: 'S2021002',
      supervisorName: 'د. منى الشمري',
      supervisorId: 'sup002',
      programId: 'IT',
      departmentId: 'dept001',
      status: 'approved',
      description: 'بناء تطبيق موبايل متكامل لإدارة مواعيد المرضى والطواقم الطبية.',
      submissionDate: DateTime(2025, 8, 10),
      approvalDate: DateTime(2025, 9, 1),
      departmentHeadNotes: 'بحث ممتاز، يُظهر تطبيقاً عملياً رائعاً.',
      stages: ['التصميم', 'التطوير', 'الاختبار', 'التسليم'],
      completionPercentage: 75.0,
      fileUrl: null,
    ),
    Research(
      id: 'r003',
      title: 'خوارزميات التشفير في أمن الشبكات اللاسلكية',
      studentName: 'فيصل ناصر الدوسري',
      studentId: 'S2021003',
      supervisorName: 'د. خالد إبراهيم',
      supervisorId: 'sup001',
      programId: 'CS',
      departmentId: 'dept001',
      status: 'in_progress',
      description: 'مقارنة خوارزميات التشفير الحديثة وتقييم أدائها في بيئات اللاسلكي.',
      submissionDate: DateTime(2025, 6, 20),
      approvalDate: DateTime(2025, 7, 5),
      departmentHeadNotes: 'يرجى التركيز على البيئات الحقيقية.',
      stages: ['البحث النظري', 'التجارب المعملية', 'التحليل المقارن', 'الاستنتاجات'],
      completionPercentage: 60.0,
      fileUrl: null,
    ),
    Research(
      id: 'r004',
      title: 'نظام توصية الكتب باستخدام Machine Learning',
      studentName: 'نورة سعد العتيبي',
      studentId: 'S2021004',
      supervisorName: 'د. منى الشمري',
      supervisorId: 'sup002',
      programId: 'DS',
      departmentId: 'dept001',
      status: 'completed',
      description: 'بناء نظام توصيات ذكي للكتب الأكاديمية بناءً على اهتمامات الطالب.',
      submissionDate: DateTime(2025, 3, 1),
      approvalDate: DateTime(2025, 3, 20),
      departmentHeadNotes: 'تم الاعتماد بامتياز.',
      stages: ['جمع البيانات', 'بناء النموذج', 'التقييم', 'التسليم النهائي'],
      completionPercentage: 100.0,
      fileUrl: null,
    ),
    Research(
      id: 'r005',
      title: 'أثر وسائل التواصل الاجتماعي على الإنتاجية الأكاديمية',
      studentName: 'عمر يوسف الزهراني',
      studentId: 'S2021005',
      supervisorName: 'د. علي الغامدي',
      supervisorId: 'sup003',
      programId: 'MIS',
      departmentId: 'dept001',
      status: 'rejected',
      description: 'دراسة تحليلية لتأثير منصات التواصل على أداء الطلاب الجامعيين.',
      submissionDate: DateTime(2025, 10, 5),
      approvalDate: null,
      departmentHeadNotes: 'منهجية البحث تحتاج إلى مراجعة جذرية قبل إعادة التقديم.',
      stages: ['تصميم الاستبانة', 'جمع البيانات', 'التحليل الإحصائي'],
      completionPercentage: 20.0,
      fileUrl: null,
    ),
    Research(
      id: 'r006',
      title: 'تطبيق إدارة المشاريع باستخدام Agile في شركات التقنية',
      studentName: 'ريم أحمد المالكي',
      studentId: 'S2021006',
      supervisorName: 'د. علي الغامدي',
      supervisorId: 'sup003',
      programId: 'IT',
      departmentId: 'dept001',
      status: 'in_progress',
      description: 'دراسة مقارنة لأساليب Agile في تطوير المشاريع التقنية.',
      submissionDate: DateTime(2025, 5, 10),
      approvalDate: DateTime(2025, 5, 25),
      departmentHeadNotes: null,
      stages: ['البحث النظري', 'دراسات الحالة', 'المقارنة والتحليل', 'التوصيات'],
      completionPercentage: 55.0,
      fileUrl: null,
    ),
  ];

  // ==================== Research Operations ====================

  /// جلب جميع البحوث الخاصة بالقسم
  /// [الواجهة] تُستخدم في: DashboardScreen, ResearchesListScreen
  Future<List<Research>> getResearchesByDepartment(String departmentId) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final response = await supabase
    //       .from('researches')
    //       .select()
    //       .eq('department_id', departmentId);
    //   return (response as List)
    //       .map((json) => Research.fromJson(json as Map<String, dynamic>))
    //       .toList();
    // } catch (e) {
    //   throw Exception('فشل في جلب البحوث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    // [بيانات وهمية مؤقتة] ترجع جميع البحوث بغض النظر عن departmentId
    await Future.delayed(const Duration(milliseconds: 500)); // محاكاة تأخير الشبكة
    return List<Research>.from(_mockResearches);
  }

  /// جلب البحوث حسب الحالة
  /// [الواجهة] تُستخدم في: ResearchesListScreen (عند الفلترة)
  Future<List<Research>> getResearchesByStatus(
      String departmentId, String status) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final response = await supabase
    //       .from('researches')
    //       .select()
    //       .eq('department_id', departmentId)
    //       .eq('status', status);
    //   return (response as List)
    //       .map((json) => Research.fromJson(json as Map<String, dynamic>))
    //       .toList();
    // } catch (e) {
    //   throw Exception('فشل في جلب البحوث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 300));
    return _mockResearches.where((r) => r.status == status).toList();
  }

  /// جلب البحوث المعلقة (في انتظار موافقة رئيس القسم)
  /// [الواجهة] تُستخدم في: DashboardScreen (قسم البحوث المعلقة)
  Future<List<Research>> getPendingResearches(String departmentId) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final response = await supabase
    //       .from('researches')
    //       .select()
    //       .eq('department_id', departmentId)
    //       .eq('status', 'pending')
    //       .order('submission_date', ascending: false);
    //   return (response as List)
    //       .map((json) => Research.fromJson(json as Map<String, dynamic>))
    //       .toList();
    // } catch (e) {
    //   throw Exception('فشل في جلب البحوث المعلقة: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 300));
    return _mockResearches.where((r) => r.status == 'pending').toList();
  }

  /// اعتماد البحث من قِبل رئيس القسم
  /// [الواجهة] تُستخدم في: ResearchDetailsScreen (زر "اعتماد")
  Future<void> approveResearch(
      String researchId, String departmentHeadNotes) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   await supabase.from('researches').update({
    //     'status': 'approved',
    //     'approval_date': DateTime.now().toIso8601String(),
    //     'department_head_notes': departmentHeadNotes,
    //   }).eq('id', researchId);
    // } catch (e) {
    //   throw Exception('فشل في اعتماد البحث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    // [بيانات وهمية] محاكاة تحديث حالة البحث في الذاكرة
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockResearches.indexWhere((r) => r.id == researchId);
    if (index != -1) {
      _mockResearches[index] = _mockResearches[index].copyWith(
        status: 'approved',
        approvalDate: DateTime.now(),
        departmentHeadNotes: departmentHeadNotes,
      );
    }
  }

  /// رفض البحث من قِبل رئيس القسم
  /// [الواجهة] تُستخدم في: ResearchDetailsScreen (زر "رفض")
  Future<void> rejectResearch(
      String researchId, String departmentHeadNotes) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   await supabase.from('researches').update({
    //     'status': 'rejected',
    //     'department_head_notes': departmentHeadNotes,
    //   }).eq('id', researchId);
    // } catch (e) {
    //   throw Exception('فشل في رفض البحث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockResearches.indexWhere((r) => r.id == researchId);
    if (index != -1) {
      _mockResearches[index] = _mockResearches[index].copyWith(
        status: 'rejected',
        departmentHeadNotes: departmentHeadNotes,
      );
    }
  }

  /// إضافة ملاحظات على البحث
  /// [الواجهة] تُستخدم في: ResearchDetailsScreen (زر "حفظ الملاحظات")
  Future<void> addNotesToResearch(String researchId, String notes) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   await supabase.from('researches').update({
    //     'department_head_notes': notes,
    //   }).eq('id', researchId);
    // } catch (e) {
    //   throw Exception('فشل في إضافة الملاحظات: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockResearches.indexWhere((r) => r.id == researchId);
    if (index != -1) {
      _mockResearches[index] = _mockResearches[index].copyWith(
        departmentHeadNotes: notes,
      );
    }
  }

  /// جلب تفاصيل بحث محدد برقم معرّفه
  /// [الواجهة] تُستخدم في: ResearchDetailsScreen (عند فتح بحث)
  Future<Research> getResearchDetails(String researchId) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final response =
    //       await supabase.from('researches').select().eq('id', researchId);
    //   if (response.isEmpty) {
    //     throw Exception('البحث غير موجود');
    //   }
    //   return Research.fromJson(response[0] as Map<String, dynamic>);
    // } catch (e) {
    //   throw Exception('فشل في جلب تفاصيل البحث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 300));
    final research = _mockResearches.where((r) => r.id == researchId).toList();
    if (research.isEmpty) {
      // إذا لم يُوجد، أرجع أول بحث كبيانات افتراضية
      return _mockResearches.first;
    }
    return research.first;
  }

  // ==================== Statistics Operations ====================

  /// جلب إحصائيات القسم
  /// [الواجهة] تُستخدم في: DashboardScreen (بطاقات الإحصائيات)
  Future<DepartmentStatistics> getDepartmentStatistics(
      String departmentId) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كان الكود الأصلي يحسب الإحصائيات من قاعدة البيانات
    // الآن يحسبها من البيانات الوهمية بنفس المنطق
    // ──────────────────────────────────────────────────────────
    try {
      final researches = await getResearchesByDepartment(departmentId);

      int approved = 0;
      int rejected = 0;
      int pending = 0;
      int inProgress = 0;
      int completed = 0;
      double totalCompletion = 0;
      Map<String, int> byProgram = {};
      Map<String, int> byStatus = {};

      for (var research in researches) {
        switch (research.status) {
          case 'approved':
            approved++;
            break;
          case 'rejected':
            rejected++;
            break;
          case 'pending':
            pending++;
            break;
          case 'in_progress':
            inProgress++;
            break;
          case 'completed':
            completed++;
            break;
        }

        totalCompletion += research.completionPercentage;
        byProgram[research.programId] =
            (byProgram[research.programId] ?? 0) + 1;
        byStatus[research.status] = (byStatus[research.status] ?? 0) + 1;
      }

      double avgCompletion =
          researches.isEmpty ? 0 : totalCompletion / researches.length;

      return DepartmentStatistics(
        totalResearches: researches.length,
        approvedResearches: approved,
        rejectedResearches: rejected,
        pendingResearches: pending,
        inProgressResearches: inProgress,
        completedResearches: completed,
        averageCompletionPercentage: avgCompletion,
        totalStudents: researches.length,
        totalSupervisors: researches.map((r) => r.supervisorId).toSet().length,
        lastUpdated: DateTime.now(),
        researchesByProgram: byProgram,
        researchesByStatus: byStatus,
      );
    } catch (e) {
      throw Exception('فشل في جلب الإحصائيات: $e');
    }
  }

  /// جلب البحوث حسب البرنامج الأكاديمي
  /// [الواجهة] غير مستخدمة حالياً في الواجهات الموجودة
  Future<List<Research>> getResearchesByProgram(
      String departmentId, String programId) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final response = await supabase
    //       .from('researches')
    //       .select()
    //       .eq('department_id', departmentId)
    //       .eq('program_id', programId);
    //   return (response as List)
    //       .map((json) => Research.fromJson(json as Map<String, dynamic>))
    //       .toList();
    // } catch (e) {
    //   throw Exception('فشل في جلب البحوث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 300));
    return _mockResearches
        .where((r) => r.programId == programId)
        .toList();
  }

  // ==================== Search & Filter ====================

  /// البحث عن طريق عنوان البحث أو اسم الطالب أو المشرف
  /// [الواجهة] تُستخدم في: ResearchesListScreen (شريط البحث)
  Future<List<Research>> searchResearches(
      String departmentId, String query) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final response = await supabase
    //       .from('researches')
    //       .select()
    //       .eq('department_id', departmentId);
    //   final researches = (response as List)
    //       .map((json) => Research.fromJson(json as Map<String, dynamic>))
    //       .toList();
    //   return researches
    //       .where((r) =>
    //           r.title.contains(query) ||
    //           r.studentName.contains(query) ||
    //           r.supervisorName.contains(query))
    //       .toList();
    // } catch (e) {
    //   throw Exception('فشل في البحث: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 200));
    final lowerQuery = query.toLowerCase();
    return _mockResearches
        .where((r) =>
            r.title.toLowerCase().contains(lowerQuery) ||
            r.studentName.toLowerCase().contains(lowerQuery) ||
            r.supervisorName.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// جلب البحوث المتأخرة (قيد التنفيذ ومرّ عليها أكثر من 6 أشهر)
  /// [الواجهة] تُستخدم في: DashboardScreen (الإجراءات السريعة - البحوث المتأخرة)
  Future<List<Research>> getLateResearches(String departmentId) async {
    // ──────────────────────────────────────────────────────────
    // [تعليق مؤقت] كود Supabase الأصلي — فعّله لاحقاً
    // try {
    //   final researches = await getResearchesByDepartment(departmentId);
    //   final now = DateTime.now();
    //   return researches.where((r) {
    //     if (r.status == 'in_progress') {
    //       final daysPassed = now.difference(r.submissionDate).inDays;
    //       return daysPassed > 180;
    //     }
    //     return false;
    //   }).toList();
    // } catch (e) {
    //   throw Exception('فشل في جلب البحوث المتأخرة: $e');
    // }
    // ──────────────────────────────────────────────────────────

    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return _mockResearches.where((r) {
      if (r.status == 'in_progress') {
        final daysPassed = now.difference(r.submissionDate).inDays;
        return daysPassed > 180; // أكثر من 6 أشهر = متأخر
      }
      return false;
    }).toList();
  }
}
