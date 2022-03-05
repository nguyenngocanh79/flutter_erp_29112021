
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NhanvienDetailScreen extends StatefulWidget {
  const NhanvienDetailScreen({Key? key}) : super(key: key);

  @override
  _NhanvienDetailScreenState createState() => _NhanvienDetailScreenState();
}

class _NhanvienDetailScreenState extends State<NhanvienDetailScreen> {
  late NhanvienModel nhanvienModel;

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //Lấy session
    nhanvienModel = ModalRoute.of(context)!.settings.arguments as NhanvienModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nhân viên chi tiết"),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return _buildNhanvienDetail(nhanvienModel);
              }),
        ),
      ),
    );
  }

  Widget _buildNhanvienDetail(NhanvienModel nhanvienModel) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Text(nhanvienModel.hoten!,
              style: TextStyle(fontSize: 30),textAlign: TextAlign.center,)),
          ),
          Center(
            child: Container(
                // width: MediaQuery.of(context).size.width,
                // height: 350,
                child: Image.asset("assets/images/imagena.jpg",
                    width: 128, height: 128, fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Text("Chức vụ: ${nhanvienModel.chucvu!}",
                style: TextStyle(fontSize: 22)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text("Phòng ban: ${nhanvienModel.phongban!}",
                style: TextStyle(fontSize: 22)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text("Di động: ${nhanvienModel.email!}",
                style: TextStyle(fontSize: 22)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text("Email: ${nhanvienModel.email!}",
                style: TextStyle(fontSize: 22)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text("Giới tính: ${nhanvienModel.gioitinh!}",
                style: TextStyle(fontSize: 22)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text("Quản lý trực tiếp: ${nhanvienModel.quanlytructiep??""}",
                style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
    );
  }

}










