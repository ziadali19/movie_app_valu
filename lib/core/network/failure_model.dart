class ApiErrorModel {
  final String? message;
  final bool? status;
  ApiErrorModel({this.status, required this.message});

  factory ApiErrorModel.fromJson(Map<String, dynamic> map) {
    return ApiErrorModel(
      message: map['status_message'] != null
          ? map['status_message'] as String
          : null,
      status: map['success'] != null ? map['success'] as bool : null,
    );
  }
}
