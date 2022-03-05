import 'package:dio/dio.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';


class DioClient{
  Dio? _dio;
  static final BaseOptions _options = BaseOptions(
    baseUrl: "https://nodepostgrestest.herokuapp.com/",
    // baseUrl: "http://192.168.1.3:3000/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  static final DioClient instance = DioClient._internal();

  DioClient._internal() {
    if (_dio == null){
      _dio = Dio(_options);
      // _dio!.interceptors.add(LogInterceptor(requestBody: true));
      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async{
          // var token = await SharePre.instance.get("token");
          NhanvienModel session = await SharePre.instance.getSession();
          var token = session.token;
          if (token != null) {
            options.headers["Authorization"] = "Bearer " + token;
          }
          return handler.next(options);
        },
        onResponse: (e, handler) {
          return handler.next(e);
        },
        onError: (e, handler) {
          return handler.next(e);
        },
      ));
    }
  }

  Dio get dio => _dio!;
}