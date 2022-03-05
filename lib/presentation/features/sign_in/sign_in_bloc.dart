import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/repositories/authentication_repository.dart';
import 'package:flutter_erp_29112021/presentation/features/sign_in/sign_in_event.dart';
import 'package:flutter_erp_29112021/presentation/features/sign_in/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEventBase,SignInStateBase>{
  late AuthenticationRepository _repository;

  SignInBloc(AuthenticationRepository repository) : super(SignInStateInit()){
    _repository = repository;

    on<SignInEvent>((event, emit) async{
      try{
        emit(SignInLoading());
        // //KHÔNG được để Response<T> vì khi đó hàm fromJson sẽ báo lỗi giữa Map và T
        // Response response = await _repository.signIn(event.email,event.password);
        // if(response.statusCode == 200){
        //   UserModel model = UserModel.fromJson(response.data["data"]);
        //   await SharePre.instance.set(AppConstant.token, model.token);
        //   emit(SignInSuccess("Dang nhap thanh cong, token là: ${model.token}"));
        // }
        //KHÔNG được để Response<T> vì khi đó hàm fromJson sẽ báo lỗi giữa Map và T
        Response response = await _repository.signIn(event.email, event.password);
        if(response.statusCode == 200){
          //response là 1 JSON
          NhanvienModel nhanvienModel = NhanvienModel.fromJson(response.data["data"]);
          // await SharePre.instance.set(AppConstant.token, nhanvienModel.token!);
          await SharePre.instance.setSession(nhanvienModel);
          emit(SignInSuccess("Dang nhap thanh cong, token là: ${nhanvienModel.token}"));
        }
      }on DioError catch(dioError){
        emit(SignInError("(DioError là) " + dioError.response!.data["message"]));
      }catch(e){
        emit(SignInError(e.toString()));
      }
    });
  }

}