import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stander/localization/app_localizations.dart';

class AppLocalizztionDelegate extends LocalizationsDelegate<AppLocalizations> {
  AppLocalizztionDelegate();
  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // TODO: implement load
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }
  static AppLocalizztionDelegate delegate = AppLocalizztionDelegate();
}