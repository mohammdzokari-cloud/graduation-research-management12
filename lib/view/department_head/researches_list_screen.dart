import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '../../controller/department_head/department_head_controller.dart';

class ResearchesListScreen extends StatelessWidget {
  const ResearchesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepartmentHeadController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'قائمة البحوث',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Search Bar
              _buildSearchBar(controller),

              // Filter Tabs
              _buildFilterTabs(controller),

              // Researches List
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final researches = controller.isSearching.value
                        ? controller.searchResults
                        : controller.getFilteredResearches();

                    if (researches.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد بحوث',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(
                          AppConstants.paddingMedium),
                      itemCount: researches.length,
                      itemBuilder: (context, index) {
                        final research = researches[index];
                        return _buildResearchListItem(
                          research,
                          controller,
                          () {
                            Get.toNamed(
                              '/department_head/research_details',
                              arguments: {'researchId': research.id},
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build search bar
  Widget _buildSearchBar(DepartmentHeadController controller) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      color: Colors.white,
      child: TextField(
        onChanged: (value) {
          if (value.isEmpty) {
            controller.clearSearch();
          } else {
            controller.searchResearches(value);
          }
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن بحث أو طالب...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(
            () => controller.isSearching.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
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
    );
  }

  /// Build filter tabs
  Widget _buildFilterTabs(DepartmentHeadController controller) {
    final filters = [
      ('all', 'الكل'),
      ('pending', 'قيد الانتظار'),
      ('approved', 'موافق عليها'),
      ('rejected', 'مرفوضة'),
      ('in_progress', 'قيد التنفيذ'),
      ('completed', 'مكتملة'),
    ];

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        child: Row(
          children: filters.map((filter) {
            return Obx(
              () => Padding(
                padding: const EdgeInsets.only(
                  right: AppConstants.paddingSmall,
                ),
                child: FilterChip(
                  label: Text(filter.$2),
                  selected: controller.selectedFilter.value == filter.$1,
                  onSelected: (selected) {
                    if (selected) {
                      controller.filterByStatus(filter.$1);
                      controller.currentPage.value = 1;
                    }
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: AppConstants.primaryColor,
                  labelStyle: TextStyle(
                    color: controller.selectedFilter.value == filter.$1
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build research list item
  Widget _buildResearchListItem(
    dynamic research,
    DepartmentHeadController controller,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  research.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.secondaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Student and Supervisor
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الطالب',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            research.studentName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المشرف',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            research.supervisorName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status and Completion
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .getStatusColor(research.status)
                            .withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        controller.getStatusText(research.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: controller.getStatusColor(research.status),
                        ),
                      ),
                    ),

                    // Completion Percentage
                    Text(
                      '${research.completionPercentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.secondaryColor,
                      ),
                    ),
                  ],
                ),

                // Progress Bar
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: research.completionPercentage / 100,
                    minHeight: 4,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      controller.getStatusColor(research.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
