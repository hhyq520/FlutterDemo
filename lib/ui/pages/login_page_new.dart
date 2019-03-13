import 'dart:developer';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stander/consant/app_config.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/localization/app_localizations.dart';
import 'package:flutter_stander/manager/user_manager.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/net/app_api.dart';
import 'package:flutter_stander/reduce/app_state.dart';
import 'package:flutter_stander/ui/pages/home_page.dart';
import 'package:flutter_stander/ui/widget/progress_dialog.dart';
import 'package:flutter_stander/utils/common_util.dart';
export 'package:common_utils/common_utils.dart';

class LoginPageNew extends StatefulWidget {
  static const String ROUTE_NAME = "login";
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPageNew> {
  MethodChannel flutterNativePlugin;
  String _version;
  String _time = "Morning";
  bool _isloading=false;
  String _sitecode,_userName, _password;
  TextEditingController loginSiteCodeController = new TextEditingController();
  TextEditingController loginUserCodeController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  void _initVersion() {
    flutterNativePlugin =
        MethodChannel(AppConfig.FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    flutterNativePlugin.invokeMethod('getversion').then((v) {
      setState(() {
        _version = v;
      });
    });
  }

  void _intiTiem() {
    DateTime now = new DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
//      imageView.setImageResource(R.drawable.good_morning_img);
      _time = "Morning";
    } else if (now.hour >= 12 && now.hour < 18) {
//      imageView.setImageResource(R.drawable.good_morning_img);
      _time = "Afternoon";
    } else {
//      imageView.setImageResource(R.drawable.good_night_img);
      _time = "Night";
    }
  }

  void _login(){
    LogUtil.e("点击登录");
    if(ObjectUtil.isEmptyString(_sitecode)){
      CommonUtil.showToast("网点编号为空！");
      return;
    }
    if(ObjectUtil.isEmptyString(_userName)){
      CommonUtil.showToast("员工编号为空！");
      return;
    }
    if(ObjectUtil.isEmptyString(_password)){
      CommonUtil.showToast("密码为空！");
      return;
    }
    setState(() {
      _isloading=true;
    });
    AppApi.getInstance().login(_sitecode, _userName, _password).then((user){
      setState(() {
        _isloading=false;
      });
      if(user==null){
        CommonUtil.showToast("登录失败！");
      }else{
        UserManager.saveUserToLocalStorage(user);
        Navigator.pushReplacementNamed(context, HomePage.ROUTE_NAME);
      }
    });
  }

  Future _initListener() async {
    User user= await UserManager.getUserFromLocalStorage();
    _sitecode=user.siteCode;
    _userName=user.empCode;
    loginSiteCodeController.value=TextEditingValue(
      text: user!=null?user.siteCode:"",
    );
    loginUserCodeController.value=TextEditingValue(
      text: user!=null?user.empCode:"",
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initVersion();
    _intiTiem();
    _initListener();
  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    LogUtil.e("didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: StoreConnector<AppState, User>(
            converter: (store) => store.state.user,
            builder: (context, user) =>
            ProgressDialog(
                loading: _isloading,
                msg: "加载中...",
                child:
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.8,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new ExactAssetImage(
                                  'images/good_morning_img.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  width: MediaQuery.of(context).size.width * 0.96,
                                  child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Good",
                                          style: TextStyle(
                                              color: AppColors.COLOR_WHITE,
                                              fontSize: 35,
                                              fontFamily: 'gotham'),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                            _time,
                                            style: TextStyle(
                                                color: AppColors.COLOR_WHITE,
                                                fontSize: 35,
                                                fontFamily: 'gotham'),
                                          ),
                                        )
                                      ],
                                    ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "轻松愉快的开始工作吧",
                                  style: TextStyle(
                                      color: AppColors.COLOR_WHITE,
                                      fontSize: 14,
                                      fontFamily: 'calibri'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width * 0.96,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                  controller: loginSiteCodeController,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value){
                                    _sitecode=value;
                                  },
                                  style: TextStyle(
                                      color: AppColors.COLOR_WHITE,
                                      fontSize: 20.0),
                                  decoration: InputDecoration(
                                    labelText: "网点编号",
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    labelStyle: TextStyle(color: Colors.white),
                                    icon: new Image.asset("images/site.png"),
                                    hintText: AppLocalizations.of(context)
                                        .currentLocalized
                                        .hintSitecode,
                                    hintStyle: TextStyle(fontSize: 12.0),
                                  )),
                              TextField(
                                  controller: loginUserCodeController,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value){
                                    _userName=value;
                                  },
                                  style: TextStyle(
                                      color: AppColors.COLOR_WHITE,
                                      fontSize: 20.0),
                                  decoration: InputDecoration(
                                    labelText: "员工编号",
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    labelStyle: TextStyle(color: Colors.white),
                                    icon: new Image.asset(
                                        "images/icon_account.png"),
                                    hintText: "请输入员工编号",
                                    hintStyle: TextStyle(fontSize: 12.0),
                                  )),
                              TextField(
                                  controller: loginPasswordController,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value){
                                    _password=value;
                                  },
                                  obscureText: true,
                                  style: TextStyle(
                                      color: AppColors.COLOR_WHITE,
                                      fontSize: 20.0),
                                  decoration: InputDecoration(
                                    labelText: "密码",
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    labelStyle: TextStyle(color: Colors.white),
                                    icon:
                                        new Image.asset("images/icon_pwc.png"),
                                    hintText: "请输入密码",
                                    hintStyle: TextStyle(fontSize: 12.0),
                                  )),
                            ],
                          ),
                        ),
                        Center(
                          child: OutlineButton(
                            child: Text(
                              "登录",
                              style: TextStyle(
                                color: AppColors.COLOR_WHITE,
                                fontSize: 14,
                              ),
                            ),
                            onPressed: _login,
                          ),
                        ),
                        Center(
                          child: Text(
                            "版本号：${_version ?? '1.0.0'}",
                            style: TextStyle(
                              color: AppColors.COLOR_WHITE,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ))));
  }
}
