import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/authentication_api.dart';
import 'package:flutter_erp_29112021/data/repositories/authentication_repository.dart';
import 'package:flutter_erp_29112021/presentation/features/sign_in/sign_in_bloc.dart';
import 'package:flutter_erp_29112021/presentation/features/sign_in/sign_in_event.dart';
import 'package:flutter_erp_29112021/presentation/features/sign_in/sign_in_state.dart';
import 'package:flutter_erp_29112021/presentation/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
class SignInScreen extends StatefulWidget {

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: MultiProvider(
          providers: [
            Provider(create: (context) => AuthenticationApi()),
            ProxyProvider<AuthenticationApi,AuthenticationRepository>(
              create: (context) => AuthenticationRepository(context.read<AuthenticationApi>()),
              update: (context ,api , repository){
                return AuthenticationRepository(api);
              },
            ),
            ProxyProvider<AuthenticationRepository,SignInBloc>(
              create: (context) => SignInBloc(context.read<AuthenticationRepository>()),
              update: (context ,repository , bloc){
                return SignInBloc(repository);
              },
            ),
          ],
          child: SignInContainerWidget()
      ),
    );
  }
}

class SignInContainerWidget extends StatefulWidget {
  const SignInContainerWidget({Key? key}) : super(key: key);

  @override
  _SignInContainerWidgetState createState() => _SignInContainerWidgetState();
}

class _SignInContainerWidgetState extends State<SignInContainerWidget> {

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  var isPassVisible = true;

  late SignInBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<SignInBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<SignInBloc,SignInStateBase>(
          bloc: bloc,
          listener: (context, state){
            if(state is SignInSuccess){
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pushReplacementNamed(context, "/home");
            }
            if(state is SignInError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: " + state.message)));
            }
          },
          builder: (context , state){
            return Container(
              color: Color(0xd433FFD4),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          flex: 2, child: Image.asset("assets/images/erp.png")),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPhoneTextField(),
                              _buildPasswordTextField(),
                              _buildButtonSignIn(),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(child: _buildTextSignUp()),
                    ],
                  ),
                  if(state is SignInLoading)
                    Center(child: LoadingWidget())
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildTextSignUp() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account!"),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/sign-up");
              },
              child: Text("Sign Up",
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.underline)),
            )
          ],
        ));
  }

  Widget _buildPhoneTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Color(0xFF39E8C3),
          filled: true,
          hintText: "Email",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: Icon(Icons.email, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _passController,
        obscureText: isPassVisible,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Color(0xFF39E8C3),
          filled: true,
          hintText: "PassWord",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn() {
    return Container(
        margin: EdgeInsets.only(top: 20),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue,),
          onPressed: (){
            String email = _emailController.text.toString();
            String password = _passController.text.toString();

            bloc.add(SignInEvent(email: email, password: password));
          },
          child: Text("Sign In"),
        )
    );
  }
}