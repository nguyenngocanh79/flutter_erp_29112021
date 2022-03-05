import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/data/models/nghiphep_model.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/repositories/nghiphep_repository.dart';

import 'nghiphep_event.dart';
import 'nghiphep_state.dart';

class NghiphepBloc extends Bloc<NghiphepEventBase,NghiphepState>{

  late NghiphepRepository _nghiphepRepository;

  NghiphepBloc(NghiphepRepository repository) : super(NghiphepState.initial()){
    _nghiphepRepository = repository;

    on<FetchListNghiphepEvent>(_onFetchListNghiphep);
    on<ChangeDropdownValueEvent>(_onChangeDropdownValue);
    // on<FetchNhaniencapduoiEvent>(_onFetchNhaniencapduoiEvent);
    on<CreateNghiphepEvent>(_onCreateNghiphepEvent);
    on<UpdateNghiphepEvent>(_onUpdateNghiphepEvent);
    on<DeleteNghiphepEvent>(_onDeleteNghiphepEvent);
    on<FetchSoNghiphepCanduyetEvent>(_onFetchSoNghiphepCanduyetEvent);
    on<ChangeMessageEvent>(_onChangeMessage);
  }

  Future<void> _onFetchListNghiphep(FetchListNghiphepEvent event, Emitter<NghiphepState> emit) async{
    try{
      emit(state.copyWith(status: NghiphepStatus.loading));
      Response response = await _nghiphepRepository.fetchNghipheps();
      if(response.statusCode == 200){
        if(response.data["data"] != null){
          List<NghiphepModel> nghiphepList = (response.data["data"] as List).map((e)=>NghiphepModel.fromJson(e)).toList();

          // print("Số nghỉ phép: " + nghiphepList.toString());
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepSuccess,nghiphepList: nghiphepList,));
        }else{
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepSuccess,nghiphepList: const [],));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: e.toString()));
    }
  }

  Future<void> _onChangeDropdownValue(ChangeDropdownValueEvent event, Emitter<NghiphepState> emit) async{
    // var dropdownNguoinghiValue = "";
    try{
      emit(state.copyWith(status: NghiphepStatus.loading));

      // if (event.dropdownNhanvienValue == "Tất cả") {
      //   dropdownNguoinghiValue = event.dropdownNhanvienValue;
      // } else {
      //   NhanvienModel session = await SharePre.instance.getSession();
      //   if(session.id != null){
      //     dropdownNguoinghiValue = session.id!.toString();
      //   }
      // }
      Response response = await _nghiphepRepository.fetchNghiphepsCondition(event.dropdownNhanvienValue, event.dropdownTinhtrangValue, event.id );
      if(response.statusCode == 200){
        if(response.data["data"] != null){
          List<NghiphepModel> nghiphepList = (response.data["data"] as List).map((e)=>NghiphepModel.fromJson(e)).toList();

          // print("Số nghỉ phép: " + nghiphepList.toString());
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepSuccess,nghiphepList: nghiphepList,
          dropdownNhanvienValue: event.dropdownNhanvienValue, dropdownTinhtrangValue: event.dropdownTinhtrangValue));
        }else{
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepSuccess,nghiphepList: const [],
              dropdownNhanvienValue: event.dropdownNhanvienValue, dropdownTinhtrangValue: event.dropdownTinhtrangValue));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: e.toString()));
    }
  }

  // Future<void> _onFetchNhaniencapduoiEvent(FetchNhaniencapduoiEvent event, Emitter<NghiphepState> emit) async{
  //   // var dropdownNguoinghiValue = "";
  //   try{
  //     // emit(state.copyWith(status: NghiphepStatus.loading));
  //     Response response = await _nghiphepRepository.fetchNghiphepsCondition(event.dropdownNhanvienValue, event.dropdownTinhtrangValue, event.id );
  //     if(response.statusCode == 200){
  //       if(response.data["data"] != null){
  //         List<NghiphepModel> nghiphepList = (response.data["data"] as List).map((e)=>NghiphepModel.fromJson(e)).toList();
  //
  //         // print("Số nghỉ phép: " + nghiphepList.toString());
  //         emit(state.copyWith(status: NghiphepStatus.fetchNghiphepSuccess,nghiphepList: nghiphepList,
  //             dropdownNhanvienValue: event.dropdownNhanvienValue, dropdownTinhtrangValue: event.dropdownTinhtrangValue));
  //       }else{
  //         emit(state.copyWith(status: NghiphepStatus.fetchNghiphepSuccess,nghiphepList: const [],
  //             dropdownNhanvienValue: event.dropdownNhanvienValue, dropdownTinhtrangValue: event.dropdownTinhtrangValue));
  //       }
  //     }
  //   }on DioError catch(dioError){
  //     if(dioError.response != null){
  //       if (dioError.response!.statusCode == 404){
  //         emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: dioError.response!.data));
  //       }else{
  //         emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: dioError.response!.data["message"]));
  //       }
  //
  //     }
  //   }catch(e){
  //     emit(state.copyWith(status: NghiphepStatus.fetchNghiphepFailure, message: e.toString()));
  //   }
  // }

  Future<void> _onCreateNghiphepEvent(CreateNghiphepEvent event, Emitter<NghiphepState> emit) async{
    try{
      emit(state.copyWith(status: NghiphepStatus.loading));
      Response response = await _nghiphepRepository.createNghiphep(
          nguoinghiid: event.nguoinghiid, kieunghiid: event.kieunghiid,
          thoiluong: event.thoiluong, tungay: event.tungay,
          denngay: event.denngay, mieuta: event.mieuta, tinhtrang: event.tinhtrang);
      if(response.statusCode == 200){
        if(response.data["msg"] == "OK"){
          emit(state.copyWith(status: NghiphepStatus.createNghiphepSucess));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NghiphepStatus.createNghiphepFailure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NghiphepStatus.createNghiphepFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NghiphepStatus.createNghiphepFailure, message: e.toString()));
    }
  }

  Future<void> _onUpdateNghiphepEvent(UpdateNghiphepEvent event, Emitter<NghiphepState> emit) async{
    try{
      emit(state.copyWith(status: NghiphepStatus.loading));
      Response response = await _nghiphepRepository.updateNghiphep(
          id: event.id,
          nguoinghiid: event.nguoinghiid,
          nguoiduyetid: event.nguoiduyetid,
          kieunghiid: event.kieunghiid,
          thoiluong: event.thoiluong,
          tungay: event.tungay,
          denngay: event.denngay,
          mieuta: event.mieuta,
          tinhtrang: event.tinhtrang);
      if(response.statusCode == 200){
        if(response.data["msg"] == "OK"){
          emit(state.copyWith(status: NghiphepStatus.updateNghiphepSuccess,
              isApproving: event.isApproving, nguoiduocduyetid: event.nguoiduocduyetid));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NghiphepStatus.updateSuccessFaiure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NghiphepStatus.updateSuccessFaiure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NghiphepStatus.updateSuccessFaiure, message: e.toString()));
    }
  }

  Future<void> _onDeleteNghiphepEvent(DeleteNghiphepEvent event, Emitter<NghiphepState> emit) async{
    try{
      emit(state.copyWith(status: NghiphepStatus.loading));
      Response response = await _nghiphepRepository.deleteNghiphep(id: event.id);
      if(response.statusCode == 200){
        if(response.data["msg"] == "OK"){
          emit(state.copyWith(status: NghiphepStatus.deleteNghiphepSucess));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NghiphepStatus.deleteNghiphepFailure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NghiphepStatus.deleteNghiphepFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NghiphepStatus.deleteNghiphepFailure, message: e.toString()));
    }
  }

  Future<void> _onFetchSoNghiphepCanduyetEvent(FetchSoNghiphepCanduyetEvent event, Emitter<NghiphepState> emit) async{
    try{
      Response response = await _nghiphepRepository.fetchNghiphepCanduyet(id: event.id);
      if(response.statusCode == 200){
        if(response.data["data"] != null){
          emit(state.copyWith(status: NghiphepStatus.fetchSoNghiphepCanduyetSuccess, soNghiphepCanduyet: response.data["data"]));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NghiphepStatus.fetchSoNghiphepCanduyetFailure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NghiphepStatus.fetchSoNghiphepCanduyetFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NghiphepStatus.fetchSoNghiphepCanduyetFailure, message: e.toString()));
    }
  }

  Future<void>  _onChangeMessage(ChangeMessageEvent event, Emitter<NghiphepState> emit) async{
    emit(state.copyWith(hasMessage: !state.hasMessage));
  }



}

