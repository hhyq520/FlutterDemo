import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stander/consant/app_config.dart';
import 'package:flutter_stander/manager/db_manager.dart';
import 'package:flutter_stander/manager/user_manager.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/reduce/app_state.dart';
import 'package:flutter_stander/reduce/redux_locale.dart';
import 'package:flutter_stander/reduce/redux_theme.dart';
import 'package:flutter_stander/reduce/redux_user.dart';
import 'package:flutter_stander/utils/sp_utils.dart';
import 'package:redux/redux.dart';

class AppManger {
  static initApp(BuildContext context) async{
    try{
      Store<AppState> store=StoreProvider.of(context);
      User user=await UserManager.getUserFromLocalStorage();
      if (user != null) {
        store.dispatch(UpdateUseraction(user));
      }
      ///读取主题
      String themeIndex = await SPUtils.get(AppConfig.THEME_DATA);
      if (themeIndex != null && themeIndex.isNotEmpty) {
        await AppManger.switchThemeData(context, int.parse(themeIndex));
      }
      ///初始化数据库
      await DBManger.createTuohuo();

      ///切换语言
      String localeIndex = await SPUtils.get(AppConfig.LOCAL);
      if (localeIndex != null && localeIndex.length != 0) {
        await AppManger.changeLocale(context, int.parse(localeIndex));
      }
      return true;
    }catch(e){
      return false;
    }
  }


  static switchThemeData(context, int index) async {
    Store store = StoreProvider.of<AppState>(context);
    ThemeData themeData;
    List<Color> colors = AppConfig.getThemeListColor();
    themeData = new ThemeData(primaryColor: colors[index]);
    await SPUtils.save(AppConfig.THEME_DATA, index.toString());
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  static changeLocale(context, int index) async {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    Locale locale = store.state.platformLocale;
    switch (index) {
      case 0:
        locale = Locale('zh', 'CH');
        break;
      case 1:
        locale = Locale('en', 'US');
        break;
    }
    store.dispatch(RefreshLocaleAction(locale));
    await SPUtils.save(AppConfig.LOCAL, index.toString());
  }
}