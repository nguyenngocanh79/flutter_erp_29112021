import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/common/dio_client.dart';

class NghiphepApi{
  late Dio _dio;

  NghiphepApi() {
    _dio = DioClient.instance.dio;
  }

  Future<Response> fetchNghipheps() {
    return _dio.get("nghipheps");
  }

  Future<Response> fetchKieuNghipheps() {
    return _dio.get("kieunghipheps");
  }

  Future<Response> fetchNghiphepsCondition(String nhanvien, String tinhtrang, int id) {
    return _dio.get("nghipheps/conditions/$nhanvien/$tinhtrang/$id");
  }

  Future<Response> createNghiphep({required int nguoinghiid,int? nguoiduyetid,
    required int kieunghiid,required num thoiluong,required String tungay,required String denngay,
    String? mieuta,required String tinhtrang}) {
    return _dio.post("nghiphep", data:{
      "nguoinghiid": nguoinghiid,
      "nguoiduyetid":nguoiduyetid,
      "kieunghiid":kieunghiid,
      "thoiluong":thoiluong,
      "tungay":tungay,
      "denngay":denngay,
      "mieuta":mieuta,
      "tinhtrang":tinhtrang,
    });
  }

  Future<Response> updateNghiphep({required int id, int? nguoinghiid,int? nguoiduyetid,
    int? kieunghiid,num? thoiluong,String? tungay,String? denngay,
    String? mieuta, String? tinhtrang}) {
    return _dio.put("nghiphep/"+ id.toString(), data:{
      "nguoinghiid": nguoinghiid,
      "nguoiduyetid":nguoiduyetid,
      "kieunghiid":kieunghiid,
      "thoiluong":thoiluong,
      "tungay":tungay,
      "denngay":denngay,
      "mieuta":mieuta,
      "tinhtrang":tinhtrang,
    });
  }

  Future<Response> deleteNghiphep({required int id}) {
    return _dio.delete("nghiphep/"+ id.toString());
  }

  Future<Response> fetchNhanviencapduoi({required int id}) {
    return _dio.get("nhanviencapduoi/"+ id.toString());
  }

  Future<Response> fetchNghiphepCanduyet({required int id}) {
    return _dio.get("getsonghiphepcanduyet/"+ id.toString());
  }

  // Future<Response> fetchNhanviensTheoPhongban(String phongban) {
  //   return _dio.get("nhanviens/phongban/" + phongban);
  // }
  //
  // Future<Response> fetchPhongbans() {
  //   return _dio.get("phongbans");
  // }

}