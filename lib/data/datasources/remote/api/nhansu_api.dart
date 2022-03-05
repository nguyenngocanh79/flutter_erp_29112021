import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/common/dio_client.dart';

class NhansuApi{
  late Dio _dio;

  NhansuApi() {
    _dio = DioClient.instance.dio;
  }

  Future<Response> fetchNhanviens() {
    return _dio.get("nhanviens");
  }

  Future<Response> fetchNhanviensTheoPhongban(String phongban) {
    return _dio.get("nhanviens/phongban/" + phongban);
  }

  Future<Response> fetchPhongbans() {
    return _dio.get("phongbans");
  }

  Future<Response> fetchNghiphepCanduyet({required int id}) {
    return _dio.get("getsonghiphepcanduyet/"+ id.toString());
  }

}