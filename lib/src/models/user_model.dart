import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends ChangeNotifier {
  String name;
  String pic;
  List<String> pendingReq;
  List<String> pendingInv;
  List<String> friends;

  UserModel(
      this.name, this.pic, this.pendingReq, this.pendingInv, this.friends);

  setUserModel(UserModel? newModel) {
    if (newModel != null) {
      name = newModel.name;
      pic = newModel.pic;
      pendingReq = newModel.pendingReq;
      pendingInv = newModel.pendingInv;
      friends = newModel.friends;
      notifyListeners();
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
