import 'dart:ui';

import 'package:flutter_stander/consant/colors.dart';

class AppConfig{
  static const BASEURL="http://47.92.168.224:8080/AndroidServiceKDS/m8/";
  static const USER_INFO="user_info";
  static const THEME_DATA="theme_data";
  static const LOCAL="local";
  static const int STATUS_SUCCESS = 4;
  static const FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME="com.example.flutterstander/flutter_native_plugin";
  static const FLUTTER_NATIVE_PLUGIN_PICKER_NAME="plugins.flutter.io/image_picker";
  static List<Color> getThemeListColor() {
    return [
      AppColors.PRIMARY_DEFAULT_COLOR, //默认色
      AppColors.PRIMARY_HTH_COLOR, //海棠红
      AppColors.PRIMARY_YWL_COLOR, //鸢尾蓝
      AppColors.PRIMARY_KQL_COLOR, //孔雀绿
      AppColors.PRIMARY_NMH_COLOR, //柠檬黄
      AppColors.PRIMARY_TLZ_COLOR, //藤萝紫
      AppColors.PRIMARY_MYH_COLOR, //暮云灰
      AppColors.PRIMARY_XKQ_COLOR, //虾壳青
      AppColors.PRIMARY_MDF_COLOR, //牡丹粉
      AppColors.PRIMARY_XPZ_COLOR, //筍皮棕
    ];
  }
}