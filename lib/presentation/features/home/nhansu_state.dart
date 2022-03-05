import 'package:equatable/equatable.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/models/phongban_model.dart';

enum NhansuStatus { initial, loading, fetchNhanvienSuccess,  fetchNhanvienFailure,
  fetchPhongbanSuccess,  fetchPhongbanFailure, fetchSoNghiphepCanduyetSuccess, fetchSoNghiphepCanduyetFailure}

class NhansuState extends Equatable {
  NhansuStatus? status;
  List<NhanvienModel> nhanvienList;
  List<PhongbanModel> phongbanList;
  String dropDownValue = "Tất cả phòng ban";
  int soNghiphepCanduyet;
  String? message;

  bool hasMessage;

  NhansuState._({this.status, this.nhanvienList = const [],
    this.phongbanList = const [],this.dropDownValue = "Tất cả phòng ban",
    this.soNghiphepCanduyet = 0, this.message, this.hasMessage = true});

  NhansuState copyWith({NhansuStatus? status, List<NhanvienModel>? nhanvienList, int? soNghiphepCanduyet,
    List<PhongbanModel>? phongbanList,String? dropDownValue, String? message,bool? hasMessage }) {
    return NhansuState._(
      hasMessage: hasMessage ?? this.hasMessage,
      status: status ?? this.status,
      nhanvienList: nhanvienList ?? this.nhanvienList,
      phongbanList: phongbanList ?? this.phongbanList,
      dropDownValue: dropDownValue ?? this.dropDownValue,
      message: message ?? this.message,
      soNghiphepCanduyet: soNghiphepCanduyet ?? this.soNghiphepCanduyet,

    );
  }

  NhansuState.initial() : this._(status : NhansuStatus.initial);
  // NhansuState.loading() : this._(status : NhansuStatus.loading);
  // NhansuState.fetchNhanvienListSuccess({required List<NhanvienModel> nhanvienList}) : this._(nhanvienList: nhanvienList,status : NhansuStatus.fetchNhanvienSuccess);
  // NhansuState.fetchNhanvienListError({required String? message}) : this._(message: message ,status : NhansuStatus.fetchNhanvienFailure);
  // NhansuState.fetchPhongbanListSuccess({required List<PhongbanModel> phongbanList}) : this._(phongbanList: phongbanList,status : NhansuStatus.fetchPhongbanSuccess);
  // NhansuState.fetchPhongbanListError({required String? message}) : this._(message: message ,status : NhansuStatus.fetchPhongbanFailure);
  // CartState.updateCartSuccess() : this._(status : CartStatus.updateSuccess);
  // CartState.updateCartError({required String? message}) : this._(message: message ,status : CartStatus.failure);
  // CartState.deleteItemError({required String? message}) : this._(message: message ,status : CartStatus.failure);
  // NhansuState.changeMessage(bool hasMessage): this._(hasMessage: hasMessage); //Test only

  @override
  List<Object?> get props => [status,nhanvienList,phongbanList,dropDownValue,message,hasMessage, soNghiphepCanduyet];
}