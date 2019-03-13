import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stander/consant/app_config.dart';
import 'package:flutter_stander/model/empty_bean.dart';
import 'package:flutter_stander/model/login_user.dart';
import 'package:flutter_stander/model/order_bean.dart';
import 'package:flutter_stander/model/result_bean.dart';
import 'package:flutter_stander/model/version_bean.dart';
import 'package:flutter_stander/net/http_urls.dart';
import 'package:flutter_stander/utils/common_util.dart';
import 'package:flutter_stander/utils/dio_util.dart';

class AppApi {
  static AppApi _singleInstance;

  static AppApi getInstance() {
    if (_singleInstance == null) {
      _singleInstance = new AppApi();
    }
    return _singleInstance;
  }

  Future<VersionBean> checkVersion(String version) async {
    Map<String, dynamic> toJson() => {
      'version': version,
    };
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post, HttpUrls.checkVersion, data: toJson());
    VersionBean user;
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }
    if (baseResp.data != null) {
      user =VersionBean.fromJson(baseResp.data);
    }
    return user;
  }

  Future<User> login(String sitecode, String usercode, String password) async {
    Map<String, dynamic> toJson() => {
          'siteCode': sitecode,
          'empCode': usercode,
          'barPassword': password,
          'empType': "司机",
        };
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post, HttpUrls.USER_LOGIN, data: toJson());
    User user;
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }
    if (baseResp.data != null) {
      user =User.fromJson(baseResp.data);
    }
    return user;
  }

  Future<List<OrderBean>> qryTAB_ORDER_CAR(String startTime, String endTime, String status,String driverCode) async {
    if(status=="全部"){
      status="";
    }
    Map<String, dynamic> toJson() => {
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'driverCode': driverCode,
    };
    BaseResp<List> baseResp = await DioUtil()
        .request<List>(Method.post, HttpUrls.qryTAB_ORDER_CAR, data: toJson());
    List<OrderBean> enitys;
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }
    if (baseResp.data != null) {
      enitys =baseResp.data.map((value) {
        return OrderBean.fromJson(value);
      }).toList();
    }
    return enitys;
  }

  Future<EmptyBean> updateUniteBill(String guid, String flag, String reason) async {
    Map<String, dynamic> toJson() => {
      'guid': guid,
      'flag': flag,
      'reason': reason,
    };
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post, HttpUrls.updateUniteBill, data: toJson());
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }
    return null;
  }

  Future<EmptyBean> uploadOtherPic(String path,String imgName) async {
    FormData formData = new FormData.from({
      "file1": new UploadFileInfo(new File(path), imgName),
      // 支持文件数组上传
    });
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .upload<Map<String, dynamic>>(HttpUrls.uploadOtherPic, data: formData);
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }else{
      CommonUtil.showToast("图片上传成功！");
      return null;
    }

  }

  Future<EmptyBean> uploadSignPic(String path,String imgName) async {
    FormData formData = new FormData.from({
      "file1": new UploadFileInfo(new File(path), imgName),
      // 支持文件数组上传
    });
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .upload<Map<String, dynamic>>(HttpUrls.uploadSign, data: formData);
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }else{
      CommonUtil.showToast("图片上传成功！");
      return EmptyBean();
    }

  }

  Future<EmptyBean> getreturnGoods(String billCode) async {
    Map<String, dynamic> toJson() => {
      'billCode': billCode,
    };
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post, HttpUrls.getreturnGoods, data: toJson());
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }
    return null;
  }

  Future<List<ResultBean>> uploadSign(String sign) async {
    Map<String, dynamic> toJson() => {
      'sign': sign,
    };
    BaseResp<List> baseResp = await DioUtil()
        .request<List>(Method.post, HttpUrls.uploadSign, data: toJson());
    List<ResultBean> enitys;
    if (baseResp.stauts != AppConfig.STATUS_SUCCESS) {
      if (!ObjectUtil.isEmptyString(baseResp.msg)) {
        CommonUtil.showToast(baseResp.msg);
      }
      return null;
    }
    if (baseResp.data != null) {
      enitys =baseResp.data.map((value) {
        return ResultBean.fromJson(value);
      }).toList();
    }
    return enitys;
  }
}
