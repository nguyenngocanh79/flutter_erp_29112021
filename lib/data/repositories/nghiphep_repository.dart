import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/nghiphep_api.dart';

class NghiphepRepository{
  late NghiphepApi _apiRequest;

  NghiphepRepository(NghiphepApi api){
    _apiRequest = api;
  }

  Future<Response> fetchNghipheps(){
    return _apiRequest.fetchNghipheps();
  }

  Future<Response> fetchKieuNghipheps(){
    return _apiRequest.fetchKieuNghipheps();
  }

  Future<Response> fetchNghiphepsCondition(String nhanvien, String tinhtrang, int id){
    return _apiRequest.fetchNghiphepsCondition(nhanvien, tinhtrang, id);
  }

  Future<Response> createNghiphep({required int nguoinghiid,int? nguoiduyetid,
    required int kieunghiid,required num thoiluong,required String tungay,required String denngay,
    String? mieuta,required String tinhtrang}){
    return _apiRequest.createNghiphep(
      nguoinghiid: nguoinghiid,
      nguoiduyetid:nguoiduyetid,
      kieunghiid:kieunghiid,
      thoiluong:thoiluong,
      tungay:tungay,
      denngay:denngay,
      mieuta:mieuta,
      tinhtrang:tinhtrang,
    );
  }

  Future<Response> updateNghiphep({required int id, int? nguoinghiid,int? nguoiduyetid,
    int? kieunghiid,num? thoiluong,String? tungay,String? denngay,
    String? mieuta,String? tinhtrang}){
    return _apiRequest.updateNghiphep(
      id: id,
      nguoinghiid: nguoinghiid,
      nguoiduyetid:nguoiduyetid,
      kieunghiid:kieunghiid,
      thoiluong:thoiluong,
      tungay:tungay,
      denngay:denngay,
      mieuta:mieuta,
      tinhtrang:tinhtrang,
    );
  }

  Future<Response> deleteNghiphep({required int id}){
    return _apiRequest.deleteNghiphep(id: id);
  }

  Future<Response> fetchNhanviencapduoi({required int id}){
    return _apiRequest.fetchNhanviencapduoi(id: id);
  }

  Future<Response> fetchNghiphepCanduyet({required int id}){
    return _apiRequest.fetchNghiphepCanduyet(id: id);
  }


}