class DepartmentStatistics {
  final int totalResearches;
  final int approvedResearches;
  final int rejectedResearches;
  final int pendingResearches;
  final int inProgressResearches;
  final int completedResearches;
  final double averageCompletionPercentage;
  final int totalStudents;
  final int totalSupervisors;
  final DateTime lastUpdated;
  final Map<String, int> researchesByProgram;
  final Map<String, int> researchesByStatus;

  DepartmentStatistics({
    required this.totalResearches,
    required this.approvedResearches,
    required this.rejectedResearches,
    required this.pendingResearches,
    required this.inProgressResearches,
    required this.completedResearches,
    required this.averageCompletionPercentage,
    required this.totalStudents,
    required this.totalSupervisors,
    required this.lastUpdated,
    required this.researchesByProgram,
    required this.researchesByStatus,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalResearches': totalResearches,
      'approvedResearches': approvedResearches,
      'rejectedResearches': rejectedResearches,
      'pendingResearches': pendingResearches,
      'inProgressResearches': inProgressResearches,
      'completedResearches': completedResearches,
      'averageCompletionPercentage': averageCompletionPercentage,
      'totalStudents': totalStudents,
      'totalSupervisors': totalSupervisors,
      'lastUpdated': lastUpdated.toIso8601String(),
      'researchesByProgram': researchesByProgram,
      'researchesByStatus': researchesByStatus,
    };
  }

  // Create from JSON
  factory DepartmentStatistics.fromJson(Map<String, dynamic> json) {
    return DepartmentStatistics(
      totalResearches: json['totalResearches'] as int,
      approvedResearches: json['approvedResearches'] as int,
      rejectedResearches: json['rejectedResearches'] as int,
      pendingResearches: json['pendingResearches'] as int,
      inProgressResearches: json['inProgressResearches'] as int,
      completedResearches: json['completedResearches'] as int,
      averageCompletionPercentage:
          (json['averageCompletionPercentage'] as num).toDouble(),
      totalStudents: json['totalStudents'] as int,
      totalSupervisors: json['totalSupervisors'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      researchesByProgram: Map<String, int>.from(json['researchesByProgram']),
      researchesByStatus: Map<String, int>.from(json['researchesByStatus']),
    );
  }

  // Calculate approval rate
  double getApprovalRate() {
    if (totalResearches == 0) return 0.0;
    return (approvedResearches / totalResearches) * 100;
  }

  // Calculate completion rate
  double getCompletionRate() {
    if (totalResearches == 0) return 0.0;
    return (completedResearches / totalResearches) * 100;
  }

  // Get pending count
  int getPendingCount() {
    return pendingResearches;
  }
}
