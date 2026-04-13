import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/research_model.dart';
import '../../model/department_head/statistics_model.dart';
import '../../services/data_service.dart';

class DepartmentHeadController extends GetxController {
  final DataService dataService;

  DepartmentHeadController(this.dataService);

  // Observables
  final RxList<Research> allResearches = <Research>[].obs;
  final RxList<Research> pendingResearches = <Research>[].obs;
  final RxList<Research> approvedResearches = <Research>[].obs;
  final RxList<Research> rejectedResearches = <Research>[].obs;
  final RxList<Research> inProgressResearches = <Research>[].obs;
  final RxList<Research> completedResearches = <Research>[].obs;
  final RxList<Research> lateResearches = <Research>[].obs;
  final RxList<Research> searchResults = <Research>[].obs;

  final Rx<DepartmentStatistics?> statistics = Rx<DepartmentStatistics?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString departmentId = ''.obs;
  final RxString selectedFilter = 'all'.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with department ID from arguments or local storage
    _initializeDepartmentId();
  }

  /// Initialize department ID
  void _initializeDepartmentId() {
    // [تعليق مؤقت] عند ربط قاعدة البيانات، سيأتي الـ departmentId
    // من بيانات تسجيل الدخول أو SharedPreferences بدلاً من القيمة الثابتة
    //
    // الآن: نستخدم قيمة افتراضية 'dept001' لتحميل البيانات الوهمية
    departmentId.value = Get.arguments?['departmentId'] ?? 'dept001';
    loadAllData();
  }

  /// Load all data for the department
  Future<void> loadAllData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.wait([_loadAllResearches(), _loadStatistics()]);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('خطأ', 'فشل تحميل البيانات: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load all researches
  Future<void> _loadAllResearches() async {
    try {
      final researches = await dataService.getResearchesByDepartment(
        departmentId.value,
      );
      allResearches.value = researches;

      // Filter by status
      pendingResearches.value = researches
          .where((r) => r.status == 'pending')
          .toList();
      approvedResearches.value = researches
          .where((r) => r.status == 'approved')
          .toList();
      rejectedResearches.value = researches
          .where((r) => r.status == 'rejected')
          .toList();
      inProgressResearches.value = researches
          .where((r) => r.status == 'in_progress')
          .toList();
      completedResearches.value = researches
          .where((r) => r.status == 'completed')
          .toList();

      // Load late researches
      lateResearches.value = await dataService.getLateResearches(
        departmentId.value,
      );
    } catch (e) {
      throw Exception('فشل في تحميل البحوث: $e');
    }
  }

  /// Load statistics
  Future<void> _loadStatistics() async {
    try {
      final stats = await dataService.getDepartmentStatistics(
        departmentId.value,
      );
      statistics.value = stats;
    } catch (e) {
      throw Exception('فشل في تحميل الإحصائيات: $e');
    }
  }

  /// Approve research
  Future<void> approveResearch(String researchId, String notes) async {
    try {
      isLoading.value = true;
      await dataService.approveResearch(researchId, notes);
      await loadAllData();
      Get.snackbar('نجاح', 'تم اعتماد البحث بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اعتماد البحث: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Reject research
  Future<void> rejectResearch(String researchId, String notes) async {
    try {
      isLoading.value = true;
      await dataService.rejectResearch(researchId, notes);
      await loadAllData();
      Get.snackbar('نجاح', 'تم رفض البحث بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في رفض البحث: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add notes to research
  Future<void> addNotes(String researchId, String notes) async {
    try {
      isLoading.value = true;
      await dataService.addNotesToResearch(researchId, notes);
      await loadAllData();
      Get.snackbar('نجاح', 'تم إضافة الملاحظات بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إضافة الملاحظات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search researches
  Future<void> searchResearches(String query) async {
    try {
      if (query.isEmpty) {
        searchResults.clear();
        isSearching.value = false;
        return;
      }

      isSearching.value = true;
      final results = await dataService.searchResearches(
        departmentId.value,
        query,
      );
      searchResults.value = results;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في البحث: $e');
    } finally {
      isSearching.value = false;
    }
  }

  /// Clear search
  void clearSearch() {
    searchResults.clear();
    isSearching.value = false;
  }

  /// Filter researches by status
  void filterByStatus(String status) {
    selectedFilter.value = status;
  }

  /// Get filtered researches
  List<Research> getFilteredResearches() {
    switch (selectedFilter.value) {
      case 'pending':
        return pendingResearches;
      case 'approved':
        return approvedResearches;
      case 'rejected':
        return rejectedResearches;
      case 'in_progress':
        return inProgressResearches;
      case 'completed':
        return completedResearches;
      case 'late':
        return lateResearches;
      default:
        return allResearches;
    }
  }

  /// Get paginated researches
  List<Research> getPaginatedResearches() {
    final filtered = getFilteredResearches();
    final startIndex = (currentPage.value - 1) * itemsPerPage.value;
    final endIndex = startIndex + itemsPerPage.value;

    if (startIndex >= filtered.length) {
      return [];
    }

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  /// Get total pages
  int getTotalPages() {
    final filtered = getFilteredResearches();
    return (filtered.length / itemsPerPage.value).ceil();
  }

  /// Go to next page
  void nextPage() {
    if (currentPage.value < getTotalPages()) {
      currentPage.value++;
    }
  }

  /// Go to previous page
  Future<void> previousPage() async {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return const Color.fromARGB(255, 76, 175, 80);
      case 'rejected':
        return Color.fromARGB(255, 244, 67, 54);
      case 'pending':
        return const Color.fromARGB(255, 255, 193, 7);
      case 'in_progress':
        return const Color.fromARGB(255, 33, 150, 243);
      case 'completed':
        return const Color.fromARGB(255, 76, 175, 80);
      default:
        return const Color.fromARGB(255, 158, 158, 158);
    }
  }

  /// Get status text
  String getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'موافق عليه';
      case 'rejected':
        return 'مرفوض';
      case 'pending':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      default:
        return 'غير معروف';
    }
  }
}
