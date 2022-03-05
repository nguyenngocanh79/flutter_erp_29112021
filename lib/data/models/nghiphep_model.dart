class NghiphepModel {
  NghiphepModel({
      this.id, 
      this.nguoinghiid, 
      this.nguoiduyetid, 
      this.kieunghiid, 
      this.thoiluong, 
      this.tungay, 
      this.denngay, 
      this.mieuta, 
      this.tinhtrang, 
      this.nguoinghi, 
      this.nguoiduyet, 
      this.kieunghi,});

  NghiphepModel.fromJson(dynamic json) {
    id = json['id'];
    nguoinghiid = json['nguoinghiid'];
    nguoiduyetid = json['nguoiduyetid'];
    kieunghiid = json['kieunghiid'];
    thoiluong = json['thoiluong'];
    tungay = json['tungay'];
    denngay = json['denngay'];
    mieuta = json['mieuta'];
    tinhtrang = json['tinhtrang'];
    nguoinghi = json['nguoinghi'];
    nguoiduyet = json['nguoiduyet'];
    kieunghi = json['kieunghi'];
  }
  int? id;
  int? nguoinghiid;
  int? nguoiduyetid;
  int? kieunghiid;
  num? thoiluong;
  String? tungay;
  String? denngay;
  String? mieuta;
  String? tinhtrang;
  String? nguoinghi;
  String? nguoiduyet;
  String? kieunghi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nguoinghiid'] = nguoinghiid;
    map['nguoiduyetid'] = nguoiduyetid;
    map['kieunghiid'] = kieunghiid;
    map['thoiluong'] = thoiluong;
    map['tungay'] = tungay;
    map['denngay'] = denngay;
    map['mieuta'] = mieuta;
    map['tinhtrang'] = tinhtrang;
    map['nguoinghi'] = nguoinghi;
    map['nguoiduyet'] = nguoiduyet;
    map['kieunghi'] = kieunghi;
    return map;
  }

}