import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stander/reduce/app_state.dart';

class AppLocalizationsWrapper extends StatefulWidget {
  final Widget child;

  AppLocalizationsWrapper({Key key, this.child}) : super(key: key);

  @override
  _AppLocalizationsWrapperState createState() => _AppLocalizationsWrapperState();
}

class _AppLocalizationsWrapperState extends State<AppLocalizationsWrapper> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }
}
