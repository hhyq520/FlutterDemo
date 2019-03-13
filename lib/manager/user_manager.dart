import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/app_config.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/utils/sp_utils.dart';
import 'package:redux/redux.dart';

class UserManager {
  ///获取本地登录用户信息
  static Future<User> getUserFromLocalStorage() async {
    var userInfoJson = await SPUtils.get(AppConfig.USER_INFO);
    if (userInfoJson != null) {
      var userMap = json.decode(userInfoJson);
      User user = User.fromJson(userMap);
      return user;
    }
    return null;
  }

  static saveUserToLocalStorage(User user) async {
    await SPUtils.save(AppConfig.USER_INFO, user.toJson());
  }

  ///更新用户信息
  static updateUserDao(params, Store store) async {}

}
