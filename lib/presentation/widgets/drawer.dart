import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp_29112021/common/app_constant.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';

class AppBarWidget extends AppBar {
  AppBarWidget({Key? key}) : super(key: key);
   AppBar buildAppBar(BuildContext context, {required String title, required bool hasMessage,
     TabBar? tabBar, List<Widget>? action}){
    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (BuildContext context) {
          return Badge(
            position: BadgePosition.topEnd(top:0,end:0),
            badgeContent: Text(" "),
            showBadge: hasMessage,
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          );
        },
      ),
      actions: [

        ...?action,
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed:
          () async {
            await SharePre.instance.removeSession();
            Navigator.pushReplacementNamed(context, "/sign-in");
          },
          // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ],
      bottom: tabBar,      // actions: [
      //     Badge(
      //       badgeContent: Text("3"),
      //       child: Icon(Icons.menu),
      //     ),
      //   ],
    );
  }

}

class DrawerWidget extends Drawer {
  const DrawerWidget({Key? key}) : super(key: key);
  Drawer builDrawer({required BuildContext context,
                    required List<String> menuNameList,
                    required List<VoidCallback> menuFunctionList,
                    required List<int> messageList}){
    return Drawer(
      backgroundColor: Color(0xFFEAFBF1),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              image: DecorationImage(
                image: AssetImage("assets/images/erp.png"),
                opacity: 0.5,
              ),
            ),
            child: Text('ERP FLUTTER',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white70)),
          ),
          ListTile(
            title: Text(menuNameList[0], style: TextStyle(fontSize: 20, color: Color(0xFF036785),),),
            onTap: menuFunctionList[0],
            // trailing: Container(
            //   padding: EdgeInsets.all(5.0),
            //   child: Text("4"),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     color: Colors.yellow[700],
            //   ),
            // ),
            trailing: Badge(
              badgeContent: Text(messageList[0].toString(), style: TextStyle(color: Colors.white,)),
              // padding: EdgeInsets.all(8),
              showBadge: messageList[0] ==0?false:true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(menuNameList[1], style: TextStyle(fontSize: 20, color: Color(0xFF036785),),),
            onTap: menuFunctionList[1],
            trailing: Badge(
              badgeContent: Text(messageList[1].toString(), style: TextStyle(color: Colors.white,)),
              // padding: EdgeInsets.all(8),
              showBadge: messageList[1] ==0?false:true,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

}


