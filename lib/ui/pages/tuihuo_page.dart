import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/manager/db_manager.dart';
import 'package:flutter_stander/manager/user_manager.dart';
import 'package:flutter_stander/model/result_bean.dart';
import 'package:flutter_stander/model/tuihuo_bean.dart';
import 'package:flutter_stander/model/upload_sign.dart';
import 'package:flutter_stander/net/app_api.dart';
import 'package:flutter_stander/ui/pages/camera_screen.dart';
import 'package:flutter_stander/ui/widget/progress_dialog.dart';
import 'package:flutter_stander/ui/widget/tuihuo_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stander/utils/common_util.dart';
import 'package:image_picker/image_picker.dart';
export 'package:common_utils/common_utils.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
class TuiHuo extends StatefulWidget {
  static const String ROUTE_NAME = "tuihuo";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TuihuoState();
  }
}

class TuihuoState extends State<TuiHuo> {
  bool _isloading = false;
  bool _isTakePhoto = true;
  String _billcode = "";
  String _signMan = "";
  String _sendMan = "";
  String _imagePath;
  TuihuoDataSource _dataSource;
  TextEditingController billCodeController = new TextEditingController();
  void _saveData() {
    if(ObjectUtil.isEmptyString(_billcode)){
      CommonUtil.showToast("运单编号为空！");
      return;
    }
    if(ObjectUtil.isEmptyString(_signMan)){
      CommonUtil.showToast("签收人为空！");
      return;
    }
    if(ObjectUtil.isEmptyString(_sendMan)){
      CommonUtil.showToast("送货人为空！");
      return;
    }
//    setState(() {
//      _isloading = true;
//    });
//    AppApi.getInstance()
//        .getreturnGoods(_billcode)
//        .then((bean) {
//      setState(() {
//        _isloading = false;
//      });
      UserManager.getUserFromLocalStorage().then((user){
        DBManger.queryNum(_billcode,user.empCode).then((count){
          if(count>0){
            CommonUtil.showToast("已扫！");
          }else{
            if(_isTakePhoto){
              _showPicDialog();
            }else{
              DateTime now = new DateTime.now();
              TuiHuoBean tuiHuoBean=TuiHuoBean(_billcode, _signMan, now.toString(), user.empName, user.empCode, _sendMan, "", "", 1, 0);
              DBManger.addTuihuo(tuiHuoBean).then((s){
                DBManger.query().then((list){
                  List<TuiHuoBean> ss=list.map((value) {
                    return TuiHuoBean.fromJson(value);
                  }).toList();
                  _dataSource.setDatas(ss);
                });
              });
            }
          }
        });
//      });

    });
  }
  Future _scanCode() async{
    try {
      String barcode = await BarcodeScanner.scan();
      print("zzzzzzzzz"+barcode);
      billCodeController.value=TextEditingValue(
        text: barcode,
      );
      setState(() {
        this._billcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
           this._billcode = '';
        });
      } else {
        setState(() {
           this._billcode = '';
        });
      }

    } on FormatException{
      setState(() => this._billcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this._billcode = 'Unknown error: $e');
    }
  }

  void _upPictures(){
    UserManager.getUserFromLocalStorage().then((user) {
      DBManger.queryNotUploadImgs(user.empCode).then((list){
        List<TuiHuoBean> ss=list.map((value) {
          return TuiHuoBean.fromJson(value);
        }).toList();
        for (TuiHuoBean item in ss){
          if(!ObjectUtil.isEmptyString(item.imgPath)){
            String ext=item.imgPath.substring(item.imgPath.lastIndexOf(".") + 1);
            String imgName=user.siteCode
                + "_"
                + user.empCode
                + "_"
                + item.billcode+"."+ext;
            AppApi.getInstance().uploadSignPic(item.imgPath,imgName).then((bean){
              if(bean!=null)
                  DBManger.updateImgdata(item.billcode);
            });
          }
        }
      });
    });

  }

  void _upload(){

    //上传数据
    UserManager.getUserFromLocalStorage().then((user){
      DBManger.queryNotUpload(user.empCode).then((list){
        List<TuiHuoBean> ss=list.map((value) {
          return TuiHuoBean.fromJson(value);
        }).toList();
        if(ss.length<=0){
          CommonUtil.showToast("无数据需要上传！");
        }else {
          List<UploadSignBean> datas=new List();
          for (TuiHuoBean item in ss){
            UploadSignBean uploadSignBean=new UploadSignBean();
            uploadSignBean.id=item.id;
            uploadSignBean.billCode=item.billcode;
            uploadSignBean.dispachName=item.scanMan;
            uploadSignBean.signDate=item.scanTime;
            uploadSignBean.signName=item.signMan;
            uploadSignBean.dispachNameCode=item.employCode;
            uploadSignBean.recordName=user.siteName;
            uploadSignBean.recordNameCode=user.siteCode;
            uploadSignBean.recordSite=user.siteName;
            uploadSignBean.recordSiteNo=user.siteCode;
            datas.add(uploadSignBean);
          }
          setState(() {
            _isloading=true;
          });

          AppApi.getInstance().uploadSign(jsonEncode(datas)).then((list){
            setState(() {
              _isloading=false;
            });
            DBManger.updateDatas(list).then((v){
              //上传图片
              _upPictures();
            });
          });
        }
      });
    });
  }

  void _showPicDialog() {
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
                height: 150,
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "是否需要拍照？",
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

  Future<File> _showPicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String ext = image.path.substring(image.path.lastIndexOf(".") + 1);
    String pa=image.path.substring(0,image.path.lastIndexOf("."));
    testCompressFile(File(image.path)).then((flie){
      setState(() {
        _imagePath = image.path;
      });

      if (!ObjectUtil.isEmptyString(_imagePath)) {
        print("$_imagePath");
        UserManager.getUserFromLocalStorage().then((user){
          DateTime now = new DateTime.now();
          TuiHuoBean tuiHuoBean=TuiHuoBean(_billcode, _signMan, now.toString(), user.empName, user.empCode, _sendMan, "", _imagePath, 0, 0);
          DBManger.addTuihuo(tuiHuoBean).then((ss){
            DBManger.query().then((list){
              List<TuiHuoBean> ss=list.map((value) {
                return TuiHuoBean.fromJson(value);
              }).toList();
              _dataSource.setDatas(ss);
            });
          });
        });
      }
    });


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
    String ext = imagePath.substring(imagePath.lastIndexOf(".") + 1);
    String pa=imagePath.substring(0,imagePath.lastIndexOf("."));
    testCompressFile(File(imagePath)).then((flie){
      setState(() {
        _imagePath = imagePath;
      });
      if (!ObjectUtil.isEmptyString(_imagePath)) {
        UserManager.getUserFromLocalStorage().then((user){
          DateTime now = new DateTime.now();
          TuiHuoBean tuiHuoBean=TuiHuoBean(_billcode, _signMan, now.toString(), user.empName, user.empCode, _sendMan, "", _imagePath, 0, 0);
          DBManger.addTuihuo(tuiHuoBean).then((ss){
            DBManger.query().then((list){
              List<TuiHuoBean> ss=list.map((value) {
                return TuiHuoBean.fromJson(value);
              }).toList();
              _dataSource.setDatas(ss);
            });
          });
        });
      }
    });
  }


    Future<List<int>> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 90,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.length);

    return result;
  }

  void _delete(){
    if(_dataSource.getDatas()!=null){
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
                  height:150,
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "是否删除勾选本地数据？",
                        style: TextStyle(color: Colors.black),
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
                          List<String> billcodes=new List();
                          for (TuiHuoBean dessert in _dataSource.getDatas()){
                            if(dessert.isSelect){
                              print("ssssss"+dessert.billcode);
                              billcodes.add(dessert.billcode);
                            }
                          }
                          DBManger.deleteTuihuo(billcodes).then((s){
                            DBManger.query().then((list){
                              List<TuiHuoBean> ss=list.map((value) {
                                return TuiHuoBean.fromJson(value);
                              }).toList();
                              _dataSource.setDatas(ss);
                            });
                          });
                          Navigator.of(context).pop();
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<TuiHuoBean> init=new List();
    _dataSource=TuihuoDataSource(init);
    DBManger.query().then((list){
      List<TuiHuoBean> ss=list.map((value) {
        return TuiHuoBean.fromJson(value);
      }).toList();
      _dataSource.setDatas(ss);
    });


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("退件签收"),
        centerTitle: true,
        backgroundColor: AppColors.COLOR_MAIN,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveData();
              }),
        ],
      ),
      body: ProgressDialog(
        loading: _isloading,
        msg: "加载中...",
        child: Container(
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Center(
                child: CheckboxListTile(
                  title: Text("是否拍照"),
                  value: _isTakePhoto,
                  onChanged: (v) {
                    setState(() {
                      _isTakePhoto = v;
                    });
                  },
                  activeColor: AppColors.COLOR_MAIN,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "运单编号：",
                    style: TextStyle(color: AppColors.COLOR_MAIN, fontSize: 15),
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
                              child: TextField(
                            keyboardType: TextInputType.text,
                                controller: billCodeController,
                            onChanged: (value) {
                              _billcode = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          )),
                          IconButton(
                            icon: Image.asset("images/scan.png"),
                            onPressed: () {
                              _scanCode();
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
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "签收人：",
                    style: TextStyle(color: AppColors.COLOR_MAIN, fontSize: 15),
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
                              child: TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              _signMan = value;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "请填写签收人"),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "送货人：",
                    style: TextStyle(color: AppColors.COLOR_MAIN, fontSize: 15),
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
                              child: TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              _sendMan = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Divider(
              height: 1,
              color: Colors.black,
              indent: 0,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  PaginatedDataTable(
                    actions: <Widget>[/*跟header 在一条线的antion*/
                      IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: _delete),
                    ],
                    header: const Center(child: Text("扫描数据"),),
                    sortAscending:true,
                    rowsPerPage: 5,
                    onSelectAll: _dataSource.selectAll,
                    columns: [
                      DataColumn(
                        label: Text(
                          "运单号",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "签收人",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "送货人",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "扫描时间",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "上传图片",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "上传结果",
                          style: TextStyle(
                              color: AppColors.COLOR_BLACK, fontSize: 14),
                        ),
                      ),
                    ],
                    source: _dataSource,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Text(
                        "上传",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _upload,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

}
