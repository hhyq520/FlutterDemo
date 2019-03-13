import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/net/app_api.dart';
import 'package:flutter_stander/ui/pages/recevie_order_page.dart';
import 'package:flutter_stander/ui/pages/tuihuo_page.dart';
import 'package:flutter_stander/utils/common_util.dart';
import 'package:ota_update/ota_update.dart';
class HomePage extends StatefulWidget {
  static const String ROUTE_NAME = "home";
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageSate();
  }
}

class HomePageSate extends State<HomePage> {
  DateTime _lastPressedAt; //上次点击时间
  Future<bool> _onWillpop() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
      //两次点击间隔超过1秒则重新计时
      _lastPressedAt = DateTime.now();
      CommonUtil.showToast("再按一次退出！");
      return false;
    }
    Navigator.of(context).pop(true);
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppApi.getInstance().checkVersion("1.05").then((v){
        // START LISTENING FOR DOWNLOAD PROGRESS REPORTING EVENTS
        try {
          //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
          OtaUpdate().execute(v.url).listen(
                (OtaEvent event) {
              print('EVENT: ${event.status} : ${event.value}');
            },
          );
        } catch (e) {
          print('Failed to make OTA update. Details: $e');
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillpop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("康达时国际货运"),
          backgroundColor: AppColors.COLOR_MAIN,
          centerTitle: true,
        ),
        body: Container(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //纵轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget),
                ),
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RecevieOrder.ROUTE_NAME);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image(
                      width: 80,
                      height: 80,
                      image: AssetImage("images/zc.png"),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "接单",
                      style: TextStyle(color: AppColors.COLOR_BLACK),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, TuiHuo.ROUTE_NAME);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image(
                      width: 80,
                      height: 80,
                      image: AssetImage("images/xc.png"),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "退货签收",
                      style: TextStyle(color: AppColors.COLOR_BLACK),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
