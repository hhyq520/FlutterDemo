import 'dart:convert';

class ResultBean{
   String id;
   String msg;
   bool isSuccess;
   ResultBean.fromJson(Map userMap) {
     id = userMap['id'];
     msg = userMap['msg'];
   }

   String toJson() {
     Map<String, dynamic> userMap = new Map();
     userMap['id'] = id;
     userMap['msg'] = msg;
     return json.encode(userMap);
   }
}