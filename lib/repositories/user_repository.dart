import 'dart:io';

import 'package:dio/dio.dart';
import 'package:users_cubit/core/constants/url_const.dart';
import 'package:users_cubit/model/user_model.dart';

class UserRepository{
  Future<List<UserModel>?> getUsers() async{
    try {
          Response res = await Dio().get(UrlConst.baseUrl);
    print("request ketdi");
    if(res.statusCode == HttpStatus.ok){
    return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
    } else{
      print("serverda xato bor"); 
      return throw Exception("serverda xato bor");

    }
    } catch (e) {
      return throw Exception(e);

    }
  }
}