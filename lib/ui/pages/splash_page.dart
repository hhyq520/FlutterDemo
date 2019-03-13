import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/app_config.dart';
import 'package:flutter_stander/manager/app_manger.dart';
import 'package:flutter_stander/ui/pages/login_page_new.dart';
import 'package:flutter_stander/utils/dio_util.dart';
export 'package:common_utils/common_utils.dart';
class SplashPage extends StatefulWidget {
  static const String ROUTE_NAME = "/";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  bool isInit = false;
  static bool inProduction = bool.fromEnvironment("dart.vm.product");
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) {
      return;
    }
    isInit = true;
    _initNet();
    LogUtil.init(isDebug:inProduction ,tag:"zs");
    AppManger.initApp(context).then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, LoginPageNew.ROUTE_NAME);
      });
    });

  }

  void _initNet(){
    DioUtil.openDebug();
    Options options = DioUtil.getDefOptions();
    options.baseUrl = AppConfig.BASEURL;
    HttpConfig config = new HttpConfig(options: options);
    DioUtil().setConfig(config);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(0),
              child: Image.asset(
                "images/bg.jpg",
              ),
            )
          ],
        ),
      ),
    );
  }
}


