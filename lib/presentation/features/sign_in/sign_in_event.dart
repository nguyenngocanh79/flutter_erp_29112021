import 'package:equatable/equatable.dart';

abstract class SignInEventBase extends Equatable{}


class SignInEvent extends SignInEventBase{

  late String email;
  late String password;

  SignInEvent({required this.email , required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email,password];

}