class KieunghiphepModel {
  KieunghiphepModel({
      this.id, 
      this.kieunghi,});

  KieunghiphepModel.fromJson(dynamic json) {
    id = json['id'];
    kieunghi = json['kieunghi'];
  }
  int? id;
  String? kieunghi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['kieunghi'] = kieunghi;
    return map;
  }

}