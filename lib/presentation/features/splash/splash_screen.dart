import 'package:flutter/material.dart';
import 'package:flutter_erp_29112021/common/app_constant.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:lottie/lottie.dart';
class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blueGrey,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset(
                  'assets/animations/companygrowth.json',
                  animate: true,
                  repeat: true,
                  onLoaded: (complete){
                    Future.delayed(Duration(seconds: 2),() async{
                      // await SharePre.instance.remove(AppConstant.token);
                      // String? token = await SharePre.instance.get(AppConstant.token);
                      NhanvienModel session = await SharePre.instance.getSession();
                      if(session.token != null && session.token!.isNotEmpty) {
                        Navigator.pushReplacementNamed(context, "/home");
                      }else{
                        Navigator.pushReplacementNamed(context, "/sign-in");
                      }
                    });
                  }
              ),
              Text("ERP FLUTTER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      color: Colors.white70))
            ],
          )),
    );
  }
}