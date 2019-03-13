import 'dart:developer';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/manager/user_manager.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/model/order_bean.dart';
import 'package:flutter_stander/net/app_api.dart';
import 'package:flutter_stander/ui/widget/list_order_item.dart';
import 'package:flutter_stander/ui/widget/progress_dialog.dart';
import 'package:flutter_stander/utils/common_util.dart';

class RecevieOrder extends StatefulWidget {
  static const String ROUTE_NAME = "recevieorder";
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RecevieOrderState();
  }
}

class RecevieOrderState extends State<RecevieOrder> {
  bool _isloading = false;
  String _state = "待接单";
  String _startTime = "00:00:00 00:00:00";
  String _endTime = "00:00:00 00:00:00";
  List<OrderBean> dats ;
  Future _requestData() async{
    DateTime start=DateTime.parse(_startTime);
    DateTime end=DateTime.parse(_endTime);
    if(start.isAfter(end)){
      CommonUtil.showToast("起始时间大于结束时间！");
      return;
    }
    setState(() {
      _isloading = true;
    });
    UserManager.getUserFromLocalStorage().then((user){
      AppApi.getInstance().qryTAB_ORDER_CAR(_startTime, _endTime, _state, user.driverCode).then((list){
        setState(() {
          _isloading = false;
          dats=list;
        });
      });
    });

  }

//  List<DropdownMenuItem> _getStateData() {
//    List<DropdownMenuItem> items = new List();
//    DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
//      child: new Text(
//        '待接单',
//        style: TextStyle(color: Colors.grey),
//      ),
//      value: '待接单',
//    );
//    DropdownMenuItem dropdownMenuItem2 = new DropdownMenuItem(
//      child: new Text(
//        '全部',
//        style: TextStyle(color: Colors.grey),
//      ),
//      value: '全部',
//    );
//    DropdownMenuItem dropdownMenuItem3 = new DropdownMenuItem(
//      child: new Text(
//        '待接单',
//        style: TextStyle(color: Colors.grey),
//      ),
//      value: '待接单',
//    );
//    DropdownMenuItem dropdownMenuItem4 = new DropdownMenuItem(
//      child: new Text(
//        '已完成',
//        style: TextStyle(color: Colors.grey),
//      ),
//      value: '已完成',
//    );
//    DropdownMenuItem dropdownMenuItem5 = new DropdownMenuItem(
//      child: new Text(
//        '拒接单',
//        style: TextStyle(color: Colors.grey),
//      ),
//      value: '拒接单',
//    );
//    items.add(dropdownMenuItem1);
//    items.add(dropdownMenuItem2);
//    items.add(dropdownMenuItem3);
//    items.add(dropdownMenuItem4);
//    items.add(dropdownMenuItem5);
//    return items;
//  }

  void _selectDate(bool isEnd) {
    ///
    /// context: BuildContext.
    /// showTitleActions: 是否显示带有确定、取消按钮的标题栏。
    /// locale: 国际化标题文字、年、月、日，默认显示英文，'zh' 为中文。
    /// minYear: 年份选择器的最小值，默认值：1900年。
    /// maxYear: 年份选择器的最大值，默认值：2100年。
    /// initialYear: 年份选择器的初始值。
    /// initialMonth: 月份选择器的初始值。
    /// initialDate: 日期选择器的初始值。
    /// cancel: 自定义的取消按钮。
    /// confirm: 自定义的确认按钮。
    /// onChange: 当前选择的日期改变时的回调事件。
    /// onConfirm: 点击标题栏确定按钮的回调事件。
    DateTime now = new DateTime.now();
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      locale: 'zh',
      minYear: 1970,
      maxYear: now.year,
      initialYear: now.year,
      initialMonth: now.month,
      initialDate: now.day,
      cancel: Text('取消'),
      confirm: Text('确定'),
      onChanged: (year, month, date) {},
      onConfirm: (year, month, date) {
        setState(() {
          String m="";
          String d="";
          if(month<10){
            m="0$month";
          }else{
            m="$month";
          }
          if(date<10){
            d="0$date";
          }else{
            d="$date";
          }
          if (isEnd) {
            _endTime = "$year-$m-$d 23:59:59";
          } else {
            _startTime = "$year-$m-$d 00:00:00";
          }
        });
      },
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: dats?.length ?? 0,
        itemBuilder: (context, i) {
          return ListOrderItem(dats[i]);
        });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = new DateTime.now();
    int year=now.year;
    int month=now.month;
    int date=now.day;
    String m="";
    String d="";
    if(month<10){
      m="0$month";
    }else{
      m="$month";
    }
    if(date<10){
      d="0$date";
    }else{
      d="$date";
    }
    _endTime = "$year-$m-$d 23:59:59";
    _startTime = "$year-$m-$d 00:00:00";
    _requestData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("订单接收"),
        backgroundColor: AppColors.COLOR_MAIN,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _requestData();
              }),
        ],
      ),
      body: ProgressDialog(
        loading: _isloading,
        msg: "加载中...",
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "接单状态：",
                      style:
                          TextStyle(color: AppColors.COLOR_MAIN, fontSize: 15),
                    ),
                    Expanded(
                        child: Container(
                      height: 35,
                      child: DropdownButton(
                          items: <String>['待接单', '全部', '已接单', '已完成', '拒接单']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }).toList(),
                          isDense: true,
                          isExpanded: true,
                          value: _state,
                          iconSize: 35.0,
                          onChanged: (String v) {
                            setState(() {
                              _state = v;
                            });
                          }),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "起始日期：",
                      style:
                          TextStyle(color: AppColors.COLOR_MAIN, fontSize: 15),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            color: AppColors.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _startTime,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.date_range,
                                color: AppColors.COLOR_MAIN,
                              ),
                              onPressed: () {
                                _selectDate(false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "结束日期：",
                      style:
                          TextStyle(color: AppColors.COLOR_MAIN, fontSize: 15),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            color: AppColors.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _endTime,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.date_range,
                                color: AppColors.COLOR_MAIN,
                              ),
                              onPressed: () {
                                _selectDate(true);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black,
                indent: 0,
              ),
              Container(
                height: 35,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "提货时间",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "订单状态",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "客户名称",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black,
                indent: 0,
              ),
              Expanded(
                child: _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
