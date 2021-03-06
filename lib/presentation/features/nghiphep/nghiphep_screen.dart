import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/nghiphep_api.dart';
import 'package:flutter_erp_29112021/data/models/kieunghiphep_model.dart';
import 'package:flutter_erp_29112021/data/models/nghiphep_model.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/repositories/nghiphep_repository.dart';
import 'package:flutter_erp_29112021/main.dart';
import 'package:flutter_erp_29112021/presentation/widgets/drawer.dart';
import 'package:flutter_erp_29112021/presentation/widgets/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'nghiphep_bloc.dart';
import 'nghiphep_event.dart';
import 'nghiphep_state.dart';



class NghiphepScreen extends StatefulWidget {
  @override
  _NghiphepScreenState createState() => _NghiphepScreenState();
}

class _NghiphepScreenState extends State<NghiphepScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => NghiphepApi()),
        ProxyProvider<NghiphepApi, NghiphepRepository>(
          create: (context) => NghiphepRepository(context.read<NghiphepApi>()),
          update: (context, api, repository) {
            return NghiphepRepository(api);
          },
        ),
        ProxyProvider<NghiphepRepository, NghiphepBloc>(
          create: (context) => NghiphepBloc(context.read<NghiphepRepository>()),
          update: (context, nghiphepRepository, bloc) {
            return NghiphepBloc(nghiphepRepository);
          },
        ),
      ],
      child: NghiphepScreenContainer(),
    );

  }
}

class NghiphepScreenContainer extends StatefulWidget {
  const NghiphepScreenContainer({Key? key}) : super(key: key);

  @override
  _NghiphepScreenContainerState createState() => _NghiphepScreenContainerState();
}

class _NghiphepScreenContainerState extends State<NghiphepScreenContainer> {
  late NghiphepBloc nghiphepBloc;
  late NghiphepRepository nghiphepRepository;
  AppBarWidget appBarWidget = new AppBarWidget();
  DrawerWidget drawerWidget = new DrawerWidget();
  late NhanvienModel session;
  // List<NhanvienModel> nhanvienList = [];
  List<NhanvienModel> nhanviencapduoiList = [];
  String dropdownNguoinghiValue = "T???t c???";
  String dropdownTinhtrangValue = "T???t c???";

  // late List<NghiphepModel> nghiphepListToShow;

