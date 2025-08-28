class ApiErrorModel {
  final String? message;
  final int? code;
  ApiErrorModel({this.code, required this.message});

  factory ApiErrorModel.fromJson(Map<String, dynamic> map) {
    return ApiErrorModel(
      message: map['message'] != null
          ? map['message'] as String
          : map['error'] != null
              ? map['error'] as String
              : null,
      code: map['code'] != null ? map['code'] as int : null,
    );
  }
}
