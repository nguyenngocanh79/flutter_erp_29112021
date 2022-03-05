
import 'package:badges/badges.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/nhansu_api.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/models/phongban_model.dart';
import 'package:flutter_erp_29112021/data/repositories/nhansu_repository.dart';
import 'package:flutter_erp_29112021/presentation/widgets/drawer.dart';
import 'package:flutter_erp_29112021/presentation/widgets/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'nhansu_bloc.dart';
import 'nhansu_event.dart';
import 'nhansu_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => NhansuApi()),
        ProxyProvider<NhansuApi, NhansuRepository>(
          create: (context) => NhansuRepository(context.read<NhansuApi>()),
          update: (context, api, repository) {
            return NhansuRepository(api);
          },
        ),
        ProxyProvider<NhansuRepository, NhansuBloc>(
          create: (context) => NhansuBloc(context.read<NhansuRepository>()),
          update: (context, nhansuRepository, bloc) {
            return NhansuBloc(nhansuRepository);
          },
        ),
      ],
      child: HomeScreenContainer(),
    );
  }
}

class HomeScreenContainer extends StatefulWidget {
  HomeScreenContainer({Key? key,}) : super(key: key);

  @override
  _HomeScreenContainerState createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends State<HomeScreenContainer> with AutomaticKeepAliveClientMixin{
  late NhansuBloc nhansuBloc;
  AppBarWidget appBarWidget = new AppBarWidget();
  DrawerWidget drawerWidget = new DrawerWidget();
  String dropDownValue1 = "Tất cả phòng ban";
  late NhanvienModel session;


  @override
  void initState() {
    super.initState();
    nhansuBloc = context.read<NhansuBloc>();
    // nhansuBloc.add(FetchListNhanvien());

    SharePre.instance.getSession()
      .then((res){
        session = res;
        nhansuBloc.add(FetchNhanviensTheoPhongban(phongban: "Tất cả phòng ban"));
        nhansuBloc.add(FetchListPhongban());
        nhansuBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));

        //Đăng ký tên với Socket IO
        mainSocket.emit('session', session);
        // mainSocket.on('Server gửi lệnh tạo Nghỉ phép thành công', (data) =>
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data))));

        mainSocket.on('Server gửi lệnh thay đổi Nghỉ phép thành công', (data) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data+ ": Nhân sự")));
          //Fetch Số nghỉ phép cần duyệt
          nhansuBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));
        });
    });

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Home"),
    //     actions: [
    //       BlocConsumer<HomeCartBloc, HomeStateBase>(
    //         bloc: cartBloc,
    //         listener: (context, state) {
    //           if (state is FetchTotalError) {
    //             if (state.code == 401) {
    //               ScaffoldMessenger.of(context)
    //                   .showSnackBar(SnackBar(content: Text(state.message)));
    //               Navigator.pushReplacementNamed(context, "/sign-in");
    //             }
    //           }
    //         },
    //         builder: (context, state) {
    //           if (state is FetchTotalSuccess) {
    //             return InkWell(
    //               onTap: () {
    //                 Navigator.pushNamed(context, '/cart',
    //                         arguments: state.cartModel.orderId)
    //                     .then((value) => cartBloc.add(FetchTotalCart()));
    //               },
    //               child: Container(
    //                 margin: EdgeInsets.only(right: 30, top: 10),
    //                 child: Badge(
    //                   badgeContent: Text(state.cartModel.total.toString()),
    //                   child: Icon(Icons.shopping_cart_outlined),
    //                 ),
    //               ),
    //             );
    //           }
    //           if (state is FetchTotalError) {
    //             if (state.code == 404) {
    //               return InkWell(
    //                 onTap: () {
    //                   Navigator.pushNamed(context, '/cart');
    //                 },
    //                 child: Container(
    //                     margin: EdgeInsets.only(right: 30, top: 10),
    //                     child: Icon(Icons.shopping_cart_outlined)),
    //               );
    //             }
    //           }
    //           return SizedBox();
    //         },
    //       )
    //     ],
    //   ),
    //   body: SafeArea(
    //     child: Container(
    //       child: BlocConsumer<HomeFoodBloc, HomeStateBase>(
    //         bloc: foodBloc,
    //         listener: (context, state) {},
    //         builder: (context, state) {
    //           if (state is FetchListFoodSuccess) {
    //             return ListView.builder(
    //                 itemCount: state.listFoods.length,
    //                 itemBuilder: (context, index) {
    //                   return InkWell(
    //                       child: _buildItemFood(state.listFoods[index]),
    //                       onTap: () {
    //                         Navigator.pushNamed(context, "/food_detail",
    //                             arguments: state.listFoods[index].foodId);
    //                       });
    //                 });
    //           } else if (state is HomeStateLoading) {
    //             return Center(child: LoadingWidget());
    //           } else if (state is FetchListFoodError) {
    //             return Center(child: Text(state.message));
    //           } else {
    //             return SizedBox();
    //           }
    //         },
    //       ),
    //     ),
    //   ),
    // );
    return BlocConsumer<NhansuBloc,NhansuState>(
        bloc: nhansuBloc,
        builder: (context,state){
          return DefaultTabController(
            length: 2,
            child: Scaffold(

              appBar: appBarWidget.buildAppBar(
                  context,
                  title: "Nhân sự",
                  hasMessage: state.soNghiphepCanduyet>0,
                  tabBar: const TabBar(
                  tabs: [
                    // Tab(icon: Icon(Icons.directions_car)),
                    // Tab(icon: Icon(Icons.directions_transit)),
                    Tab(text:"Nhân viên"),
                    Tab(text:"Phòng ban")
                  ],
                ),
              ),
              drawer: drawerWidget.builDrawer(
                    context: context,
                    menuNameList: ["Nhân sự","Nghỉ phép"],
                    menuFunctionList: [
                      () => Navigator.pop(context),
                      () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/nghiphep")
                            .then((value){nhansuBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));});
                        },
                    ],
                    messageList: [0,state.soNghiphepCanduyet],
              ),
              // body: NhanvienContainer(context, state),
              body: TabBarView(
                children: [
                  NhanvienContainer(context, state),
                  PhongbanContainer(context, state),
                ],
              ),
              // body: Container(child: Text("ffdsafdsa"),),
            ),
          );

        },
        listener: (context,state){

        },
    );
  }

  Widget NhanvienContainer(BuildContext context,NhansuState state ){
    if(state.status == NhansuStatus.fetchNhanvienFailure){
      return Center(child: Text(state.message.toString()));
    }
    else {

      if(state.nhanvienList.isEmpty){
        if(state.status == NhansuStatus.loading){
          return Center(child: LoadingWidget());
        } else if(state.status != NhansuStatus.fetchNhanvienSuccess){
          return const SizedBox();
        } else {
          return Column(
            children: [
              _buildDropdown(state),
              Expanded(child: Center(child:  Text("Chưa có nhân viên", style: TextStyle(fontSize: 20),)  ),)
            ],
          );
        }

      }
      else {
        return Column(
          children: [
            _buildDropdown(state),
            Expanded(
              child: ListView.builder(
                  itemCount: state.nhanvienList.length,
                  itemBuilder: (lstContext, index) {
                    return InkWell(
                      child: _buildItemNhanvien(state.nhanvienList[index], context),
                      onTap: () {Navigator.pushNamed(context, "/nhanvien_detail",
                          arguments: state.nhanvienList[index]);}

                    );
                  }
              ),
            ),

          ],
        );

      }
    }

  }

  Widget _buildDropdown(NhansuState state){
    // print("Build Dropdown");
    List<String> phongbanitems = ["Tất cả phòng ban"];
    phongbanitems.addAll(state.phongbanList.map((e)=>e.tenphong!).toList());
    // String dropDownValue = phongbanitems.first;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 12,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0x4D33FFD4),
          border: Border.all(color: Colors.green),
        ),

        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: phongbanitems.map((item) => DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              )).toList(),
              value: state.dropDownValue,
              onChanged: (value){
                nhansuBloc.add(FetchNhanviensTheoPhongban(phongban: value!));

                },
            )
        ),
      ),
    );

  }

  Widget PhongbanContainer(BuildContext context,NhansuState state ){
    if(state.status == NhansuStatus.fetchPhongbanFailure){
      return Center(child: Text(state.message.toString()));
    }
    else {

      if(state.phongbanList.isEmpty){
        if(state.status == NhansuStatus.loading){
          return Center(child: LoadingWidget());
        } else if(state.status != NhansuStatus.fetchPhongbanSuccess){
          return const SizedBox();
        } else {
          return const Center(child: Text("Chưa có Phòng ban"));
        }

      }
      else {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: state.phongbanList.length,
                  itemBuilder: (lstContext, index) =>
                      _buildItemPhongban(state.phongbanList[index], context)),
            ),


          ],
        );

      }
    }

  }

  Widget _buildItemNhanvien(NhanvienModel nhanvienModel, BuildContext context) {
    return Container(
      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset("assets/images/erp.png",
                    width: 150, height: 120, fit: BoxFit.fill),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(nhanvienModel.hoten!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(nhanvienModel.chucvu!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(nhanvienModel.phongban!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(nhanvienModel.didong!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(nhanvienModel.email!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemPhongban(PhongbanModel phongbanModel, BuildContext context) {
    return Container(

      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(5),
              //   child: Image.asset("assets/images/erp.png",
              //       width: 150, height: 120, fit: BoxFit.fill),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(phongbanModel.tenphong!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text("Lãnh đạo: ${phongbanModel.truongphong??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text("Phòng cấp trên: ${phongbanModel.phongcaptren??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, )),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


