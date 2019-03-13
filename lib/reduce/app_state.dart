import 'package:flutter/material.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/reduce/redux_user.dart';
import 'package:flutter_stander/reduce/redux_locale.dart';
import 'package:flutter_stander/reduce/redux_theme.dart';
class AppState{
   ///用户信息
   User user;
   ///主题数据
   ThemeData themeData;
   ///语言
   Locale locale;
   ///当前手机平台默认语言
   Locale platformLocale;

   AppState(this.user, this.themeData, this.locale);
}

AppState appReducer(AppState state,action){
  return AppState(combineUserReducer(state.user,action),
      combineThemeDataReducer(state.themeData,action),combineLocaleReducer(state.locale,action));
}
