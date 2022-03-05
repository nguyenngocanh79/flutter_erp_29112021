import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/models/phongban_model.dart';
import 'package:flutter_erp_29112021/data/repositories/nhansu_repository.dart';

import 'nhansu_event.dart';
import 'nhansu_state.dart';

class NhansuBloc extends Bloc<NhansuEventBase,NhansuState>{

  late NhansuRepository _nhansuRepository;

  NhansuBloc(NhansuRepository repository) : super(NhansuState.initial()){
    _nhansuRepository = repository;

    // on<FetchListNhanvien>(_onFetchListNhanvien);
    on<FetchNhanviensTheoPhongban>(_onFetchNhanviensTheoPhongban);
    on<FetchListPhongban>(_onFetchListPhongban);
    on<ChangeMessageEvent>(_onChangeMessage);
    on<FetchSoNghiphepCanduyetEvent>(_onFetchSoNghiphepCanduyetEvent);

  }

  // Future<void> _onFetchListNhanvien(FetchListNhanvien event, Emitter<NhansuState> emit) async{
  //   try{
  //     emit(state.copyWith(status: NhansuStatus.loading));
  //     // await Future.delayed(const Duration(milliseconds: 1000),(){}); //Nhớ bỏ
  //     Response response = await _nhansuRepository.fetchNhanviens();
  //     if(response.statusCode == 200){
  //       if(response.data["data"] != null){
  //         List<NhanvienModel> nhanvienList = (response.data["data"] as List).map((e)=>NhanvienModel.fromJson(e)).toList();
  //         print(nhanvienList);//Nhớ bỏ
  //         // emit(state.copyWith(status: CartStatus.success,cartModel: cartModel,cartWork: CartWork.fetchListCart));
  //         emit(state.copyWith(status: NhansuStatus.fetchNhanvienSuccess,nhanvienList: nhanvienList,));
  //       }else{
  //         emit(state.copyWith(status: NhansuStatus.fetchNhanvienSuccess,nhanvienList: const [],));
  //       }
  //     }
  //   }on DioError catch(dioError){
  //     if(dioError.response != null){
  //       if (dioError.response!.statusCode == 404){
  //         // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: dioError.response!.data));
  //         // emit(NhansuState.fetchNhanvienListError(message: dioError.response!.data));
  //         emit(state.copyWith(status: NhansuStatus.fetchNhanvienFailure, message: dioError.response!.data));
  //       }else{
  //         // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: dioError.response!.data["message"]));
  //         // emit(NhansuState.fetchNhanvienListError(message: dioError.response!.data["message"]));
  //         emit(state.copyWith(status: NhansuStatus.fetchNhanvienFailure, message: dioError.response!.data["message"]));
  //       }
  //
  //     }
  //   }catch(e){
  //     // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: e.toString()));
  //     // emit(NhansuState.fetchNhanvienListError(message: e.toString()));
  //     emit(state.copyWith(status: NhansuStatus.fetchNhanvienFailure, message: e.toString()));
  //   }
  // }

