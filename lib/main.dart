import 'package:flutter/material.dart';
import 'package:flutter_erp_29112021/presentation/features/home/home_screen.dart';
import 'package:flutter_erp_29112021/presentation/features/home/nhanvien_detail_screen.dart';
import 'package:flutter_erp_29112021/presentation/features/nghiphep/nghiphep_create_screen.dart';
import 'package:flutter_erp_29112021/presentation/features/nghiphep/nghiphep_screen.dart';
import 'package:flutter_erp_29112021/presentation/features/sign_in/sign_in_screen.dart';
import 'package:flutter_erp_29112021/presentation/features/splash/splash_screen.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
// const URI_SERVER = "http://192.168.1.3:3000/";
const URI_SERVER = "https://nodepostgrestest.herokuapp.com/";
late IO.Socket mainSocket;
void main() {
  mainSocket = IO.io(
      URI_SERVER,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setExtraHeaders({'foo': 'bar'}) // optional
          .build());
  mainSocket.onConnect((_) {
    print('connect');
  });
  mainSocket.onDisconnect((_) => print('disconnect'));
  mainSocket.on('fromServer', (data) => print(data) );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({Key? key, }) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/sign-in" : (context) => SignInScreen(),
        "/home" : (context) => HomeScreen(),
        "/splash" : (context) => SplashScreen(),
        "/nhanvien_detail" : (context) => NhanvienDetailScreen(),
        "/nghiphep" : (context) => NghiphepScreen(),
        "/nghiphep/create" : (context) => NghiphepCreateScreen(isCreate: true,),
        "/nghiphep/update" : (context) => NghiphepCreateScreen(isCreate: false,),

      },
      initialRoute: "/splash",

    );

  }
}
