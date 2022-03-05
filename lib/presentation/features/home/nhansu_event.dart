import 'package:equatable/equatable.dart';

abstract class NhansuEventBase extends Equatable {
}

class FetchListNhanvien extends NhansuEventBase {
  @override
  List<Object?> get props => [];

}

class FetchListPhongban extends NhansuEventBase {
  @override
  List<Object?> get props => [];

}

class FetchNhanviensTheoPhongban extends NhansuEventBase {
  final String phongban;
  @override
  List<Object?> get props => [];

  FetchNhanviensTheoPhongban(
      {required this.phongban});

}

class FetchSoNghiphepCanduyetEvent extends NhansuEventBase {
  final int id;

  FetchSoNghiphepCanduyetEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ChangeMessageEvent extends NhansuEventBase {
  @override
  List<Object?> get props => [];

}



// class UpdateCart extends CartEventBase {
//
//   late String orderId;
//   late String foodId;
//   late int quantity;
//
//   UpdateCart(
//       {required this.orderId, required this.foodId, required this.quantity});
//
//   @override
//   List<Object?> get props => [orderId, foodId, quantity];
//
// }
//
// class DeleteItemCart extends CartEventBase {
//
//   late String foodId;
//
//   DeleteItemCart({required this.foodId});
//
//   @override
//   List<Object?> get props => [foodId];
//
// }
