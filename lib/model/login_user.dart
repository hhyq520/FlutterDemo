import 'dart:convert';
class User {
  String empCode;
  String empName;
  String siteName;
  String siteCode;
  String barPassword;
  String deptName;
  String systemDate;
  String driverCode;

  String superiorFinanceCenter;

  User(
      this.empCode,
      this.empName,
      this.siteName,
      this.siteCode,
      this.barPassword,
      this.deptName,
      this.systemDate,
      this.driverCode,
      this.superiorFinanceCenter);
  User.fromJson(Map userMap) {
     empCode = userMap['empCode'];
     empName = userMap['empName'];
     siteName = userMap['siteName'];
     siteCode = userMap['siteCode'];
     barPassword = userMap['barPassword'];
     deptName = userMap['deptName'];
     systemDate = userMap['systemDate'];
     driverCode = userMap['driverCode'];
     superiorFinanceCenter = userMap['superiorFinanceCenter'];
  }


  String toJson() {
     Map<String, dynamic> userMap = new Map();
     userMap['empCode'] = empCode;
     userMap['driverCode'] = driverCode;
     userMap['empName'] = empName;
     userMap['siteName'] = siteName;
     userMap['siteCode'] = siteCode;
     userMap['barPassword'] = barPassword;
     userMap['deptName'] = deptName;
     userMap['systemDate'] = systemDate;
     userMap['superiorFinanceCenter'] = superiorFinanceCenter;

     return json.encode(userMap);
  }
}
