import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stander/consant/app_config.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/manager/user_manager.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/model/order_bean.dart';
import 'package:flutter_stander/net/app_api.dart';
import 'package:flutter_stander/ui/pages/camera_screen.dart';
import 'package:flutter_stander/ui/widget/progress_dialog.dart';
import 'package:flutter_stander/utils/common_util.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetail extends StatefulWidget {
  final OrderBean orderBean;

  OrderDetail(this.orderBean);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new OrderDetailState();
  }
}

class OrderDetailState extends State<OrderDetail> {
  bool _isloading = false;
  bool _isRecEnable = true;
  bool _isFinEnable = true;
  bool _isFailEnable = true;
  String _state = "";
  String _reason = "";
  String _imagePath;
  void _receiveOrder(String reason, final String flag, final String path) {
    setState(() {
      _isloading = true;
    });
    AppApi.getInstance()
        .updateUniteBill(widget.orderBean.GUID, flag, reason)
        .then((bean) {
      setState(() {
        _isloading = false;
      });
      CommonUtil.showToast("操作成功");
      if (flag == "0") {
        setState(() {
          _state = "拒接单";
          _isFailEnable = false;
        });
      } else if (flag == "1") {
        setState(() {
          _state = "已接单";
          _isRecEnable = false;
        });
      } else if (flag == "2") {
        setState(() {
          _state = "已完成";
        });
        if (path != null) {
            uploadImage(path);
        }
      }
    });
  }

  Future uploadImage(String path) async{
//    /storage/emulated/0/yasuo/终极压缩.jpg
    setState(() {
      _isloading = true;
    });
    String ext = path.substring(path.lastIndexOf(".") + 1);
    User user= await UserManager.getUserFromLocalStorage();
    String imgName = user.siteCode
        + "_"
        + user.empCode
        + "_"
        + widget.orderBean.GUID + "." + ext;
    print(imgName);
    AppApi.getInstance().uploadOtherPic(path,imgName).then((list){
      setState(() {
        _isloading = false;
      });
    });
  }

  Future<File> _showPicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image.path;
    });

    if (!ObjectUtil.isEmptyString(_imagePath)) {
      print("$_imagePath");
      _receiveOrder("", "2", _imagePath);
    }
  }

  Future _openCamera() async {
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      //logError(e.code, e.description);
    }
    final imagePath = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CameraHomeScreen(cameras);
    }));
    setState(() {
      _imagePath = imagePath;
    });

    if (!ObjectUtil.isEmptyString(_imagePath)) {
      print("$imagePath");
      _receiveOrder("", "2", _imagePath);
    }
  }

  void _showSuccessDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Container(
                height: 200,
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "是否需要上传提货单图片？",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              "相册",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showPicture();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              "相机",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _openCamera();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        "确定",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _receiveOrder("", "2", null);
                      },
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _showFailDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Container(
                height: 200,
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "请输入拒接原因",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _reason = value;
                      },
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "请输入拒接原因",
                        hintStyle: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        "确定",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (ObjectUtil.isEmptyString(_reason)) {
                          CommonUtil.showToast("失败原因为空！");
                        } else {
                          Navigator.of(context).pop();
                          _receiveOrder(_reason, "0", null);
                        }
                      },
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  _rec() {
    if (_isRecEnable) {
      return () {
        _receiveOrder("", "1", null);
      };
    } else {
      return null;
    }
  }

  _fin() {
    if (_isFinEnable) {
      return () {
        _showSuccessDialog();
      };
    } else {
      return null;
    }
  }

  _fail(BuildContext context) {
    if (_isFailEnable) {
      return () {
        _showFailDialog(context);
      };
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _state = widget.orderBean.PICK_STATUS;
    if ("已接单" == _state) {
      _isRecEnable = false;
    }
    if ("已完成" == _state) {
      _isFinEnable = false;
    }
    if ("拒接单" == _state) {
      _isFailEnable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("订单详情"),
        backgroundColor: AppColors.COLOR_MAIN,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ),
      body: ProgressDialog(
        loading: _isloading,
        msg: "加载中...",
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "订单状态：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          _state ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "客户编号：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.CUSTOMER_CODE ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "客户名称：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.CUSTOMER_NAME ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "客户联系人：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.CUSTOMER_LINKMAN ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "客户取件地址：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.CUSTOMER_ADDRESS ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "客户电话：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.CUSTOMER_PHONE1 ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "件数：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.SUM_PIECE?.toString() ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "实重：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.TOTAL_WEIGHTT?.toString() ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "材积：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.TOTAL_VOLUME?.toString() ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "提货时间：",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          widget.orderBean.PICK_FINISH_DATE ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "提货完成",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _fin(),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "拒接单",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _fail(context),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "接单",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _rec(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
