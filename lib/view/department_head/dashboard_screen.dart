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
          backgroundColor: Colors.grey[50], // Light background
          appBar: _buildAppBar(controller),
          drawer: _buildDrawer(), // Adding the drawer from the sidebar
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistics Cards Grid
                      _buildStatisticsSection(controller),
                      const SizedBox(height: 20),

                      // Department Researches Status (Pie Chart Area)
                      _buildChartSection(controller),
                      const SizedBox(height: 20),

                      // Latest Activities (List)
                      _buildLatestActivitiesSection(controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(DepartmentHeadController controller) {
    return AppBar(
      title: const Text(
        'نظام إدارة ومتابعة أبحاث التخرج',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFF3F51B5), // Indigo matching the image
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
             Get.offAllNamed('/login');
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3F51B5),
            ),
            accountName: Text('د. محمد أحمد العامري', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            accountEmail: Text('رئيس القسم'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF3F51B5), size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Color(0xFF3F51B5)),
            title: const Text('لوحة التحكم', style: TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold)),
            tileColor: Colors.blue.withAlpha(25),
            onTap: () {
               Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box_outlined, color: Colors.grey),
            title: const Text('اعتماد المرحلة الأولى'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.grey),
            title: const Text('الاطلاع على الأبحاث'),
            onTap: () {
               Get.back();
               Get.toNamed('/department_head/researches');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: Colors.grey),
            title: const Text('التقارير الأكاديمية'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
            title: const Text('الدردشات'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.grey),
            title: const Text('الإعدادات'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(DepartmentHeadController controller) {
    return Obx(
      () {
        final stats = controller.statistics.value;
        if (stats == null) {
          return const SizedBox.shrink();
        }

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            // Row 1
            _buildStatCard(
              title: 'عدد أبحاث القسم',
              value: stats.totalResearches.toString(),
              color: const Color(0xFF4C6EF5), // Blue
              icon: Icons.menu_book,
              onTap: () {
                controller.filterByStatus('all');
                Get.toNamed('/department_head/researches');
              },
            ),
            _buildStatCard(
              title: 'الأبحاث قيد التنفيذ',
              value: stats.inProgressResearches.toString(),
              color: const Color(0xFFFFC107), // Yellow
              icon: Icons.access_time_filled,
              onTap: () {
                controller.filterByStatus('in_progress');
                Get.toNamed('/department_head/researches');
              },
            ),
            // Row 2
            _buildStatCard(
              title: 'الأبحاث المكتملة',
              value: stats.completedResearches.toString(),
              color: const Color(0xFF4CAF50), // Green
              icon: Icons.check_circle,
              onTap: () {
                controller.filterByStatus('completed');
                Get.toNamed('/department_head/researches');
              },
            ),
            _buildStatCard(
              title: 'عدد المشرفين',
              value: stats.totalSupervisors.toString(),
              color: const Color(0xFF9C27B0), // Purple
              icon: Icons.person,
            ),
            // Row 3
            _buildStatCard(
              title: 'عدد الطلاب',
              value: stats.totalStudents.toString(),
              color: const Color(0xFF9C27B0), // Purple
              icon: Icons.group,
            ),
            _buildStatCard(
              title: 'الأبحاث المتأخرة',
              value: controller.lateResearches.length.toString(),
              color: const Color(0xFFF44336), // Red
              icon: Icons.error,
              onTap: () {
                controller.filterByStatus('late');
                Get.toNamed('/department_head/researches');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 20,
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(DepartmentHeadController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'حالة أبحاث القسم',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          // Stack to simulate pie chart
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 1.0, // Base Red
                    backgroundColor: Colors.transparent,
                    color: Color(0xFFF44336), // Red
                    strokeWidth: 35,
                  ),
                ),
                const SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 0.91, // 55% green + 36% yellow = 91%
                    backgroundColor: Colors.transparent,
                    color: Color(0xFFFFC107), // Yellow
                    strokeWidth: 35,
                  ),
                ),
                const SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 0.55, // Green
                    backgroundColor: Colors.transparent,
                    color: Color(0xFF4CAF50), // Green
                    strokeWidth: 35,
                  ),
                ),
                // Inner center percent
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('55%', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4CAF50), fontSize: 18)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Chart Legends
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(color: const Color(0xFF4CAF50), text: 'أبحاث مكتملة'),
              const SizedBox(width: 12),
              _buildLegend(color: const Color(0xFFFFC107), text: 'قيد التنفيذ'),
              const SizedBox(width: 12),
              _buildLegend(color: const Color(0xFFF44336), text: 'متأخرة'),
            ],
          ),
          const SizedBox(height: 36),
          // Progress bar
          Obx(() {
            final stats = controller.statistics.value;
            final percentage = stats?.averageCompletionPercentage ?? 54.8;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text('نسبة الإنجاز الكلية للقسم', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                     Text('${percentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildLegend({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildLatestActivitiesSection(DepartmentHeadController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر الأنشطة في القسم',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final all = controller.allResearches;
            if (all.isEmpty) {
              return const Center(child: Text('لا توجد أنشطة حاليا', style: TextStyle(color: Colors.black54)));
            }
            final list = all.take(5).toList();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => const Divider(height: 24, color: Colors.grey, thickness: 0.2),
              itemBuilder: (context, index) {
                final item = list[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 35,
                      decoration: BoxDecoration(
                         color: const Color(0xFF3F51B5),
                         borderRadius: BorderRadius.circular(4),
                      )
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'تحديث حالة بحث "${item.title}"',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الطالب: ${item.studentName}',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Adding dummy time similar to requested image
                    Text(
                      index == 0 ? 'منذ ساعتين' : (index == 1 ? 'منذ 4 ساعات' : 'أمس'),
                       style: const TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  ],
                );
              },
            );
          })
        ],
      ),
    );
  }
}
