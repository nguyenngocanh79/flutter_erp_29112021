import 'package:equatable/equatable.dart';
import 'package:flutter_erp_29112021/data/models/nghiphep_model.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';

enum NghiphepStatus { initial, loading, fetchNghiphepSuccess,  fetchNghiphepFailure,
  createNghiphepSucess, createNghiphepFailure, updateNghiphepSuccess, updateSuccessFaiure,
  deleteNghiphepSucess, deleteNghiphepFailure, fetchSoNghiphepCanduyetSuccess, fetchSoNghiphepCanduyetFailure
 }

class NghiphepState extends Equatable {
  NghiphepStatus? status;
  List<NghiphepModel> nghiphepList;
  String dropdownNhanvienValue = "Tất cả";
  String dropdownTinhtrangValue = "Tất cả";
  List<NhanvienModel> nhanviencapduoiList;
  int soNghiphepCanduyet;
  bool isApproving = false;
  int nguoiduocduyetid =0;

  String? message;

  bool hasMessage;

  NghiphepState._({this.status, this.nghiphepList = const [], this.nhanviencapduoiList = const [],
    this.isApproving = false, this.nguoiduocduyetid =0,
    this.dropdownNhanvienValue = "Tất cả", this.dropdownTinhtrangValue = "Tất cả",
    this.soNghiphepCanduyet = 0, this.message, this.hasMessage = true});

  NghiphepState copyWith({NghiphepStatus? status, List<NghiphepModel>? nghiphepList,
    List<NhanvienModel>? nhanviencapduoiList,
    String? dropdownNhanvienValue,String? dropdownTinhtrangValue, int? soNghiphepCanduyet,
    bool? isApproving, int? nguoiduocduyetid,
    String? message,bool? hasMessage }) {
    return NghiphepState._(
      status: status ?? this.status,
      nghiphepList: nghiphepList ?? this.nghiphepList,
      nhanviencapduoiList: nhanviencapduoiList ?? this.nhanviencapduoiList,

      dropdownNhanvienValue: dropdownNhanvienValue ?? this.dropdownNhanvienValue,
      dropdownTinhtrangValue: dropdownTinhtrangValue ?? this.dropdownTinhtrangValue,
      soNghiphepCanduyet: soNghiphepCanduyet ?? this.soNghiphepCanduyet,
      isApproving: isApproving ?? this.isApproving,
      nguoiduocduyetid: nguoiduocduyetid ?? this.nguoiduocduyetid,
      hasMessage: hasMessage ?? this.hasMessage,
      message: message ?? this.message,

    );
  }

  NghiphepState.initial() : this._(status : NghiphepStatus.initial);

  @override
  List<Object?> get props => [status,nghiphepList, nhanviencapduoiList,
    dropdownNhanvienValue, dropdownTinhtrangValue, soNghiphepCanduyet, isApproving, nguoiduocduyetid,
    message,hasMessage];
}