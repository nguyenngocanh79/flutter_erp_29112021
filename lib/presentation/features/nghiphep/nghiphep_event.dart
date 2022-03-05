import 'package:equatable/equatable.dart';

abstract class NghiphepEventBase extends Equatable {
}

class FetchListNghiphepEvent extends NghiphepEventBase {
  @override
  List<Object?> get props => [];

}

class ChangeDropdownValueEvent extends NghiphepEventBase {
  final String dropdownNhanvienValue;
  final String dropdownTinhtrangValue;
  final int id;

  ChangeDropdownValueEvent(
      {required this.dropdownNhanvienValue, required this.dropdownTinhtrangValue, required this.id});

  @override
  List<Object?> get props => [dropdownNhanvienValue,dropdownTinhtrangValue ];

}

class CreateNghiphepEvent extends NghiphepEventBase {
  final int nguoinghiid;
  final int? nguoiduyetid;
  final int kieunghiid;
  final num thoiluong;
  final String tungay;
  final String denngay;
  final String? mieuta;
  final String tinhtrang;

  CreateNghiphepEvent(
      {required this.nguoinghiid,this.nguoiduyetid,
        required this.kieunghiid,required this.thoiluong,
        required this.tungay,required this.denngay,
        this.mieuta,required this.tinhtrang});

  @override
  List<Object?> get props => [nguoinghiid, nguoiduyetid, kieunghiid, thoiluong, tungay, denngay, mieuta,tinhtrang ];

}

class UpdateNghiphepEvent extends NghiphepEventBase {
  final int id;
  final int? nguoinghiid;
  final int? nguoiduyetid;
  final int? kieunghiid;
  final num? thoiluong;
  final String? tungay;
  final String? denngay;
  final String? mieuta;
  final String? tinhtrang;
  final bool isApproving;
  final int? nguoiduocduyetid;

  UpdateNghiphepEvent(
      {required this.id, this.nguoinghiid,this.nguoiduyetid,
        this.kieunghiid,this.thoiluong,
        this.tungay,this.denngay,
        this.mieuta,this.tinhtrang, required this.isApproving, this.nguoiduocduyetid});

  @override
  List<Object?> get props => [id, nguoinghiid, nguoiduyetid, kieunghiid, thoiluong, tungay, denngay, mieuta,tinhtrang, isApproving, nguoiduocduyetid ];

}

class DeleteNghiphepEvent extends NghiphepEventBase {
  final int id;

  DeleteNghiphepEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class FetchNhaniencapduoiEvent extends NghiphepEventBase {
  final int id;

  FetchNhaniencapduoiEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class FetchSoNghiphepCanduyetEvent extends NghiphepEventBase {
  final int id;

  FetchSoNghiphepCanduyetEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ChangeMessageEvent extends NghiphepEventBase {
  @override
  List<Object?> get props => [];

}

class AddSocketEvent extends NghiphepEventBase {
  @override
  List<Object?> get props => [];

}




