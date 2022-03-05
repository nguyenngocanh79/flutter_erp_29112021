
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp_29112021/data/datasources/local/share_pref.dart';
import 'package:flutter_erp_29112021/data/datasources/remote/api/nghiphep_api.dart';
import 'package:flutter_erp_29112021/data/models/kieunghiphep_model.dart';
import 'package:flutter_erp_29112021/data/models/nghiphep_model.dart';
import 'package:flutter_erp_29112021/data/models/nhanvien_model.dart';
import 'package:flutter_erp_29112021/data/repositories/nghiphep_repository.dart';
import 'package:flutter_erp_29112021/presentation/features/nghiphep/nghiphep_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NghiphepCreateScreen extends StatefulWidget {
  const NghiphepCreateScreen({Key? key,required this.isCreate}) : super(key: key);
  final bool isCreate;

  @override
  _NghiphepCreateScreenState createState() => _NghiphepCreateScreenState();
}

class _NghiphepCreateScreenState extends State<NghiphepCreateScreen> {
  late NhanvienModel nhanvienModel;
  late NghiphepRepository nghiphepRepository;
  late CreateNghiphepArguments createNghiphepArguments;

  String kieunghiValue = "Nghỉ phép năm";

  DateTime _tungaySelectedDate = DateTime.now();
  TextEditingController _tungayController = TextEditingController();
  TextEditingController _thoiluongController = TextEditingController();
  TextEditingController _denngayController = TextEditingController();
  TextEditingController _mieutaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nghiphepRepository = NghiphepRepository(NghiphepApi());


  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    createNghiphepArguments = ModalRoute.of(context)!.settings.arguments as CreateNghiphepArguments;
    if(createNghiphepArguments.nghiphepModel == null) {
      _tungayController
        ..text = DateFormat("yyyy-MM-dd").format(DateTime.now());
      _thoiluongController.text = "1";
    } else {
      _tungaySelectedDate = DateTime.parse(createNghiphepArguments.nghiphepModel!.tungay!);
      kieunghiValue = createNghiphepArguments.nghiphepModel!.kieunghi!;
      _tungayController.text = createNghiphepArguments.nghiphepModel!.tungay!.substring(0,10);
      _thoiluongController.text = createNghiphepArguments.nghiphepModel!.thoiluong!.toString();
      _denngayController.text = createNghiphepArguments.nghiphepModel!.denngay!;
      _mieutaController.text = createNghiphepArguments.nghiphepModel!.mieuta!;
    }


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isCreate?"Đơn xin nghỉ phép":"Sửa Đơn nghỉ phép"),
        ),
        body: SafeArea(
          child: Container(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return _buildCreateNghiphepForm(context, createNghiphepArguments);
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateNghiphepForm(BuildContext context, CreateNghiphepArguments createNghiphepArguments) {
    NhanvienModel nhanvienModel = createNghiphepArguments.session!;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Text(nhanvienModel.hoten!,
              style: TextStyle(fontSize: 30),textAlign: TextAlign.center,)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Kiểu nghỉ:", style: TextStyle(fontSize: 18)),
                DropdownButton<String>(
                  items: createNghiphepArguments.kieuNghiphepList
                      .map((kieunghiphep)=>kieunghiphep.kieunghi!).toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: kieunghiValue,
                  onChanged: (value){setState(() {
                    kieunghiValue = value!;
                  });},
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Thời lượng:", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: _buildThoiluongTextField(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Từ ngày:", style: TextStyle(fontSize: 18)),
                Expanded(
                    child: _buildTungayTextField(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Đến ngày:", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: _buildDenngayTextField(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Miêu tả:", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: _buildMieutaTextField(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildButtonOK(context, createNghiphepArguments),
                _buildButtonCancel(context),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildThoiluongTextField(BuildContext context) {
    return Container(
      // height: 50,
      margin: EdgeInsets.only(left: 10, ),
      child: TextField(
        onChanged: (value){setState(() {
          DateTime denngay = _tungaySelectedDate
              .add(Duration(
              days: int.parse(value.isNotEmpty?value:"0") )
          );
          _denngayController
            ..text = DateFormat("yyyy-MM-dd").format(denngay)
            ..selection = TextSelection.fromPosition(TextPosition(
                offset: _denngayController.text.length,
                affinity: TextAffinity.upstream));
        });},
        textAlign: TextAlign.end,
        maxLines: 1,
        controller: _thoiluongController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: "Thời gian nghỉ",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildTungayTextField(BuildContext context) {
    return Container(
      // height: 50,
      margin: EdgeInsets.only(left: 10, ),
      child: TextField(
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () {
          _selectDate(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("result.toString()")));
        },
        textAlign: TextAlign.end,
        maxLines: 1,
        controller: _tungayController,
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: "Từ ngày",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _tungaySelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: Colors.deepPurple,
      //         onPrimary: Colors.white,
      //         surface: Colors.blueGrey,
      //         onSurface: Colors.yellow,
      //       ),
      //       dialogBackgroundColor: Colors.blue[500],
      //     ),
      //     child: child!,
      //   );
      // }
    );

    if (newSelectedDate != null) {
      setState(() {
        _tungaySelectedDate = newSelectedDate;
        _tungayController
          ..text = DateFormat("yyyy-MM-dd").format(_tungaySelectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _tungayController.text.length,
              affinity: TextAffinity.upstream));
      });

    }
  }

  Widget _buildDenngayTextField(BuildContext context) {
    // String thoiluong = _thoiluongController.text;
    // if(thoiluong.isNotEmpty)
    DateTime denngay = _tungaySelectedDate
        .add(Duration(
          days: int.parse(_thoiluongController.text.isNotEmpty?_thoiluongController.text:"0") )
    );
    _denngayController
      ..text = DateFormat("yyyy-MM-dd").format(denngay)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _denngayController.text.length,
          affinity: TextAffinity.upstream));

    return Container(
      // height: 50,
      margin: EdgeInsets.only(left: 10, ),
      child: TextField(

        focusNode: AlwaysDisabledFocusNode(),
        textAlign: TextAlign.end,
        maxLines: 1,
        controller: _denngayController,
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: "Đến ngày",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildMieutaTextField(BuildContext context) {
    return Container(
      // height: 50,
      margin: EdgeInsets.only(left: 10, ),
      child: TextField(
        textAlign: TextAlign.start,
        maxLines: 2,
        controller: _mieutaController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: "Miêu tả",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildButtonOK(BuildContext context, CreateNghiphepArguments createNghiphepArguments) {
    NhanvienModel nhanvienModel = createNghiphepArguments.session;
    List<KieunghiphepModel> kieunghiphepList = createNghiphepArguments.kieuNghiphepList;
    return Container(
        margin: EdgeInsets.only(top: 20),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue,),
          onPressed: (){
            String thoiluong = _thoiluongController.text.toString();
            String tungay = _tungayController.text.toString();
            if(thoiluong.isEmpty || tungay.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phải điền đủ ô Thời lượng và Từ ngày")));
              return;
            }
            NghiphepModel nghiphepModel = NghiphepModel(
              nguoinghiid: nhanvienModel.id,
              kieunghiid: kieunghiphepList.firstWhere((element) => element.kieunghi == kieunghiValue).id,
              thoiluong: int.parse(thoiluong),
              tungay: tungay,
              denngay: _denngayController.text.toString(),
              mieuta: _mieutaController.text.toString(),
            );
            Navigator.pop(context,nghiphepModel);



          },
          child: Text("OK"),
        )
    );
  }

  Widget _buildButtonCancel(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue,),
          onPressed: (){
            Navigator.pop(context,);
          },
          child: Text("Cancel"),
        )
    );
  }

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}










