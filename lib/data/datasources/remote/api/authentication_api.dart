
import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/common/dio_client.dart';

class AuthenticationApi {
  late Dio _dio;

  AuthenticationApi() {
    _dio = DioClient.instance.dio;
  }

  Future<Response> signInRequestApi(String email, String password) {
    return _dio.post("login", data: {
      "email": email,
      "password": password,
    });
  }

  Future<Response> signUpRequestApi(String fullName, String email, String phone, String password, String address) {
    return _dio.post("user/sign-up", data: {
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "password": password,
      "address": address
    });
  }

}