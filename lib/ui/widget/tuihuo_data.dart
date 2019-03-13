import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stander/model/tuihuo_bean.dart';

class TuihuoDataSource extends DataTableSource {
  List<TuiHuoBean> _tuiHuoBean;
  TuihuoDataSource(this._tuiHuoBean);
  void setDatas(List<TuiHuoBean> list) {
    _tuiHuoBean = list;
    notifyListeners();
  }

  List<TuiHuoBean> getDatas() {
    return _tuiHuoBean;
  }
  int _selectedCount = 0;
  @override
  DataRow getRow(int index) {
    // TODO: implement getRow
    final TuiHuoBean dessert = _tuiHuoBean[index];
    return DataRow.byIndex(
        index: index,
        selected: dessert.isSelect,
        onSelectChanged: (bool value) {
          if (dessert.isSelect != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            dessert.isSelect = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text('${dessert.billcode}')),
          DataCell(Text('${dessert.signMan}')),
          DataCell(Text('${dessert.sendMan}')),
          DataCell(Text('${dessert.scanTime}')),
          img(dessert.imgPath),
          result(dessert.errMsg,dessert.isDataUpload,dessert.isImgUpload),
        ]);
  }

  DataCell result(String errmsg,int IsDataUpload,int IsImgUpload) {
    if (ObjectUtil.isEmptyString(errmsg)) {
      if (IsDataUpload==1) {
        if (IsImgUpload==1) {
          return DataCell(Text("数据已上传，图片已上传"));
        } else {
          return DataCell(Text("数据已上传，图片上传失败"));
        }
      } else {
        return DataCell(Text("数据未上传"));
      }
    } else {
      if (IsDataUpload==1) {
        if (IsImgUpload==1) {
          return DataCell(Text("数据已上传，图片已上传"));
        } else {
          return DataCell(Text("数据已上传，图片上传失败"));
        }
      } else {
        return DataCell(Text('$errmsg'));
      }
    }
  }

  DataCell img(String path) {
    if (ObjectUtil.isEmptyString(path)) {
      return DataCell(Text('${"sss"}'));
    } else {
      return DataCell(Image.file(File(path)));
    }
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _tuiHuoBean != null ? _tuiHuoBean.length : 0;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void selectAll(bool checked) {
    if (_tuiHuoBean != null) {
      for (TuiHuoBean dessert in _tuiHuoBean) dessert.isSelect = checked;
      _selectedCount = checked ? _tuiHuoBean.length : 0;
      notifyListeners();
    } else {
      _selectedCount = 0;
      notifyListeners();
    }
  }
}
