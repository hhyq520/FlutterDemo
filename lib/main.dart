import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/localization/app_localization_delegate.dart';
import 'package:flutter_stander/localization/app_localizations_wrapper.dart';
import 'package:flutter_stander/reduce/app_state.dart';
import 'package:flutter_stander/ui/pages/camera_screen.dart';
import 'package:flutter_stander/ui/pages/home_page.dart';
import 'package:flutter_stander/ui/pages/login_page_new.dart';
import 'package:flutter_stander/ui/pages/order_detail.dart';
import 'package:flutter_stander/ui/pages/recevie_order_page.dart';
import 'package:flutter_stander/ui/pages/splash_page.dart';
import 'package:flutter_stander/ui/pages/tuihuo_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() => runApp(MyStandardApp());

class MyStandardApp extends StatelessWidget {
  // This widget is the root of your application.
  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState(
      null,
      new ThemeData(
          primaryColor: AppColors.PRIMARY_DEFAULT_COLOR,
          platform: TargetPlatform.android),
      Locale('zh', 'CH'),
    ),
  );
  List<CameraDescription> cameras;


  @override
  Widget build(BuildContext context) {


    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(builder: (context,store){
        return new MaterialApp(
          theme: store.state.themeData,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizztionDelegate.delegate,
          ],
          locale: store.state.locale,
          supportedLocales:[store.state.locale] ,
          routes: {
            SplashPage.ROUTE_NAME: (context) =>
            ///注意只需要包裹第一次打开的页面，BuildContext 会传递给子widget树.
            AppLocalizationsWrapper(child: SplashPage()),
            LoginPageNew.ROUTE_NAME: (context) => LoginPageNew(),
            HomePage.ROUTE_NAME: (context) => HomePage(),
            RecevieOrder.ROUTE_NAME: (context) => RecevieOrder(),
            TuiHuo.ROUTE_NAME: (context) => TuiHuo(),
          },
        );
      }),
    );
  }
}
