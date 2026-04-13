import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '../../controller/department_head/department_head_controller.dart';
import '../../model/research_model.dart';

class ResearchDetailsScreen extends StatefulWidget {
  const ResearchDetailsScreen({super.key});

  @override
  State<ResearchDetailsScreen> createState() => _ResearchDetailsScreenState();
}

class _ResearchDetailsScreenState extends State<ResearchDetailsScreen> {
  late TextEditingController _notesController;
  Research? research;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _loadResearchDetails();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadResearchDetails() async {
    final researchId = Get.arguments?['researchId'];
    if (researchId != null) {
      final controller = Get.find<DepartmentHeadController>();
      try {
        research = await controller.dataService.getResearchDetails(researchId);
        _notesController.text = research?.departmentHeadNotes ?? '';
        setState(() {});
      } catch (e) {
        Get.snackbar('خطأ', 'فشل في تحميل تفاصيل البحث');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepartmentHeadController>(
      builder: (controller) {
        if (research == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('تفاصيل البحث'),
              backgroundColor: AppConstants.primaryColor,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('تفاصيل البحث'),
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                _buildTitleSection(controller),
                const SizedBox(height: AppConstants.paddingLarge),

                // Status Section
                _buildStatusSection(controller),
                const SizedBox(height: AppConstants.paddingLarge),

                // Research Information
                _buildResearchInformation(),
                const SizedBox(height: AppConstants.paddingLarge),

                // Stages Section
                _buildStagesSection(),
                const SizedBox(height: AppConstants.paddingLarge),

                // Notes Section
                _buildNotesSection(controller),
                const SizedBox(height: AppConstants.paddingLarge),

                // Action Buttons
                if (research!.status == 'pending')
                  _buildActionButtons(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build title section
  Widget _buildTitleSection(DepartmentHeadController controller) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            research!.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: controller
                  .getStatusColor(research!.status)
                  .withAlpha(51),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              controller.getStatusText(research!.status),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: controller.getStatusColor(research!.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build status section
  Widget _buildStatusSection(DepartmentHeadController controller) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نسبة الإنجاز',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: research!.completionPercentage / 100,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                controller.getStatusColor(research!.status),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${research!.completionPercentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build research information
  Widget _buildResearchInformation() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات البحث',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('الطالب', research!.studentName),
          _buildInfoRow('رقم الطالب', research!.studentId),
          _buildInfoRow('المشرف', research!.supervisorName),
          _buildInfoRow('البرنامج', research!.programId),
          _buildInfoRow(
            'تاريخ الإرسال',
            research!.submissionDate.toString().split(' ')[0],
          ),
          if (research!.approvalDate != null)
            _buildInfoRow(
              'تاريخ الاعتماد',
              research!.approvalDate.toString().split(' ')[0],
            ),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppConstants.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build stages section
  Widget _buildStagesSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مراحل البحث',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: research!.stages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        research!.stages[index],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppConstants.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build notes section
  Widget _buildNotesSection(DepartmentHeadController controller) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الملاحظات',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 4,
            enabled: research!.status == 'pending',
            decoration: InputDecoration(
              hintText: 'أضف ملاحظاتك هنا...',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
            ),
          ),
          if (research!.status == 'pending')
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: () {
                  controller.addNotes(research!.id, _notesController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text(
                  'حفظ الملاحظات',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(DepartmentHeadController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showApprovalDialog(controller);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.successColor,
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text(
                  'اعتماد',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showRejectionDialog(controller);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.errorColor,
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text(
                  'رفض',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Show approval dialog
  void _showApprovalDialog(DepartmentHeadController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الاعتماد'),
          content: const Text('هل تريد اعتماد هذا البحث؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.approveResearch(
                  research!.id,
                  _notesController.text,
                );
                Navigator.pop(context);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.successColor,
              ),
              child: const Text(
                'اعتماد',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show rejection dialog
  void _showRejectionDialog(DepartmentHeadController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الرفض'),
          content: const Text('هل تريد رفض هذا البحث؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.rejectResearch(
                  research!.id,
                  _notesController.text,
                );
                Navigator.pop(context);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.errorColor,
              ),
              child: const Text(
                'رفض',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
