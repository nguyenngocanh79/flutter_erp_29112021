import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/nhansu_api.dart';

class NhansuRepository{
  late NhansuApi _apiRequest;

  NhansuRepository(NhansuApi api){
    _apiRequest = api;
  }

  Future<Response> fetchNhanviens(){
    return _apiRequest.fetchNhanviens();
  }

  Future<Response> fetchNhanviensTheoPhongban(String phongban){
    return _apiRequest.fetchNhanviensTheoPhongban(phongban);
  }

  Future<Response> fetchPhongbans(){
    return _apiRequest.fetchPhongbans();
  }

  Future<Response> fetchNghiphepCanduyet({required int id}){
    return _apiRequest.fetchNghiphepCanduyet(id: id);
  }

  // Future<Response> fetchDetailFood(String foodId){
  //   return _apiRequest.fetchDetailFood(foodId);
  // }

}