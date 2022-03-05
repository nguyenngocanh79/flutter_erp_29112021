class PhongbanModel {
  PhongbanModel({
      this.phongbanid, 
      this.tenphong, 
      this.truongphongid, 
      this.phongcaptrenid, 
      this.thutu, 
      this.truongphong, 
      this.phongcaptren,});

  PhongbanModel.fromJson(dynamic json) {
    phongbanid = json['phongbanid'];
    tenphong = json['tenphong'];
    truongphongid = json['truongphongid'];
    phongcaptrenid = json['phongcaptrenid'];
    thutu = json['thutu'];
    truongphong = json['truongphong'];
    phongcaptren = json['phongcaptren'];
  }
  String? phongbanid;
  String? tenphong;
  num? truongphongid;
  String? phongcaptrenid;
  int? thutu;
  String? truongphong;
  String? phongcaptren;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phongbanid'] = phongbanid;
    map['tenphong'] = tenphong;
    map['truongphongid'] = truongphongid;
    map['phongcaptrenid'] = phongcaptrenid;
    map['thutu'] = thutu;
    map['truongphong'] = truongphong;
    map['phongcaptren'] = phongcaptren;
    return map;
  }

}