  @override
  void initState() {
    super.initState();
    nghiphepBloc = context.read<NghiphepBloc>();
    nghiphepRepository = context.read<NghiphepRepository>();
    // nghiphepBloc.add(FetchListNghiphep());

    SharePre.instance.getSession()
        .then((res){
      session = res;

      //Fetch list nhan vien cap duoi
      nghiphepRepository.fetchNhanviencapduoi(id: session.id!)
          .then((Response response) {
        if(response.statusCode == 200){
          if(response.data["data"] != null){
            nhanviencapduoiList = (response.data["data"] as List).map((e)=>NhanvienModel.fromJson(e)).toList();

          }
        }

        //Fetch nghi phep list
        nghiphepBloc.add(ChangeDropdownValueEvent(
            dropdownNhanvienValue: dropdownNguoinghiValue,
            dropdownTinhtrangValue: dropdownTinhtrangValue,
            id: session.id!));
        //Fetch S??? ngh??? ph??p c???n duy???t
        nghiphepBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));

        mainSocket.on('Server g???i l???nh thay ?????i Ngh??? ph??p th??nh c??ng', (data) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data + " : ngh??? ph??p")));
          //Fetch nghi phep list
          nghiphepBloc.add(ChangeDropdownValueEvent(
              dropdownNhanvienValue: dropdownNguoinghiValue,
              dropdownTinhtrangValue: dropdownTinhtrangValue,
              id: session.id!));
          //Fetch S??? ngh??? ph??p c???n duy???t
          nghiphepBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));

        });

        // mainSocket.on('Server g???i l???nh duy???t Ngh??? ph??p th??nh c??ng', (data) {
        //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data + " : ngh??? ph??p")));
        //   //Fetch nghi phep list
        //   nghiphepBloc.add(ChangeDropdownValueEvent(
        //       dropdownNhanvienValue: dropdownNguoinghiValue,
        //       dropdownTinhtrangValue: dropdownTinhtrangValue,
        //       id: session.id!));
        //   // //Fetch S??? ngh??? ph??p c???n duy???t
        //   // nghiphepBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));
        //
        // });

      });

    } );


  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();


  }

  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<NghiphepBloc, NghiphepState>(
      bloc: nghiphepBloc,
      builder: (context, state) {
        // print(state.hasMessage);
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: appBarWidget.buildAppBar(
            context,
            title: "Ngh??? ph??p",
            hasMessage: state.soNghiphepCanduyet>0,

          ),
          drawer: drawerWidget.builDrawer(
            context: context,
            menuNameList: ["Nh??n s???", "Ngh??? ph??p"],
            menuFunctionList: [
                  () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
                  () => Navigator.pop(context),

            ],
            messageList: [0, state.soNghiphepCanduyet],
          ),
          //Add button
          floatingActionButton: FloatingActionButton(

            child: Icon(Icons.add),
            onPressed: () async {
              // //?????c session
              // NhanvienModel session = await SharePre.instance.getSession();
              //L???y ki???u ngh??? ph??p, kh??ng l??m theo bloc v?? c???n sync
              Response response = await nghiphepRepository.fetchKieuNghipheps();
              if(response.statusCode == 200){
                if(response.data["data"] != null){
                  List<KieunghiphepModel> kieuNghiphepList =
                  (response.data["data"] as List).map((e)=>KieunghiphepModel.fromJson(e)).toList();
                  //d??ng then th?? kh??ng c???n async-await
                  final NghiphepModel result = await Navigator.pushNamed(
                      context, "/nghiphep/create",
                      arguments: CreateNghiphepArguments(session: session, kieuNghiphepList: kieuNghiphepList)) as NghiphepModel;
                  if(result != null){
                    nghiphepBloc.add(CreateNghiphepEvent(
                        nguoinghiid: result.nguoinghiid!,
                        kieunghiid: result.kieunghiid!,
                        thoiluong: result.thoiluong!,
                        tungay: result.tungay!,
                        denngay: result.denngay!,
                        mieuta: result.mieuta,
                        tinhtrang: "Ch??? duy???t"));
                    // print(result.nguoinghiid);
                  }
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString())));
                }
              }

            },
          ),
          // body: NhanvienContainer(context, state),
          body: NghiphepListContainer(context, state),
          // body: Container(child: Text("ffdsafdsa"),),
        );
      },
      listener: (context, state) {
        if(state.status == NghiphepStatus.createNghiphepSucess
            ||state.status == NghiphepStatus.updateNghiphepSuccess
            ||state.status == NghiphepStatus.deleteNghiphepSucess){
          // nghiphepBloc.add(ChangeDropdownValueEvent(
          //     dropdownNhanvienValue: dropdownNguoinghiValue,
          //     dropdownTinhtrangValue: dropdownTinhtrangValue,
          //     id: session.id!));
          //????? ????n gi???n, ch??? g???i 1 tr???ng th??i, v?? server s??? t??n hi???u ?????n all
          mainSocket.emit("Client thay ?????i ngh??? ph??p th??nh c??ng",session.id);
        }
        // if(state.status == NghiphepStatus.createNghiphepSucess
        //     ||state.status == NghiphepStatus.deleteNghiphepSucess){
        //   //G???i id ng?????i qu???n l?? tr???c ti???p
        //   mainSocket.emit("Client thay ?????i ngh??? ph??p th??nh c??ng",session.quanlytructiepid);
        //   nghiphepBloc.add(FetchSoNghiphepCanduyetEvent(id: session.id!));
        // }
        //
        // if(state.status == NghiphepStatus.updateNghiphepSuccess){
        //   //N???u l?? duy???t th?? g???i ?????n ng?????i ngh??? ph??p ???????c duy???t
        //   if(state.isApproving){
        //     mainSocket.emit("Client duy???t ngh??? ph??p th??nh c??ng", state.nguoiduocduyetid);
        //   }
        // }
      },
    );
  }

  Widget NghiphepListContainer(BuildContext context,NghiphepState state ){
    // print(state.nghiphepList.length.toString());
    if(state.status == NghiphepStatus.fetchNghiphepFailure){
      return Center(child: Text(state.message.toString()));
    }
    else {

      if(state.nghiphepList.isEmpty){
        if(state.status == NghiphepStatus.loading){
          return Center(child: LoadingWidget());
        } else if(state.status != NghiphepStatus.fetchNghiphepSuccess
            && state.status != NghiphepStatus.deleteNghiphepSucess
            && state.status != NghiphepStatus.updateNghiphepSuccess
            && state.status != NghiphepStatus.createNghiphepSucess
            && state.status != NghiphepStatus.fetchSoNghiphepCanduyetSuccess){
          return const SizedBox();
        } else {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text("Nh??n vi??n"),
                      ),
                      _buildDropdownNhanvien(state),
                    ],
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text("T??nh tr???ng"),
                      ),
                      _buildDropdownTinhtrang(state),
                    ],
                  ),
                ],),
              Expanded(child: Center(child:  Text("Kh??ng c?? ngh??? ph??p th???a y??u c???u", style: TextStyle(fontSize: 20),))),
            ],
          );
        }

      }
      else {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Nh??n vi??n"),
                    ),
                    _buildDropdownNhanvien(state),
                  ],
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("T??nh tr???ng"),
                    ),
                    _buildDropdownTinhtrang(state),
                  ],
                ),
              ],),
            Expanded(
              child: ListView.builder(
                  itemCount: state.nghiphepList.length,
                  itemBuilder: (lstContext, index) {
                    return InkWell(
                        child: _buildItemNghiphep(state.nghiphepList[index], context),
                        onTap: () {

                        }

                    );
                  }
              ),
            ),

            // Container(
            //     margin: EdgeInsets.only(bottom: 10),
            //     padding: EdgeInsets.all(10),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // nhansuBloc.add(ChangeMessageEvent());
            //         nhansuBloc.add(FetchListNhanvien());
            //         },
            //       style: ButtonStyle(
            //           backgroundColor:
            //           MaterialStateProperty.all(Colors.deepOrange)),
            //       child: Text("Confirm",
            //           style:
            //           TextStyle(color: Colors.white, fontSize: 25)),
            //     )),
          ],
        );
      }
    }
  }

  Widget _buildDropdownNhanvien(NghiphepState state){
    List<String> nhanvienItems = ["T???t c???", "C???a t??i", "Kh??? duy???t"];
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
              items: nhanvienItems.map((item) => DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              )).toList(),
              value: state.dropdownNhanvienValue,
              onChanged: (value)async{
                dropdownNguoinghiValue = value!;
                nghiphepBloc.add(ChangeDropdownValueEvent(
                    dropdownNhanvienValue: dropdownNguoinghiValue,
                    dropdownTinhtrangValue: dropdownTinhtrangValue,
                    id: session.id!)
                );
              },
            )
        ),
      ),
    );

  }

  Widget _buildDropdownTinhtrang(NghiphepState state){
    List<String> phongbanitems = ["T???t c???", "???? duy???t", "Ch??? duy???t", "Kh??ng duy???t"];

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
              value: state.dropdownTinhtrangValue,
              onChanged: (value){
                dropdownTinhtrangValue = value!;
                nghiphepBloc.add(ChangeDropdownValueEvent(
                    dropdownNhanvienValue: dropdownNguoinghiValue,
                    dropdownTinhtrangValue: dropdownTinhtrangValue,
                    id: session.id!)
                );

              },
            )
        ),
      ),
    );

  }

  Widget _buildItemNghiphep(NghiphepModel nghiphepModel, BuildContext context) {
    // print(nghiphepModel);
    return Container(
      height: 140,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("Ng?????i ngh???: ${nghiphepModel.nguoinghi??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("S??? ng??y ngh???: ${nghiphepModel.thoiluong??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("T??? ng??y: ${nghiphepModel.tungay!=null?DateFormat("yy-MM-dd")
                            .format(DateTime.parse(nghiphepModel.tungay!) ):""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("?????n ng??y: ${nghiphepModel.denngay!=null?DateFormat("yy-MM-dd")
                            .format(DateTime.parse(nghiphepModel.denngay!) ):""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("Ki???u ngh???: ${nghiphepModel.kieunghi??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("Mi??u t???: ${nghiphepModel.mieuta??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12,)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Button Update
                    _buildRefreshApprovalButton(nghiphepModel, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(nghiphepModel.tinhtrang!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    //Button Delete
                    nghiphepModel.tinhtrang == "Ch??? duy???t"
                        && nghiphepModel.nguoinghiid ==  session.id? Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        iconSize: 30,
                        color: Colors.red,
                        onPressed: (){
                          nghiphepBloc.add(DeleteNghiphepEvent(id: nghiphepModel.id!));
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("state.message")));
                        },
                      ),
                    ):SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshApprovalButton(NghiphepModel nghiphepModel, BuildContext context){
    if(nghiphepModel.tinhtrang == "Ch??? duy???t"){
      //Ngh??? ph??p c???a t??i, c?? th??? update
      if(nghiphepModel.nguoinghiid ==  session.id){
        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: IconButton(
            icon: Icon(Icons.refresh),
            iconSize: 30,
            color: Colors.blue,
            onPressed: () async {
              Response response = await nghiphepRepository.fetchKieuNghipheps();
              if(response.statusCode == 200){
                if(response.data["data"] != null){
                  List<KieunghiphepModel> kieuNghiphepList =
                  (response.data["data"] as List).map((e)=>KieunghiphepModel.fromJson(e)).toList();
                  //d??ng then th?? kh??ng c???n async-await
                  final NghiphepModel result = await Navigator.pushNamed(
                      context, "/nghiphep/update",
                      arguments: CreateNghiphepArguments(session: session, kieuNghiphepList: kieuNghiphepList, nghiphepModel: nghiphepModel)) as NghiphepModel;
                  if(result != null){
                    nghiphepBloc.add(UpdateNghiphepEvent(
                        id: nghiphepModel.id!,
                        nguoinghiid: result.nguoinghiid!,
                        nguoiduyetid: null,
                        kieunghiid: result.kieunghiid!,
                        thoiluong: result.thoiluong!,
                        tungay: result.tungay!,
                        denngay: result.denngay!,
                        mieuta: result.mieuta,
                        tinhtrang: "Ch??? duy???t",
                        isApproving: false));
                    // print(result.nguoinghiid);
                  }
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update: " + result.toString())));
                }
              }
            },
          ),
        );
      }
      //N???u ngh??? ph??p c???a nh??n vi??n c???p d?????i
      else if(nhanviencapduoiList.map((e) => e.id).toList().contains(nghiphepModel.nguoinghiid)){
        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: IconButton(
            icon: Icon(Icons.approval),
            iconSize: 30,
            color: Colors.blue,
            onPressed: () {
              nghiphepBloc.add(UpdateNghiphepEvent(
                  id: nghiphepModel.id!,
                  nguoinghiid: nghiphepModel.nguoinghiid!,
                  nguoiduyetid: session.id,
                  kieunghiid: nghiphepModel.kieunghiid!,
                  thoiluong: nghiphepModel.thoiluong!,
                  tungay: nghiphepModel.tungay!,
                  denngay: nghiphepModel.denngay!,
                  mieuta: nghiphepModel.mieuta,
                  tinhtrang: "???? duy???t",
                  isApproving: true,
                  nguoiduocduyetid: nghiphepModel.nguoinghiid!,
                  ));
            },
          ),
        );
      }

    }
    return SizedBox();
  }
}

class CreateNghiphepArguments {
  final NhanvienModel session;
  final List<KieunghiphepModel> kieuNghiphepList;
  final NghiphepModel? nghiphepModel;

  CreateNghiphepArguments({required this.session,required this.kieuNghiphepList, this.nghiphepModel});
}