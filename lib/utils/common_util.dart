import 'package:flutter/material.dart';
import 'package:flutter_stander/ui/widget/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CommonUtil{
  static void showToast(String tip) async{
    Fluttertoast.showToast(
        msg: tip,
        backgroundColor: Colors.black,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white);
  }
}