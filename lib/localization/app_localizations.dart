import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/locale/locale_base.dart';
import 'package:flutter_stander/consant/locale/locale_en.dart';
import 'package:flutter_stander/consant/locale/locale_zh.dart';

///自定义多语言实现
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Map<String, StringBase> _localizedValues = {
    'en': StringEn(),
    'zh': StringZh(),
  };

  StringBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }
}
