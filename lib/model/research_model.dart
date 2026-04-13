class Research {
  final String id;
  final String title;
  final String studentName;
  final String studentId;
  final String supervisorName;
  final String supervisorId;
  final String programId;
  final String departmentId;
  final String status; // pending, approved, rejected, in_progress, completed
  final String description;
  final DateTime submissionDate;
  final DateTime? approvalDate;
  final String? departmentHeadNotes;
  final List<String> stages; // مراحل البحث
  final double completionPercentage;
  final String? fileUrl;

  Research({
    required this.id,
    required this.title,
    required this.studentName,
    required this.studentId,
    required this.supervisorName,
    required this.supervisorId,
    required this.programId,
    required this.departmentId,
    required this.status,
    required this.description,
    required this.submissionDate,
    this.approvalDate,
    this.departmentHeadNotes,
    required this.stages,
    required this.completionPercentage,
    this.fileUrl,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'studentName': studentName,
      'studentId': studentId,
      'supervisorName': supervisorName,
      'supervisorId': supervisorId,
      'programId': programId,
      'departmentId': departmentId,
      'status': status,
      'description': description,
      'submissionDate': submissionDate.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'departmentHeadNotes': departmentHeadNotes,
      'stages': stages,
      'completionPercentage': completionPercentage,
      'fileUrl': fileUrl,
    };
  }

  // Create from JSON
  factory Research.fromJson(Map<String, dynamic> json) {
    return Research(
      id: json['id'] as String,
      title: json['title'] as String,
      studentName: json['studentName'] as String,
      studentId: json['studentId'] as String,
      supervisorName: json['supervisorName'] as String,
      supervisorId: json['supervisorId'] as String,
      programId: json['programId'] as String,
      departmentId: json['departmentId'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'] as String)
          : null,
      departmentHeadNotes: json['departmentHeadNotes'] as String?,
      stages: List<String>.from(json['stages'] as List),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      fileUrl: json['fileUrl'] as String?,
    );
  }

  // Copy with
  Research copyWith({
    String? id,
    String? title,
    String? studentName,
    String? studentId,
    String? supervisorName,
    String? supervisorId,
    String? programId,
    String? departmentId,
    String? status,
    String? description,
    DateTime? submissionDate,
    DateTime? approvalDate,
    String? departmentHeadNotes,
    List<String>? stages,
    double? completionPercentage,
    String? fileUrl,
  }) {
    return Research(
      id: id ?? this.id,
      title: title ?? this.title,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      supervisorName: supervisorName ?? this.supervisorName,
      supervisorId: supervisorId ?? this.supervisorId,
      programId: programId ?? this.programId,
      departmentId: departmentId ?? this.departmentId,
      status: status ?? this.status,
      description: description ?? this.description,
      submissionDate: submissionDate ?? this.submissionDate,
      approvalDate: approvalDate ?? this.approvalDate,
      departmentHeadNotes: departmentHeadNotes ?? this.departmentHeadNotes,
      stages: stages ?? this.stages,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
