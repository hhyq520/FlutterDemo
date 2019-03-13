import 'dart:core';

class TuiHuoBean{
  int id;///主键
  String billcode;
  String signMan;
  String scanTime;
  String scanMan;
  String employCode;
  String sendMan;
  String errMsg;
  String imgPath;
  int isImgUpload=0;///0 未上传  1上传成功
  int isDataUpload=0;///0 未上传 1上传成功
  bool isSelect=true;

  TuiHuoBean(this.billcode, this.signMan, this.scanTime, this.scanMan,
      this.employCode, this.sendMan, this.errMsg, this.imgPath,
      this.isImgUpload, this.isDataUpload);

  TuiHuoBean.fromJson(Map userMap) {
    billcode = userMap['billcode'];
    signMan = userMap['signMan'];
    scanTime = userMap['scanTime'];
    scanMan = userMap['scanMan'];
    employCode = userMap['employCode'];
    sendMan = userMap['sendMan'];
    errMsg = userMap['errMsg'];
    imgPath = userMap['imgPath'];
    isImgUpload = userMap['isImgUpload'];
    isDataUpload = userMap['isDataUpload'];
    id = userMap['id'];
  }
}