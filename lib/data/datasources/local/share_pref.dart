import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePre{
  SharePre._internal();

  static final SharePre _instance = SharePre._internal();

  static SharePre get instance {
    return _instance;
  }

  Future set(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  Future setSession(NhanvienModel nhanvienModel) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("id", nhanvienModel.id!);
    await preferences.setString("hoten", nhanvienModel.hoten!);
    await preferences.setString("email", nhanvienModel.email!);
    await preferences.setString("ngaysinh", nhanvienModel.ngaysinh!);
    await preferences.setString("gioitinh", nhanvienModel.gioitinh!);
    await preferences.setString("didong", nhanvienModel.didong!);
    await preferences.setString("chucvu", nhanvienModel.email!);
    await preferences.setInt("quanlytructiepid", nhanvienModel.quanlytructiepid??0);
    await preferences.setString("password", nhanvienModel.password!);
    await preferences.setString("phongbanid", nhanvienModel.phongbanid!);
    await preferences.setString("quanlytructiep", nhanvienModel.quanlytructiep??"");
    await preferences.setString("phongban", nhanvienModel.phongban!);
    await preferences.setString("token", nhanvienModel.token!);

  }

  dynamic get(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  //Các biến id, hoten... của NhanvienModel đều là nullable
  Future<NhanvienModel> getSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return NhanvienModel(
      id: preferences.getInt("id"),
      hoten: preferences.getString("hoten"),
      email: preferences.getString("email"),
      ngaysinh: preferences.getString("ngaysinh"),
      gioitinh: preferences.getString("gioitinh"),
      didong: preferences.getString("didong"),
      chucvu: preferences.getString("chucvu"),
      quanlytructiepid: preferences.getInt("quanlytructiepid"),
      password: preferences.getString("password"),
      phongbanid: preferences.getString("phongbanid"),
      quanlytructiep: preferences.getString("quanlytructiep"),
      phongban: preferences.getString("phongban"),
      token: preferences.getString("token"),
    );
  }

  Future remove(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  Future removeSession() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("id");
    await preferences.remove("hoten");
    await preferences.remove("email");
    await preferences.remove("ngaysinh");
    await preferences.remove("gioitinh");
    await preferences.remove("didong");
    await preferences.remove("chucvu");
    await preferences.remove("quanlytructiepid");
    await preferences.remove("password");
    await preferences.remove("phongbanid");
    await preferences.remove("quanlytructiep");
    await preferences.remove("phongban");
    await preferences.remove("token");

  }

  void clearSPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

}