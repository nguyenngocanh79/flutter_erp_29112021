class NhanvienModel {

  NhanvienModel({
    this.id,
    this.hoten,
    this.email,
    this.ngaysinh,
    this.gioitinh,
    this.didong,
    this.chucvu,
    this.quanlytructiepid,
    this.password,
    this.phongbanid,
    this.quanlytructiep,
    this.phongban,
    this.token,});

  // const NhanvienModel(
  //     this.id,
  //     this.hoten,
  //     this.email,
  //     this.ngaysinh,
  //     this.gioitinh,
  //     this.didong,
  //     this.chucvu,
  //     this.quanlytructiepid,
  //     this.password,
  //     this.phongbanid,
  //     this.quanlytructiep,
  //     this.phongban,
  //     this.token);

  NhanvienModel.fromJson(dynamic json) {
    id = json['id'];
    hoten = json['hoten'];
    email = json['email'];
    ngaysinh = json['ngaysinh'];
    gioitinh = json['gioitinh'];
    didong = json['didong'];
    chucvu = json['chucvu'];
    quanlytructiepid = json['quanlytructiepid'];
    password = json['password'];
    phongbanid = json['phongbanid'];
    quanlytructiep = json['quanlytructiep'];
    phongban = json['phongban'];
    token = json['token'];
  }
  int? id;
  String? hoten;
  String? email;
  String? ngaysinh;
  String? gioitinh;
  String? didong;
  String? chucvu;
  int? quanlytructiepid;
  String? password;
  String? phongbanid;
  String? quanlytructiep;
  String? phongban;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['hoten'] = hoten;
    map['email'] = email;
    map['ngaysinh'] = ngaysinh;
    map['gioitinh'] = gioitinh;
    map['didong'] = didong;
    map['chucvu'] = chucvu;
    map['quanlytructiepid'] = quanlytructiepid;
    map['password'] = password;
    map['phongbanid'] = phongbanid;
    map['quanlytructiep'] = quanlytructiep;
    map['phongban'] = phongban;
    map['token'] = token;
    return map;
  }


}