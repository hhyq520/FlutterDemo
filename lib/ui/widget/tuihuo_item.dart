import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/model/order_bean.dart';
import 'package:flutter_stander/model/tuihuo_bean.dart';
import 'package:flutter_stander/ui/pages/order_detail.dart';

class TuihuoItem extends StatefulWidget {
  final TuiHuoBean orderBean;
  TuihuoItem(this.orderBean);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TuihuoItemState();
  }
}

class TuihuoItemState extends State<TuihuoItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        child: Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 35,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: Center(
                      child: Text(
                        "运单号",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        "签收人",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        "送货人",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    width: 150,
                    child: Center(
                      child: Text(
                        "扫描时间",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    width: 150,
                    child: Center(
                      child: Text(
                        "上传图片",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    width: 150,
                    child: Center(
                      child: Text(
                        "上传结果",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
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
          ],
        ),
        scrollDirection: Axis.horizontal,
      ),
    ));
  }
}