  Future<void> _onFetchNhanviensTheoPhongban(FetchNhanviensTheoPhongban event, Emitter<NhansuState> emit) async{
    Response response;
    try{
      emit(state.copyWith(status: NhansuStatus.loading));
      // await Future.delayed(const Duration(milliseconds: 1000),(){}); //Nhớ bỏ
      if(event.phongban == "Tất cả phòng ban"){
        response = await _nhansuRepository.fetchNhanviens();
      } else {
        response = await _nhansuRepository.fetchNhanviensTheoPhongban(event.phongban);
      }

      if(response.statusCode == 200){
        if(response.data["data"] != null){
          List<NhanvienModel> nhanvienList = (response.data["data"] as List).map((e)=>NhanvienModel.fromJson(e)).toList();
          // print(nhanvienList);//Nhớ bỏ
          // emit(state.copyWith(status: CartStatus.success,cartModel: cartModel,cartWork: CartWork.fetchListCart));
          emit(state.copyWith(status: NhansuStatus.fetchNhanvienSuccess,nhanvienList: nhanvienList,
          dropDownValue: event.phongban));
        }else{
          emit(state.copyWith(status: NhansuStatus.fetchNhanvienSuccess,nhanvienList: const [],
              dropDownValue: event.phongban));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: dioError.response!.data));
          // emit(NhansuState.fetchNhanvienListError(message: dioError.response!.data));
          emit(state.copyWith(status: NhansuStatus.fetchNhanvienFailure, message: dioError.response!.data));
        }else{
          // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: dioError.response!.data["message"]));
          // emit(NhansuState.fetchNhanvienListError(message: dioError.response!.data["message"]));
          emit(state.copyWith(status: NhansuStatus.fetchNhanvienFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: e.toString()));
      // emit(NhansuState.fetchNhanvienListError(message: e.toString()));
      emit(state.copyWith(status: NhansuStatus.fetchNhanvienFailure, message: e.toString()));
    }
  }

  Future<void> _onFetchListPhongban(FetchListPhongban event, Emitter<NhansuState> emit) async{
    try{
      emit(state.copyWith(status: NhansuStatus.loading));
      // await Future.delayed(const Duration(milliseconds: 1000),(){}); //Nhớ bỏ
      Response response = await _nhansuRepository.fetchPhongbans();
      if(response.statusCode == 200){
        if(response.data["data"] != null){
          List<PhongbanModel> phongbanList = (response.data["data"] as List).map((e)=>PhongbanModel.fromJson(e)).toList();
          // print(phongbanList);//Nhớ bỏ
          emit(state.copyWith(status: NhansuStatus.fetchPhongbanSuccess,phongbanList: phongbanList,));
          // emit(NhansuState.fetchPhongbanListSuccess(phongbanList: phongbanList));
        }else{
          emit(state.copyWith(status: NhansuStatus.fetchPhongbanSuccess,phongbanList: const [],));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: dioError.response!.data));
          // emit(NhansuState.fetchPhongbanListError(message: dioError.response!.data));
          emit(state.copyWith(status: NhansuStatus.fetchPhongbanFailure, message: dioError.response!.data));
        }else{
          // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: dioError.response!.data["message"]));
          // emit(NhansuState.fetchPhongbanListError(message: dioError.response!.data["message"]));
          emit(state.copyWith(status: NhansuStatus.fetchPhongbanFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      // emit(state.copyWith(status: CartStatus.failure,cartWork: CartWork.fetchListCart,message: e.toString()));
      // emit(NhansuState.fetchPhongbanListError(message: e.toString()));
      emit(state.copyWith(status: NhansuStatus.fetchPhongbanFailure, message: e.toString()));
    }
  }

  Future<void>  _onChangeMessage(ChangeMessageEvent event, Emitter<NhansuState> emit) async{
    emit(state.copyWith(hasMessage: !state.hasMessage));
  }

  Future<void> _onFetchSoNghiphepCanduyetEvent(FetchSoNghiphepCanduyetEvent event, Emitter<NhansuState> emit) async{
    try{
      Response response = await _nhansuRepository.fetchNghiphepCanduyet(id: event.id);
      if(response.statusCode == 200){
        if(response.data["data"] != null){
          emit(state.copyWith(status: NhansuStatus.fetchSoNghiphepCanduyetSuccess, soNghiphepCanduyet: response.data["data"]));
        }
      }
    }on DioError catch(dioError){
      if(dioError.response != null){
        if (dioError.response!.statusCode == 404){
          emit(state.copyWith(status: NhansuStatus.fetchSoNghiphepCanduyetFailure, message: dioError.response!.data));
        }else{
          emit(state.copyWith(status: NhansuStatus.fetchSoNghiphepCanduyetFailure, message: dioError.response!.data["message"]));
        }

      }
    }catch(e){
      emit(state.copyWith(status: NhansuStatus.fetchSoNghiphepCanduyetFailure, message: e.toString()));
    }
  }

}

