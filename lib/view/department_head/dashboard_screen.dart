import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '../../controller/department_head/department_head_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepartmentHeadController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'لوحة التحكم - رئيس القسم',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.loadAllData(),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Handle logout
                },
              ),
            ],
          ),
          body: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadAllData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(),
                      const SizedBox(height: AppConstants.paddingLarge),

                      // Statistics Cards
                      _buildStatisticsSection(controller),
                      const SizedBox(height: AppConstants.paddingLarge),

                      // Quick Actions
                      _buildQuickActionsSection(),
                      const SizedBox(height: AppConstants.paddingLarge),

                      // Pending Researches Section
                      _buildPendingResearchesSection(controller),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppConstants.primaryColor,
            onPressed: () {
              Get.toNamed('/department_head/researches');
            },
            child: const Icon(Icons.list),
          ),
        );
      },
    );
  }

  /// Build welcome section
  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius:
            BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أهلاً وسهلاً',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'رئيس القسم',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistics section
  Widget _buildStatisticsSection(DepartmentHeadController controller) {
    return Obx(
      () {
        final stats = controller.statistics.value;
        if (stats == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإحصائيات',
              style: AppConstants.subHeadingStyle,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppConstants.paddingMedium,
              crossAxisSpacing: AppConstants.paddingMedium,
              children: [
                _buildStatCard(
                  title: 'إجمالي البحوث',
                  value: stats.totalResearches.toString(),
                  color: AppConstants.primaryColor,
                  icon: Icons.library_books,
                ),
                _buildStatCard(
                  title: 'قيد الانتظار',
                  value: stats.pendingResearches.toString(),
                  color: AppConstants.warningColor,
                  icon: Icons.hourglass_empty,
                ),
                _buildStatCard(
                  title: 'موافق عليها',
                  value: stats.approvedResearches.toString(),
                  color: AppConstants.successColor,
                  icon: Icons.check_circle,
                ),
                _buildStatCard(
                  title: 'مرفوضة',
                  value: stats.rejectedResearches.toString(),
                  color: AppConstants.errorColor,
                  icon: Icons.cancel,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildProgressCard(
              title: 'متوسط الإنجاز',
              percentage: stats.averageCompletionPercentage,
            ),
          ],
        );
      },
    );
  }

  /// Build stat card
  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Build progress card
  Widget _buildProgressCard({
    required String title,
    required double percentage,
  }) {
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
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 75
                    ? AppConstants.successColor
                    : percentage >= 50
                        ? AppConstants.warningColor
                        : AppConstants.errorColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات السريعة',
          style: AppConstants.subHeadingStyle,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'البحوث المعلقة',
                icon: Icons.pending_actions,
                onPressed: () {
                  Get.toNamed('/department_head/pending_researches');
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: _buildActionButton(
                title: 'البحوث المتأخرة',
                icon: Icons.warning,
                onPressed: () {
                  Get.toNamed('/department_head/late_researches');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'التقارير',
                icon: Icons.assessment,
                onPressed: () {
                  Get.toNamed('/department_head/reports');
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: _buildActionButton(
                title: 'الإعدادات',
                icon: Icons.settings,
                onPressed: () {
                  Get.toNamed('/department_head/settings');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build action button
  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppConstants.primaryColor,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build pending researches section
  Widget _buildPendingResearchesSection(DepartmentHeadController controller) {
    return Obx(
      () {
        final pending = controller.pendingResearches;
        if (pending.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'البحوث المعلقة',
                  style: AppConstants.subHeadingStyle,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/department_head/pending_researches');
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pending.length > 3 ? 3 : pending.length,
              itemBuilder: (context, index) {
                final research = pending[index];
                return _buildResearchCard(research);
              },
            ),
          ],
        );
      },
    );
  }

  /// Build research card
  Widget _buildResearchCard(dynamic research) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
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
            research.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'الطالب: ${research.studentName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.warningColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'قيد الانتظار',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.warningColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
