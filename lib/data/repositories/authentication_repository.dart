import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/authentication_api.dart';

class AuthenticationRepository{
  late AuthenticationApi _apiRequest;

  AuthenticationRepository(AuthenticationApi api){
    _apiRequest = api;
  }

  Future<Response> signIn(String email,password){
    return _apiRequest.signInRequestApi(email, password);
  }

  Future<Response> signUp(String fullName, String email, String phone, String password, String address){
    return _apiRequest.signUpRequestApi(fullName, email, phone, password, address);
  }
}