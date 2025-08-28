// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../routing/routes.dart';
import '../services/shared_perferences.dart';
import '../utils/constants.dart';

class DioHelper {
  static final DioHelper _dioHelper = DioHelper._internal();
  late Dio dio;
  static DioHelper get instance => _dioHelper;
  DioHelper._internal() {
    dio = Dio(
      BaseOptions(
        headers: {'Content-Type': 'application/json'},

        baseUrl: AppConstants.baseURL,
        receiveDataWhenStatusError: true,
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        requestHeader: true,
        responseHeader: false,
        responseBody: true,
        requestBody: true,
        //  request: true,
      ),
    ]);
  }

  Future<Response> post(
    String path, {
    Object? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response res = await dio.post(
      path,
      data: body ?? {},
      queryParameters: queryParameters ?? {},
      options: Options(
        headers: token == null ? {} : {'Authorization': 'Bearer $token'},
      ),
    );
    return res;
  }

  Future<Response> update(
    String path, {
    Map? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response res = await dio.put(
      path,
      data: body ?? {},
      queryParameters: queryParameters ?? {},
      options: Options(
        headers: token == null ? {} : {'Authorization': 'Bearer $token'},
      ),
    );
    return res;
  }

  Future<Response> patch(
    String path, {
    Object? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response res = await dio.patch(
      path,
      data: body ?? {},
      queryParameters: queryParameters ?? {},
      options: Options(
        headers: token == null ? {} : {'Authorization': 'Bearer $token'},
      ),
    );
    return res;
  }

  Future<Response> delete(
    String path, {
    Map? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response res = await dio.delete(
      path,
      data: body ?? {},
      queryParameters: queryParameters ?? {},
      options: Options(
        headers: token == null ? {} : {'Authorization': 'Bearer $token'},
      ),
    );
    return res;
  }

  Future<Response> get(
    String path, {
    Map? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response res = await dio.get(
      path,
      data: body ?? {},
      queryParameters: queryParameters ?? {},
      options: Options(
        headers: token == null ? {} : {'Authorization': 'Bearer $token'},
      ),
    );
    return res;
  }
}
